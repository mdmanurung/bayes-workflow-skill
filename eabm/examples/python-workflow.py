#!/usr/bin/env python3
"""Run a small EABM-style Normal vs Student-t criticism/comparison workflow.

Purpose: verify current PyMC/ArviZ APIs and targeted tail checks.
Inputs: output directory and draw settings; simulated outcomes with tail contamination.
Assumptions: independent measurements; priors in toy standardized units.
Expected output: diagnostics/PPC/LOO/sensitivity files and checked plot APIs.
Interpretation: repairs to computation, adequacy and scoring are separate.
Failure modes: high Pareto-k or poor sampling require action, not a winner declaration.
Next action: inspect files, record model change, repair unresolved checks.
Source: E04-E09; original short synthesized example, not copied book data.
"""
import argparse
import json
from pathlib import Path
import warnings
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pymc as pm
import arviz as az
from arviz_stats.base import array_stats


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--draws", type=int, default=800)
    parser.add_argument("--tune", type=int, default=1000)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(17)
    registry = json.loads((Path(__file__).resolve().parents[1] / "references/thresholds.json").read_text())
    toy_quantile_precision_budget = 0.05  # standardized outcome units; stated example decision
    y = rng.normal(0.4, 1.0, 80)
    y[[4, 67]] = [7.5, -5.5]
    pd.DataFrame({"obs_id": np.arange(y.size), "y": y}).to_csv(args.output_dir / "data.csv", index=False)
    fits, models, prior_checks, ppc_records, loo_results, diagnostic_records = {}, {}, {}, [], {}, {}
    for index, family in enumerate(["normal", "student"]):
        with pm.Model(coords={"obs_id": np.arange(y.size)}) as model:
            mu = pm.Normal("mu", 0, 2)
            sigma = pm.HalfNormal("sigma", 2)
            if family == "normal":
                pm.Normal("y", mu, sigma, observed=y, dims="obs_id")
            else:
                # Fixed finite-variance tail family for a transparent comparison.
                pm.StudentT("y", nu=5, mu=mu, sigma=sigma, observed=y, dims="obs_id")
            prior = pm.sample_prior_predictive(draws=300, random_seed=31 + index)
            # This API integration example records scales; a real analysis needs
            # domain validation of prior predictions before proceeding to fit.
            dt = pm.sample(draws=args.draws, tune=args.tune, chains=4, cores=2,
                           random_seed=21 + index, progressbar=False,
                           idata_kwargs={"log_prior": True})
            pm.compute_log_likelihood(dt, progressbar=False)
            pm.sample_posterior_predictive(dt, var_names=["y"], extend_inferencedata=True,
                                          random_seed=51 + index, progressbar=False)
        fits[family], models[family] = dt, model
        summary = az.summary(dt, var_names=["mu", "sigma"], ci_kind="eti", ci_prob=.95, round_to=5)
        summary.to_csv(args.output_dir / f"{family}-diagnostics.csv")
        diagnostic_records[family] = {
            "divergences": dt["sample_stats"]["diverging"].sum("draw").values.tolist(),
            "bfmi": az.bfmi(dt)["energy"].values.tolist(),
            "q95_mcse": {v: float(a) for v, a in az.mcse(dt, var_names=["mu", "sigma"], method="quantile", prob=.95).to_dataset().data_vars.items()},
        }
        if (summary.r_hat.max() >= registry["rhat"]["upper_exclusive"]
            or min(summary.ess_bulk.min(), summary.ess_tail.min()) < registry["ess"]["minimum_per_chain"] * 4
            or sum(diagnostic_records[family]["divergences"]) > registry["divergences"]["target_post_warmup"]
            or min(diagnostic_records[family]["bfmi"]) < registry["bfmi"]["warning_below"]
            or max(diagnostic_records[family]["q95_mcse"].values()) > toy_quantile_precision_budget):
            raise RuntimeError("Computational screen failed: inspect mechanisms before PPC/LOO")
        yrep = dt["posterior_predictive"]["y"].values.reshape(-1, y.size)
        for stat, obs, rep in [
            ("mean", y.mean(), yrep.mean(axis=1)),
            ("sd", y.std(), yrep.std(axis=1)),
            ("max", y.max(), yrep.max(axis=1)),
            ("q95", np.quantile(y, .95), np.quantile(yrep, .95, axis=1)),
            ("abs_above_4", np.mean(np.abs(y) > 4), np.mean(np.abs(yrep) > 4, axis=1)),
        ]:
            ppc_records.append({"model": family, "stat": stat, "observed": float(obs),
                                "rep_q05": float(np.quantile(rep,.05)),
                                "rep_median": float(np.median(rep)), "rep_q95": float(np.quantile(rep,.95))})
        prior_checks[family] = {"q99_abs_y": float(np.quantile(np.abs(prior["prior_predictive"]["y"]),.99))}
        az.plot_trace_dist(dt, var_names=["mu", "sigma"])
        plt.savefig(args.output_dir / f"{family}-trace.png", dpi=110); plt.close("all")
        az.plot_rank(dt, var_names=["mu", "sigma"])
        plt.savefig(args.output_dir / f"{family}-rank.png", dpi=110); plt.close("all")
        az.plot_energy(dt)
        plt.savefig(args.output_dir / f"{family}-energy.png", dpi=110); plt.close("all")
        az.plot_pair(dt, var_names=["mu", "sigma"], visuals={"divergence": True})
        plt.savefig(args.output_dir / f"{family}-pair.png", dpi=110); plt.close("all")
        az.plot_ppc_tstat(dt, var_names=["y"], t_stat="max")
        plt.savefig(args.output_dir / f"{family}-ppc-max.png", dpi=110); plt.close("all")
        loo_results[family] = az.loo(dt, var_name="y", pointwise=True)
        pd.DataFrame({"obs_id": np.arange(y.size), "pareto_k": loo_results[family].pareto_k.values,
                      "elpd_i": loo_results[family].elpd_i.values}).to_csv(args.output_dir / f"{family}-loo.csv", index=False)
    pd.DataFrame(ppc_records).to_csv(args.output_dir / "targeted-ppc.csv", index=False)
    power_checks = []
    for group, terms in [("log_prior", ["mu", "sigma"]), ("log_likelihood", ["y"])]:
        total = None
        for term in terms:
            factor = fits["normal"][group][term]
            dims = [d for d in factor.dims if d not in ("chain", "draw")]
            factor = factor.sum(dims) if dims else factor
            total = factor if total is None else total + factor
        lc = total.transpose("chain", "draw").values.reshape(-1)
        reff = min(1.0, float(az.ess(total, method="mean")) / lc.size)
        limit = min(1 - 1 / np.log10(lc.size), registry["pareto_k"]["cap"])
        for alpha in registry["power_sensitivity"]["alphas"]:
            lw, k = array_stats.psislw(-(alpha-1)*lc, r_eff=reff)
            power_checks.append({"component":group, "alpha":alpha,"pareto_k":float(k),
                                 "weight_ess":float(1/np.sum(np.exp(lw)**2))})
            if k > limit:
                raise RuntimeError("Power-sensitivity IS unreliable: use justified refits")
    pd.DataFrame(power_checks).to_csv(args.output_dir / "power-weights.csv", index=False)
    sensitivity = az.psense_summary(fits["normal"], var_names=["mu", "sigma"],
                                    prior_var_names=["mu", "sigma"], likelihood_var_names=["y"])
    sensitivity.to_csv(args.output_dir / "sensitivity.csv")
    az.plot_psense_quantities(fits["normal"], var_names=["mu"], alphas=[.99,1.01], mcse=True)
    plt.savefig(args.output_dir / "sensitivity-mu.png", dpi=110); plt.close("all")
    sub = az.loo_subsample(fits["student"], observations=20, method="plpd",
                           model=models["student"], var_name="y", pointwise=True, seed=42)
    larger = az.update_subsample(sub, fits["student"], observations=40, method="plpd",
                                 model=models["student"], var_name="y", seed=42)
    # Attempt supported MM even if no observation currently requires it.
    mm = az.loo(fits["normal"], var_name="y", pointwise=True,
                 moment_match=True, model=models["normal"])
    # Preserve original diagnostics, but compare only repaired/reliable estimates.
    if bool((mm.pareto_k > mm.good_k).any()) or loo_results["student"].warning:
        raise RuntimeError("Unresolved PSIS warnings: refit/folds before comparison")
    comparison = az.compare({"normal": mm, "student": loo_results["student"]}, method="stacking")
    comparison.to_csv(args.output_dir / "comparison.csv")
    result = {"draws_per_chain": args.draws, "warmup_per_chain": args.tune, "chains": 4,
              "toy_quantile_precision_budget": toy_quantile_precision_budget,
              "diagnostics": diagnostic_records, "prior_checks": prior_checks,
              "loo": {n:{"elpd":float(l.elpd),"se":float(l.se),"good_k":float(l.good_k),
                         "max_k":float(l.pareto_k.max())} for n,l in loo_results.items()},
              "moment_matching": {"max_original_k":float(loo_results['normal'].pareto_k.max()),
                                  "max_repaired_k":float(mm.pareto_k.max())},
              "subsampling": [{"size":int(l.subsample_size),"elpd":float(l.elpd),
                                "subsampling_se":float(l.subsampling_se)} for l in [sub,larger]],
              "scope": "small current-API integration example; scores are not an automatic selection rule"}
    (args.output_dir / "workflow-summary.json").write_text(json.dumps(result,indent=2) + "\n")
    print(json.dumps(result,indent=2))


if __name__ == "__main__":
    main()

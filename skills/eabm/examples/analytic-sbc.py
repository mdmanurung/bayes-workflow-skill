#!/usr/bin/env python3
"""Analytic SBC mechanics plus a deliberately biased positive control.

Purpose: check truth/posterior ranks, including a data-dependent quantity.
Inputs: output directory; Normal prior and known-scale likelihood below.
Assumptions: independent exact posterior draws; continuous quantities; proper prior.
Expected output: all rank records, diagnostic summary and rank histograms.
Interpretation: consistency at this simulation resolution, not proof of correctness.
Failure modes: dependent/tied ranks and fitter/generator mismatch in adaptations.
Next action: replace inference step with actual fitting and track fit failures.
Source: E13, M-SBC-PRIOR, M-SBC; example synthesized.
"""
import argparse
import json
from pathlib import Path
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.stats import norm, binom


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--simulations", type=int, default=1000)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(41)
    n, prior_sd, noise_sd, M = 12, 2.0, 1.0, 100
    records = []
    for i in range(args.simulations):
        truth = rng.normal(0, prior_sd)
        y = rng.normal(truth, noise_sd, n)
        variance = 1 / (1 / prior_sd**2 + n / noise_sd**2)
        mean = variance * y.sum() / noise_sd**2
        draws = rng.normal(mean, np.sqrt(variance), M)
        biased = draws + 1.0  # positive control, not a proposed inference algorithm
        ll_truth = norm.logpdf(y, truth, noise_sd).sum()
        ll_draws = norm.logpdf(y[None, :], draws[:, None], noise_sd).sum(axis=1)
        records.append({"simulation": i, "mu_rank": int(np.sum(draws < truth)),
                        "loglik_rank": int(np.sum(ll_draws < ll_truth)),
                        "biased_mu_rank": int(np.sum(biased < truth))})
    frame = pd.DataFrame(records)
    frame.to_csv(args.output_dir / "sbc-ranks.csv", index=False)
    # Exact discrete-uniform mean/variance; descriptive resolution, not a p-value.
    mean_se = np.sqrt(M * (M + 2) / (12 * args.simulations))
    report = {"simulations": args.simulations, "rank_draws": M, "fit_failures": 0,
              "uniform_rank_mean": M / 2, "uniform_mean_se": float(mean_se),
              "mean_ranks": frame.drop(columns="simulation").mean().to_dict(),
              "scope": "analytic independent-draw smoke test; not custom MCMC validation"}
    (args.output_dir / "sbc-summary.json").write_text(json.dumps(report, indent=2) + "\n")
    fig, axes = plt.subplots(1, 3, figsize=(12, 3.4))
    for ax, variable in zip(axes, ["mu_rank", "loglik_rank", "biased_mu_rank"]):
        ax.hist(frame[variable], bins=np.linspace(-0.5, M + 0.5, 11), color="#276b80")
        ax.set(title=variable.replace("_", " "), xlabel="Rank", ylabel="Simulations")
    fig.tight_layout()
    fig.savefig(args.output_dir / "sbc-ranks.png", dpi=130)
    grid = np.arange(M + 1)
    reference_cdf = (grid + 1) / (M + 1)
    lower = binom.ppf(.025, args.simulations, reference_cdf) / args.simulations - reference_cdf
    upper = binom.ppf(.975, args.simulations, reference_cdf) / args.simulations - reference_cdf
    fig, axes = plt.subplots(1, 3, figsize=(12, 3.4))
    for ax, variable in zip(axes, ["mu_rank", "loglik_rank", "biased_mu_rank"]):
        empirical = (frame[variable].values[:, None] <= grid[None, :]).mean(axis=0)
        ax.fill_between(grid, lower, upper, color="#acc9d1", alpha=.7)
        ax.step(grid, empirical - reference_cdf, where="post", color="#276b80")
        ax.axhline(0, color="black", linewidth=.6)
        ax.set(title=variable.replace("_", " "), xlabel="Rank", ylabel="ECDF − discrete uniform")
    fig.suptitle("Pointwise 95% binomial bands; not simultaneous")
    fig.tight_layout()
    fig.savefig(args.output_dir / "sbc-ecdf.png", dpi=130)
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()

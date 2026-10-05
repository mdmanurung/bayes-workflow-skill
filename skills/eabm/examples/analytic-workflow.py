#!/usr/bin/env python3
"""Shared R/Python likelihood validation with a known Normal posterior.

Purpose: validate representation, diagnostics, PSIS, sensitivity and exact LOO.
Inputs: explicit output directory; synthetic iid Normal data and proper priors.
Assumptions: known noise SD=1; analytic independent draws, not fabricated MCMC.
Expected output: shared data/draw CSVs, score/diagnostic/weight records and plots.
Interpretation: runtime API/numerical validation, not evidence for a real model.
Failure modes: axis/order mismatch; densities include wrong components.
Next action: compare R outputs on the same draws; adapt scientific quantities.
Source: E02/E04/E06/E07, M-LOO/M-SENSE; synthesized analytic example.
"""
import argparse
import json
from pathlib import Path
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.stats import norm
import arviz as az
from arviz_stats.base import array_stats
import preliz as pz


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(71)
    y = rng.normal(0.5, 1, 40)
    pd.DataFrame({"obs_id":np.arange(y.size),"y":y}).to_csv(args.output_dir/"data.csv",index=False)
    fits, loos, weights = {}, {}, []
    for name, sd_prior in [("base", 2.0), ("strong", 0.2)]:
        variance = 1 / (1 / sd_prior**2 + y.size)
        mean = variance * y.sum()
        mu = rng.normal(mean,np.sqrt(variance),size=(4,1500))
        ll = norm.logpdf(y[None,None,:],mu[:,:,None],1)
        lp = norm.logpdf(mu,0,sd_prior)
        yrep = rng.normal(mu[:,:,None],1,size=(4,1500,y.size))
        dt = az.from_dict({"posterior":{"mu":mu},"log_prior":{"mu":lp},
                           "log_likelihood":{"y":ll},"posterior_predictive":{"y":yrep},
                           "observed_data":{"y":y}},coords={"obs_id":np.arange(y.size)},
                          dims={"y":["obs_id"]})
        fits[name] = dt
        pd.DataFrame({"chain":np.repeat(np.arange(4),1500),"draw":np.tile(np.arange(1500),4),
                      "mu":mu.reshape(-1)}).to_csv(args.output_dir/f"{name}-draws.csv",index=False)
        az.summary(dt,ci_kind="eti",ci_prob=.95,round_to=8).to_csv(args.output_dir/f"{name}-summary.csv")
        loos[name] = az.loo(dt,var_name="y",pointwise=True,reff=1)
        leave_variance = 1/(1/sd_prior**2+y.size-1)
        leave_mean = leave_variance*(y.sum()-y)
        exact = norm.logpdf(y,leave_mean,np.sqrt(1+leave_variance))
        pd.DataFrame({"obs_id":np.arange(y.size),"elpd_i":loos[name].elpd_i.values,
                      "pareto_k":loos[name].pareto_k.values,"exact_elpd_i":exact,
                      "difference":loos[name].elpd_i.values-exact}).to_csv(args.output_dir/f"{name}-loo.csv",index=False)
        for component,logfactor in [("prior",lp), ("likelihood",ll.sum(axis=-1))]:
            for alpha in [.8,.99,1.01,1.25]:
                lw,k=array_stats.psislw(-(alpha-1)*logfactor.reshape(-1),r_eff=1)
                w=np.exp(lw)
                weights.append({"model":name,"component":component,"alpha":alpha,
                                "pareto_k":float(k),"weight_ess":float(1/(w*w).sum())})
        az.psense_summary(dt,alphas=(.99,1.01),round_to=8).to_csv(args.output_dir/f"{name}-sensitivity.csv")
    pd.DataFrame(weights).to_csv(args.output_dir/"power-weights.csv",index=False)
    az.compare(loos,method="stacking").to_csv(args.output_dir/"comparison.csv")
    for stat in ["std",0.95]:
        az.plot_ppc_tstat(fits["base"],t_stat=stat)
        plt.savefig(args.output_dir/f"ppc-{stat}.png",dpi=110);plt.close("all")
    candidate=pz.Normal();pz.quartile(candidate,q1=-1,q2=0,q3=1,plot=False)
    scale=pz.Gamma();pz.maxent(scale,lower=.5,upper=3,mass=.9,fixed_stat=("mode",1),plot=False)
    report={"analytic_iid_draws":True,"chains_as_storage":4,"draws_each":1500,
            "elpd":{n:float(l.elpd) for n,l in loos.items()},
            "max_k":{n:float(l.pareto_k.max()) for n,l in loos.items()},
            "prior_quantiles":np.asarray(candidate.ppf([.25,.5,.75])).tolist(),
            "maxent_interval_mass":float(scale.cdf(3)-scale.cdf(.5)),
            "scope":"shared-array API validation; independent analytic draws"}
    (args.output_dir/"analytic-summary.json").write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))


if __name__=="__main__":
    main()

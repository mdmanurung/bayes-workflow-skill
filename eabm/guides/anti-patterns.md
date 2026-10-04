# Reject shortcuts by giving the next useful action

| Shortcut | Preferred alternative |
|---|---|
| Interpret coefficients immediately | Validate computation and estimand-specific precision, then critique the model |
| “R-hat 1.005 means fine” | It passes one screen; request bulk/tail ESS, MCSE, chain behavior and sampler diagnostics, then PPC/sensitivity |
| High R-hat → add iterations | Distinguish transient/slow mixing from separated modes, nonidentification, scaling or geometry; extend only a stable, improving fit |
| Divergences → more draws | Locate geometry; rescale/reparameterize or revise justified priors/model; bounded tuning only when warranted; rerun all diagnostics |
| Set acceptance target to 0.999 automatically | Inspect where divergences occur and whether tuning trades for tiny steps/treedepth without resolving bias |
| Ignore tail ESS | Check quantities in tails and quantile MCSE; bulk precision does not establish interval precision |
| Thin to fix autocorrelation | Retain draws for estimation; fix mixing/add useful computation; thinning can serve rank diagnostics/storage with a stated reason |
| Skip prior prediction because priors are vague | Simulate full observable/derived/group scales and extremes; vague can be strongly informative after transformation |
| Generic PPC proves adequacy | Choose features exposing specific plausible failures, including groups/dependence; adequate checks never prove correctness |
| Good PPC means done | Verify computation, targeted gaps, sensitivity, scientific target/identification and reporting; compare only if useful |
| Highest LOO wins | Establish compatible targets, reliability, paired uncertainty, adequacy and practical costs |
| Ignore high Pareto-k | Diagnose influential units; supported moment matching/refits/folds; preserve valid observations |
| Moment matching fixes the model | It repairs an importance approximation; rerun model criticism separately |
| Sum scores across any likelihoods | Define joint/conditional tasks and units; align factors/measure or present separate scores |
| Gaussian vs t cannot be compared | They can on the same continuous observed scale with complete densities and comparable targets |
| Small ELPD difference is decisive | Inspect paired uncertainty, unit influence, sample size, dependence and decision consequences |
| Stacking weights are model probabilities | Treat as weights of a predictive mixture and critique the mixture |
| Stronger prior fixes every warning | Justify information/regularization through induced predictions; distinguish geometry, conflict, weak likelihood and misspecification |
| Power-sensitivity labels prove conflict | Check selected densities/IS reliability/direction, compare changes to MCSE and corroborate justified alternatives |
| LOO search identifies causes | Separate causal adjustment, predictive selection, shrinkage and importance; validate search |
| SBC means real-data model fits | SBC checks inference under simulations; use real-data PPC and scientific identification separately |
| Only parameter ranks are needed | Include derived/data-dependent test quantities for plausible inference bugs |
| Python and R calls are interchangeable | Check representation, versions, likelihood units, weights/SE definitions and supported feature parity |
| Ten million observations require a huge full loglik array | Define task/precision; use supported on-demand/chunked/subsampled estimators with uncertainty and influence safeguards |

The response should state evidence and unknowns, the next discriminating diagnostic, conditional interpretations, the smallest justified intervention and follow-up. See [evidence matrix](../references/evidence-matrix.md) for provenance; this table is an agent-facing **synthesis** of the underlying modules.

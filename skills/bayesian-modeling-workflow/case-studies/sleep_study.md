# Prior specification for regression

Source: [sleep_study/sleep_study.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/sleep_study/sleep_study.R), Ch./Sec. 17. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Reaction time trajectories with repeated subjects |
| Initial model | Gaussian regression in milliseconds |
| Why start there? | An interpretable millisecond regression supplies understandable baseline and daily effects before hierarchy and alternative errors. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Remove adaptation days, shift baseline, inspect units/intercept convention and simulate priors on response scale. |
| Computation | Weak/default priors can yield slow fits, divergences and R-hat warnings; revised models still need diagnostics. |
| Statistical/model checks | Prior predictive scaling, original versus log scale, shrinkage, outliers, sensitivity and LOO |
| Failure and competing diagnosis | Prior predictions change drastically when millisecond priors are copied to log coordinates. Outliers inflate Gaussian scatter; scale-aware priors and robust errors address distinct problems. |
| Intervention | Varying intercepts/slopes; revise lognormal priors; robust observation model and calibrated scales |
| Check after intervention | Repeat response-scale prior/PPC, shrinkage and sensitivity/LOO after changing likelihood or hierarchy. |
| Comparison | LOO and PPC across Gaussian/lognormal/robust/distributional and hierarchical choices. |
| Local implementation | brms get_prior; sample_prior only; LKJ; power sensitivity |
| Transferable rule | A prior belongs to a parameterization and units; carry the implied observable scale through expansions |

Source caveat: Use corrected priors, 144 observations, baseline Days 2 mapped to zero.

## Reasoning to reuse

Observed behavior (prior predictive scaling, original versus log scale, shrinkage, outliers, sensitivity and loo) → distinguish implementation, information and model explanations → intervene (varying intercepts/slopes; revise lognormal priors; robust observation model and calibrated scales) → validate (repeat response-scale prior/ppc, shrinkage and sensitivity/loo after changing likelihood or hierarchy.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [new-analysis playbook](../playbooks/new-analysis.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

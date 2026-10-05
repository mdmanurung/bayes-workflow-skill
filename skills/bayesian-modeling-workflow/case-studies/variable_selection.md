# Regularization and variable selection

Source: [variable_selection/variable_selection.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/variable_selection/variable_selection.R), Ch./Sec. 28. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Predict grades with correlated predictors |
| Initial model | Wide independent coefficients in a many-predictor regression |
| Why start there? | Wide coefficient priors reveal overfitting and joint-signal problems before contrasting principled regularization. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Inspect response scale and correlated scaled predictors; simulate induced prior R-squared before comparing priors. |
| Computation | Shrinkage prior geometry and summary checks; predictive overfitting can occur with acceptable sampler behavior. |
| Statistical/model checks | Prior R-squared near one; posterior versus LOO R-squared and coefficient instability |
| Failure and competing diagnosis | Broad independent priors imply unrealistic total R-squared and exaggerate fitted versus held-out performance. Inspect joint prior signal and correlated predictors before assigning variable importance from marginal intervals. |
| Intervention | Scale total signal, regularized horseshoe/R2D2; projection from a checked reference with validated search |
| Check after intervention | Recheck prior/held-out signal, reference adequacy, selection uncertainty and predictive reduction. |
| Comparison | LOO/predictive R-squared, normal/RHS/R2D2 and projection selection with a validated reference/search. |
| Local implementation | R2D2; cv_varsel; reference projection |
| Transferable rule | Regularize the joint predictor before selecting; predictive reduction is separate from causal adjustment |

Source caveat: R2D2 residual scale prior is half-Student-t(3), per errata.

## Reasoning to reuse

Observed behavior (prior r-squared near one; posterior versus loo r-squared and coefficient instability) → distinguish implementation, information and model explanations → intervene (scale total signal, regularized horseshoe/r2d2; projection from a checked reference with validated search) → validate (recheck prior/held-out signal, reference adequacy, selection uncertainty and predictive reduction.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [model-comparison playbook](../playbooks/model-comparison.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

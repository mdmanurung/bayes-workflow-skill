# Predictive model selection

Source: [loo_comparison/loo_comparison.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/loo_comparison/loo_comparison.R), Ch./Sec. 9.4. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Meaning of uncertain predictive differences |
| Initial model | Several small regression models; Gaussian sleep model; count models |
| Why start there? | Small comparable models expose how predictive ranking changes with data size, misspecification and outliers. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Scale predictors and state priors. This case focuses on comparative evidence rather than a full new-analysis simulation sequence. |
| Computation | Sampler issues considered alongside high-k/refitting; comparison uncertainty is the central diagnostic. |
| Statistical/model checks | Pointwise differences, influential outliers and unreliable normal approximations in small samples |
| Failure and competing diagnosis | Large/skewed pointwise differences and outliers undermine a simple normal comparison summary. Robust sleep errors and exact refits distinguish likelihood problems from PSIS approximation problems. |
| Intervention | Exact re-LOO, robust Student-t observation model, interpret near ties cautiously |
| Check after intervention | Recompute reliable comparisons and pointwise uncertainty after exact refits/likelihood repair. |
| Comparison | Pointwise elpd differences, uncertain rankings, exact re-LOO and robust/spline alternatives. |
| Local implementation | loo_compare; paired pointwise elpd |
| Transferable rule | A scalar rank conceals why models differ and uncertainty in the comparison |

Source caveat: The illustrative small-N heuristics are not universal decision thresholds.

## Reasoning to reuse

Observed behavior (pointwise differences, influential outliers and unreliable normal approximations in small samples) → distinguish implementation, information and model explanations → intervene (exact re-loo, robust student-t observation model, interpret near ties cautiously) → validate (recompute reliable comparisons and pointwise uncertainty after exact refits/likelihood repair.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [model-comparison playbook](../playbooks/model-comparison.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

# Required iterations and reporting precision

Source: [digits/digits.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/digits/digits.R), Ch./Sec. 11.4,11.6. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Monte Carlo accuracy of quantities actually reported |
| Initial model | Properly scaled linear regression |
| Why start there? | A straightforward regression provides a controlled fit for investigating computational precision rather than model complexity. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Center predictor and assign scale-aware proper priors; focus is numerical precision after fitting. |
| Computation | Rank-normalized R-hat, ESS, MCSE, quantile/probability precision and iteration effort. |
| Statistical/model checks | R-hat, ESS, MCSE for means, quantiles and probabilities; rounding |
| Failure and competing diagnosis | Printed numerical precision can exceed the accuracy supplied by correlated draws. Compare MCSE for the displayed function, not merely posterior SD or total iterations. |
| Intervention | Increase sampling only for remaining Monte Carlo error after diagnosing computation |
| Check after intervention | Recalculate MCSE for the actual displayed summary and round to justified precision. |
| Comparison | No model-selection exercise; compare computational precision as effort changes. |
| Local implementation | posterior summaries; MCSE for derived quantities |
| Transferable rule | Choose simulation effort and digits from quantity-specific accuracy, not raw draw count |

Source caveat: ESS targets do not guarantee extreme-tail accuracy or an existing mean.

## Reasoning to reuse

Observed behavior (r-hat, ess, mcse for means, quantiles and probabilities; rounding) → distinguish implementation, information and model explanations → intervene (increase sampling only for remaining monte carlo error after diagnosing computation) → validate (recalculate mcse for the actual displayed summary and round to justified precision.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [failing-model playbook](../playbooks/failing-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

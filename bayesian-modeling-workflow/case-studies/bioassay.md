# Basic probabilistic programming

Source: [bioassay/bioassay.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/bioassay/bioassay.R), Ch./Sec. 3.5. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Binomial dose response and LD50 |
| Initial model | Binomial-logit intercept/slope, initially no explicit priors |
| Why start there? | Counts of deaths among known exposed batches naturally suggest binomial probabilities changing with dose. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Inspect dose/trial data and compile pedantically. A systematic prior-predictive stage is not demonstrated here. |
| Computation | Compilation warnings, fit summaries and posterior draws; no elaborate failing-geometry demonstration. |
| Statistical/model checks | Pedantic prior warnings; examine posterior response curves and derived LD50 |
| Failure and competing diagnosis | No diagnosed real-data failure is claimed. Missing-prior warnings distinguish implementation choices; LD50 depends on a ratio whose denominator can approach zero. |
| Intervention | Proper coefficient priors and scientifically justified positive slope |
| Check after intervention | Check response curves and uncertainty in LD50 on correct units; scrutinize b near zero before reporting the ratio. |
| Comparison | Stan versus brms implementations; no substantive LOO model-selection demonstration. |
| Local implementation | Binomial-logit; generated predictions |
| Transferable rule | Audit support and derived quantities; a ratio can remain poorly identified despite well-behaved coefficients |

Source caveat: No specific posterior failure or model comparison is claimed.

## Reasoning to reuse

Observed behavior (pedantic prior warnings; examine posterior response curves and derived ld50) → distinguish implementation, information and model explanations → intervene (proper coefficient priors and scientifically justified positive slope) → validate (check response curves and uncertainty in ld50 on correct units; scrutinize b near zero before reporting the ratio.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [new-analysis playbook](../playbooks/new-analysis.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

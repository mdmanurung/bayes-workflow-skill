# Debugging

Source: [world_cup/world_cup.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/world_cup/world_cup.R), Ch./Sec. 23. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Goal differences and equivalent probability formulations |
| Initial model | Signed-square-root transformed goal difference |
| Why start there? | A transformed goal difference provides a simple approximation whose observable implications can be checked against natural-scale models. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Inspect goal differences and power covariate; test intended transform and inverse independently. |
| Computation | Fits can look computationally successful while back-transformation is wrong. |
| Statistical/model checks | Back-transformation PPC exposes a factor-of-two implementation bug |
| Failure and competing diagnosis | A half-size signed-root implementation can fit internally while original-scale replication fails. An independent transform roundtrip localizes the code bug before changing the scientific likelihood. |
| Intervention | Fix transformation; compare natural/discretized and bivariate goal models |
| Check after intervention | Test transform roundtrip and original-scale PPC; compare stable bin mass on the intended target. |
| Comparison | Compare predictive likelihood formulations only on the same outcome probability measure. |
| Local implementation | Stable CDF differences; transformation roundtrip |
| Transferable rule | A fit can diagnose a coding bug; compare densities/masses only on a common predictive target |

Source caveat: Likelihood aggregation and scoring dimension must match the outcome being compared.

## Reasoning to reuse

Observed behavior (back-transformation ppc exposes a factor-of-two implementation bug) → distinguish implementation, information and model explanations → intervene (fix transformation; compare natural/discretized and bivariate goal models) → validate (test transform roundtrip and original-scale ppc; compare stable bin mass on the intended target.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [failing-model playbook](../playbooks/failing-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

# Sampling difficulties with latent variables

Source: [park_rule/park_rule.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/park_rule/park_rule.R), Ch./Sec. 29. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Crossed binary person/item effects |
| Initial model | Non-centered logistic crossed effects |
| Why start there? | Fast approximate lme4 fitting gives preliminary design information before diagnosing custom crossed-effect Stan geometry. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Quick lme4 exploration and fake-data refit; inspect crossed respondent/item indexing and predictor baselines. |
| Computation | High R-hat and low ESS despite no divergences; standardized latent coordinate correlation identifies difficulty. |
| Statistical/model checks | Slow sampling, low ESS and high R-hat without divergences; correlated redundant intercept structure |
| Failure and competing diagnosis | No divergences accompany poor mixing because shifts/redundant means and correlations can remain. Inspect standardized effects, identify finite-group deviations and use stronger data information to motivate centering. |
| Intervention | Sum-to-zero identification; centered effects where strongly informed; centered predictors; adequate warmup |
| Check after intervention | Recompute geometry and ESS/time/QOI accuracy with matching scientific interpretation and prior assumptions. |
| Comparison | Compare exploration and computation under constraints, centering and final longer fits; not automatic statistical equivalence. |
| Local implementation | sum_to_zero_vector; benchmark equivalent parameterizations |
| Transferable rule | No divergences does not imply good geometry; centered versus non-centered is data dependent |

Source caveat: Constraints can change the meaning of the intercept/prior; normal variants are auxiliary. Current Stan guidance adds a centered constrained-scale normalization caveat, recorded in the unresolved ledger; do not transplant those priors unexamined.

## Reasoning to reuse

Observed behavior (slow sampling, low ess and high r-hat without divergences; correlated redundant intercept structure) → distinguish implementation, information and model explanations → intervene (sum-to-zero identification; centered effects where strongly informed; centered predictors; adequate warmup) → validate (recompute geometry and ess/time/qoi accuracy with matching scientific interpretation and prior assumptions.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [failing-model playbook](../playbooks/failing-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

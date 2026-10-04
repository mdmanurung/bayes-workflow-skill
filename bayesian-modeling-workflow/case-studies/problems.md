# Problematic posterior geometries

Source: [problems/problems.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/problems/problems.R), Ch./Sec. 12.3. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Separate identification, scale, support and computation |
| Initial model | Deliberately flawed logistic, regression, heavy-tail and hierarchical models |
| Why start there? | Constructed simple failures isolate one cause at a time, so a remedy can be tied to observed behavior. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Deliberately construct problematic examples; check design, support and prior declarations before trying remedies. |
| Computation | High R-hat/low ESS, divergence locations, traces/pairs, overflowing evaluations and support errors. |
| Statistical/model checks | Separation, redundant parameters, correlations, overflow, funnel divergences, chain disagreement |
| Failure and competing diagnosis | Check whether a parameter is unused, duplicated, unsupported or separated before assuming ordinary autocorrelation. Funnel divergence locations and standardized pairs distinguish parameterization issues from just too few draws. |
| Intervention | Proper priors, remove redundancy, scale/center, enforce support, change parameterization |
| Check after intervention | Reinspect chains, geometry, diagnostics and quantities of interest after each separate remedy. |
| Comparison | Compare known failure/remedy fits and geometry; not a likelihood-ranking workflow. |
| Local implementation | Pairs with divergence overlays; centered/non-centered variants |
| Transferable rule | The same warning has competing causes; diagnose the posterior before tuning HMC |

Source caveat: A proper Cauchy example differs from an improper flat-prior separation example.

## Reasoning to reuse

Observed behavior (separation, redundant parameters, correlations, overflow, funnel divergences, chain disagreement) → distinguish implementation, information and model explanations → intervene (proper priors, remove redundancy, scale/center, enforce support, change parameterization) → validate (reinspect chains, geometry, diagnostics and quantities of interest after each separate remedy.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [failing-model playbook](../playbooks/failing-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

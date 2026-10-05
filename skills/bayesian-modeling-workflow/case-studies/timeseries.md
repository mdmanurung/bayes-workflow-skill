# Decision analysis

Source: [timeseries/timeseries.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/timeseries/timeseries.R), Ch./Sec. 20. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Classify slopes in 1000 series under a prize/cost rule |
| Initial model | OLS slopes then a three-component slope mixture |
| Why start there? | Known trend-component types turn noisy slopes into probabilistic classifications for a specified competition decision. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Estimate slopes/uncertainties, define components and the actual prize/cost decision; verify approximation assumptions. |
| Computation | Posterior component uncertainty; no central HMC-failure troubleshooting tree demonstrated. |
| Statistical/model checks | Component uncertainty; expected number correct differs from probability of exceeding a threshold |
| Failure and competing diagnosis | The action maximizing expected correct classifications need not maximize a threshold-winning probability. Inspect the actual loss and joint uncertainty rather than only marginal classification probabilities. |
| Intervention | Posterior classification probabilities and utility-based action evaluation |
| Check after intervention | Propagate posterior classification uncertainty into the relevant utility; qualify independence/normal approximations. |
| Comparison | Compare classifications/actions through posterior expected correctness and threshold utility. |
| Local implementation | Mixture probabilities; posterior expected utility |
| Transferable rule | Propagate uncertainty into the loss relevant to the decision, including dependence where needed |

Source caveat: Source slope/aggregate approximations are not a general temporal dependence model.

## Reasoning to reuse

Observed behavior (component uncertainty; expected number correct differs from probability of exceeding a threshold) → distinguish implementation, information and model explanations → intervene (posterior classification probabilities and utility-based action evaluation) → validate (propagate posterior classification uncertainty into the relevant utility; qualify independence/normal approximations.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [new-analysis playbook](../playbooks/new-analysis.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

# Posterior predictive checking (Stan)

Source: [dogs/dogs_stan.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/dogs/dogs_stan.R), Ch./Sec. 21. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Same learning example with explicit generated quantities |
| Initial model | Independent then multilevel shock/avoidance parameters |
| Why start there? | Explicit Stan versions expose hierarchical/generated-quantity implementation and the role of prior information. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Compile model sequence; test generated histories and proper correlated-effect priors. |
| Computation | Stan summaries, latent-effect parameterization and simulated-data learning as trial count increases. |
| Statistical/model checks | Chain summaries, replicated sequences, fake-data parameter recovery |
| Failure and competing diagnosis | Limited trials can yield weak individual recovery despite a correctly fit population model. Increase trials in fake data and inspect learning; validate covariance/generated history separately when adapting code. |
| Intervention | Priors and non-centered correlated effects; compare recovery under more trials |
| Check after intervention | Repeat sequential PPC and recovery with more trials; validate covariance orientation independently when adapting. |
| Comparison | Parameterization/model replications and fake-data learning; main temporal comparison appears in brms walkthrough. |
| Local implementation | Sequential y_rep and transformed probabilities |
| Transferable rule | Validate generated quantities as part of the model and distinguish weak recovery from code failure |

Source caveat: Potential row-wise Cholesky orientation issue recorded for source dogs_5.stan; template uses canonical orientation.

## Reasoning to reuse

Observed behavior (chain summaries, replicated sequences, fake-data parameter recovery) → distinguish implementation, information and model explanations → intervene (priors and non-centered correlated effects; compare recovery under more trials) → validate (repeat sequential ppc and recovery with more trials; validate covariance orientation independently when adapting.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [latent-variable-model playbook](../playbooks/latent-variable-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

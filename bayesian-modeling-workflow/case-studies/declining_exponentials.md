# Declining exponentials

Source: [declining_exponentials/declining_exponentials.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/declining_exponentials/declining_exponentials.R), Ch./Sec. 12.4. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Identify positive decay components |
| Initial model | One exponential with Gaussian observation error |
| Why start there? | One decay curve tests the basic physical support/error map before separating multiple components. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Generate fake data with known rates/amplitudes; vary rate separation and error formulation. |
| Computation | Parameter exploration/summary issues and unbounded weak component; informative curves can conceal unstable components. |
| Statistical/model checks | Fake-data recovery and fitted curves; near-equal rates weakly identified; unconstrained regions |
| Failure and competing diagnosis | When rates are nearly equal, many component combinations generate the same curve. Simulating well-separated versus overlapping rates separates lack of design information from a coding bug. |
| Intervention | Positive parameters, multiplicative lognormal errors when justified, ordered rates and proper priors |
| Check after intervention | Refit known data; compare observable curves and component recovery in separated/overlapping regimes. |
| Comparison | Compare simulated/fitted curves and error/components; LOO not demonstrated. |
| Local implementation | Ordered positive parameters; recovery simulation |
| Transferable rule | Predictive identification does not imply identification of each nonlinear component |

Source caveat: No LOO demonstration; ordering removes permutation symmetry, not overlapping-component ambiguity.

## Reasoning to reuse

Observed behavior (fake-data recovery and fitted curves; near-equal rates weakly identified; unconstrained regions) → distinguish implementation, information and model explanations → intervene (positive parameters, multiplicative lognormal errors when justified, ordered rates and proper priors) → validate (refit known data; compare observable curves and component recovery in separated/overlapping regimes.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [weak-identification playbook](../playbooks/weak-identification.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

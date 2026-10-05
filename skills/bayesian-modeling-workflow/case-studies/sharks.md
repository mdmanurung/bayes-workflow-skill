# Latent-variable models

Source: [sharks/sharks.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/sharks/sharks.R), Ch./Sec. 26. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Hidden behavioral states of movement tracks |
| Initial model | HMM gamma step length with point mass at zero and von Mises angle |
| Why start there? | State-dependent step/turn distributions give a small hidden-state movement model before transition covariates and individual effects. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Define movement emissions, track indices, missing sentinels and regular-time interpretation; documentation gaps remain. |
| Computation | Marginal state likelihood and fit summaries; extra covariate/shark effects increase latent/prior complexity. |
| Statistical/model checks | State probabilities, simulated tracks, pseudo-residuals and autocorrelation |
| Failure and competing diagnosis | Uncertain latent state labels are not observed behavior. Log-space forward/backward inference, track resets and residual autocorrelation distinguish decoding uncertainty from missing transition/individual structure. |
| Intervention | Transition covariates, track resets and shark-level effects |
| Check after intervention | Inspect state uncertainty, simulated movement patterns and pseudo-residual temporal structure; test track boundaries. |
| Comparison | Check state/emission/transition predictions and alternative structures; no universal state-count ranking rule inferred. |
| Local implementation | Log-space forward algorithm; forward-backward probabilities |
| Transferable rule | Marginalize discrete states; decoding is uncertain inference, not observed state truth |

Source caveat: Data README is incomplete; regular time intervals and sentinel handling require explicit verification.

## Reasoning to reuse

Observed behavior (state probabilities, simulated tracks, pseudo-residuals and autocorrelation) → distinguish implementation, information and model explanations → intervene (transition covariates, track resets and shark-level effects) → validate (inspect state uncertainty, simulated movement patterns and pseudo-residual temporal structure; test track boundaries.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [latent-variable-model playbook](../playbooks/latent-variable-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

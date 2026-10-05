# Multimodality

Source: [planetary_motion/planetary_motion.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/planetary_motion/planetary_motion.R), Ch./Sec. 30. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Orbit ODE and disconnected solutions |
| Initial model | Full seven-parameter orbit model |
| Why start there? | The full scientific ODE is reduced after difficulty, so gravity-only behavior can reveal mode/numerical causes. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Define ODE units, measurement error and trajectory simulator; simplify before expensive full fits. |
| Computation | Chain runtimes/traces/warmup, R-hat and trajectory differences; fast-orbit ODE evaluation can be expensive. |
| Statistical/model checks | Long chain runtimes, chain-specific trajectories and 1D density grid after simplification |
| Failure and competing diagnosis | Disconnected trajectories, poor prior starts and fast-orbit solver expense can coexist. Fix components, inspect gravity slices and predictions by chain, and test numerics before discarding a chain or declaring a substantive second mode. |
| Intervention | Fix components to diagnose, investigate mode plausibility, use multipath Pathfinder initialization and justified priors |
| Check after intervention | Run varied informed starts, diagnose refitted chains and trajectories, test numerical stability across plausible modes. |
| Comparison | Compare chain predictions, mode evidence and initialized/refitted reliability; stacking not posterior mode probabilities. |
| Local implementation | ODE slices; prediction by chain; informed initialization |
| Transferable rule | Simplify to distinguish numerical cost, poor starts and substantive modes; do not silently discard chains |

Source caveat: 1D conditional slices and chain stacking are not generic evidence for global posterior mode weights.

## Reasoning to reuse

Observed behavior (long chain runtimes, chain-specific trajectories and 1d density grid after simplification) → distinguish implementation, information and model explanations → intervene (fix components to diagnose, investigate mode plausibility, use multipath pathfinder initialization and justified priors) → validate (run varied informed starts, diagnose refitted chains and trajectories, test numerical stability across plausible modes.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [failing-model playbook](../playbooks/failing-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

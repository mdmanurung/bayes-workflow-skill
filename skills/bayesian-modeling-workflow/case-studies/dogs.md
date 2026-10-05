# Posterior predictive checking (brms)

Source: [dogs/dogs.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/dogs/dogs.R), Ch./Sec. 21. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Binary trial sequences and an apparent learning mechanism |
| Initial model | Logistic time trend, then history-based shock probability |
| Why start there? | A visible trial trend is directly testable before interpreting history parameters as an animal-learning mechanism. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Inspect trajectories and deterministic first trial; define prior shock/avoidance histories and candidate response generators. |
| Computation | Fit summaries and correlated effects; compare revised priors and hierarchical fits. |
| Statistical/model checks | Switch counts reveal temporal mismatch; simulate logistic data and recover apparent mechanistic coefficients |
| Failure and competing diagnosis | Overall trajectories can hide wrong switch behavior, and history coefficients can suggest a learning mechanism under a nonlearning generator. Target switches and simulate competing generators to distinguish prediction from mechanism. |
| Intervention | Varying effects and alternative history models; leave-future-out comparisons |
| Check after intervention | Recheck switches/trajectories and future prediction; test the supposed mechanism against a competing generator. |
| Comparison | Early LOO screening and leave-future-out refits; predictive fit does not identify learning mechanism. |
| Local implementation | Recursive PPC; rolling-origin folds |
| Transferable rule | Rebuild simulated history recursively; predictive agreement does not establish a mechanism |

Source caveat: Early LOO comparisons eliminate candidates before detailed PPC; final inference still requires checking.

## Reasoning to reuse

Observed behavior (switch counts reveal temporal mismatch; simulate logistic data and recover apparent mechanistic coefficients) → distinguish implementation, information and model explanations → intervene (varying effects and alternative history models; leave-future-out comparisons) → validate (recheck switches/trajectories and future prediction; test the supposed mechanism against a competing generator.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [bad-ppc playbook](../playbooks/bad-ppc.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

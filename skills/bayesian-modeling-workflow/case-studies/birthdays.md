# Time-series decomposition

Source: [birthdays/birthdays.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/birthdays/birthdays.R), Ch./Sec. 27. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Daily births: long trend, annual, weekly and calendar effects |
| Initial model | Long-scale GP, then periodic/weekday components |
| Why start there? | A smooth long trend makes remaining annual, weekly and calendar residual structure visible in successive checks. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Prepare centered/scaled births and temporal/calendar indices; construct/test basis and remove redundant constant terms. |
| Computation | Low ESS, treedepth, divergences, redundant components and Pathfinder approximation warnings; exploratory runs remain provisional. |
| Statistical/model checks | Residual patterns, redundant GP constant/intercept, slow NCP and treedepth; prior sensitivity |
| Failure and competing diagnosis | Redundant intercept/GP constants create correlated coordinates; data-rich seasonal effects can make non-centering inefficient. Diagnose geometry and residual components, then compare matching centered forms and defensible prior sensitivity. |
| Intervention | Drop redundancy; add justified components; stronger information can favor centered seasonal effects |
| Check after intervention | Recheck computation, decomposed scientific functions and residual structure; final inference needs validated MCMC. |
| Comparison | Residual/component and prior/parameterization comparisons; some approximate/short fits only guide exploration. |
| Local implementation | HSGP basis expansion; sparse day effects; conditional component plots |
| Transferable rule | Decompose a residual feature at a time; computation and interpretable decomposition must both survive revision |

Source caveat: Short Pathfinder/provisional fits are not final validated posterior evidence.

## Reasoning to reuse

Observed behavior (residual patterns, redundant gp constant/intercept, slow ncp and treedepth; prior sensitivity) → distinguish implementation, information and model explanations → intervene (drop redundancy; add justified components; stronger information can favor centered seasonal effects) → validate (recheck computation, decomposed scientific functions and residual structure; final inference needs validated mcmc.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [model-expansion playbook](../playbooks/model-expansion.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

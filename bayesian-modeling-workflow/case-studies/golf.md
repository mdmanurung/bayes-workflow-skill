# Model expansion

Source: [golf/golf.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/golf/golf.R), Ch./Sec. 25. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Putting success over distance with physical structure |
| Initial model | Logistic then angle-error mechanistic binomial |
| Why start there? | A generic logistic curve is a baseline; angular geometry adds an interpretable physical explanation to test. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Specify physical angular geometry and distance units; independently calculate mechanism components. |
| Computation | Minor modes/initialization, added discrepancy geometry and latent-effect integration checked throughout. |
| Statistical/model checks | Long-distance misfit, sampling variance too small for huge trial counts, residual shape and LOO |
| Failure and competing diagnosis | A successful angular model misses long-distance control; huge trial counts also make minor process discrepancy consequential. Distance-specific residual checks distinguish missing mechanism from overly rigid observation variability. |
| Intervention | Distance-control component, discrepancy models, revise latent error scale; compare local predictions |
| Check after intervention | Repeat distance-specific PPC, residuals, diagnostics and matched LOO; separate predictive gain from parameter recovery. |
| Comparison | LOO and local distance/residual checks across justified components; integrate latent error for held-out scoring. |
| Local implementation | Component tests; latent integrated LOO |
| Transferable rule | Expand for a named failure; added mechanistic parameters can be weakly identified despite predictive success |

Source caveat: Bounded exponential latent-prior normalization/hyperprior issue is listed as an unresolved source interpretation.

## Reasoning to reuse

Observed behavior (long-distance misfit, sampling variance too small for huge trial counts, residual shape and loo) → distinguish implementation, information and model explanations → intervene (distance-control component, discrepancy models, revise latent error scale; compare local predictions) → validate (repeat distance-specific ppc, residuals, diagnostics and matched loo; separate predictive gain from parameter recovery.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [model-expansion playbook](../playbooks/model-expansion.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

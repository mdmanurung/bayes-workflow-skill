# Review an existing model

Inspect available scientific question, data preprocessing, model formula/source, priors, generated quantities and diagnostics. Read [formulation](../references/problem-formulation.md) and the canonical reference implicated by each issue.

Audit: estimand and conditioning; sampling/assignment/dependencies; outcome support and likelihood/link; predictor construction/scaling; priors and observable implications; grouping/pooling; identification/parameterization; numerical and chain diagnostics; relevant PPCs; validation unit/leakage; comparison target/uncertainty; sensitivity and interpretation.

Return four groups with concrete evidence:

- **KEEP:** supported choices and their scientific/computational rationale.
- **CHANGE:** established issue, primary problem class, concrete intervention and expected consequence.
- **CHECK:** unresolved competing explanations, exact discriminating diagnostic/simulation and what each result would imply.
- **OPTIONAL:** useful but nonessential extensions tied to a scientific need; do not present complexity as required.

For every CHANGE/CHECK give validation and the impact on the estimand. Prioritize materially incorrect design/observation assumptions and unreliable computation before cosmetic refinements. Missing diagnostics are a CHECK, not fabricated evidence of success/failure. Good R-hat is evidence about sampled chains, not an endorsement of likelihood or mechanism. Do not remove scientifically needed covariates solely for a LOO tie.

If implementation is requested, make the smallest supported change, preserve the original, then repeat relevant old/new checks. State what remains provisional. Finish using [reporting](../references/reporting.md).

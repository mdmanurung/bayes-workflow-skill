---
name: eabm
description: Diagnose, criticize, compare, improve, and report Bayesian models using source-grounded Exploratory Analysis of Bayesian Models reasoning in Python or R. Use for what-to-check-next requests, R-hat/ESS/MCSE, trace/rank plots, HMC divergences or energy, prior/posterior predictive checks, sensitivity and power scaling, PSIS-LOO/Pareto-k, hierarchical or multi-likelihood prediction, moment matching, stacking, large-data LOO, prior elicitation, projection/variable selection, SBC, and Bayesian scientific reporting. Distinguish computational validity, model adequacy, predictive evaluation, and scientific purpose; route to verified language-specific implementations.
---

# Bayesian model analysis

Use **question → diagnostic → interpretation → likely causes → action → follow-up**. Explain statistical reasoning once; provide only the requested implementation branch. Treat diagnostics as evidence against particular failures, never proof of correctness.

## Start with the model and the decision

1. Establish the scientific question, estimand/decision, outcome support, design, grouping/dependence, missingness/censoring, likelihood, priors, parameterization, inference method and available artifacts. Inspect existing code and fitted objects before proposing a new model.
2. Route `implementation_language: auto | python | r | both`. In `auto`, infer from files/packages and explicit preference; state a provisional choice if ambiguous. In `both`, share the reasoning and show short parallel code. Inspect versions: [API contracts](references/api-verification.md); do not mix ArviZ 1.x DataTree and legacy 0.x InferenceData calls.
3. Classify the suspected failure using [failure taxonomy](guides/failure-taxonomy.md). Several classes may coexist. Separate observations, hypotheses and verified causes.
4. Read the one relevant guide and language recipe from the table below. Use the [threshold registry](references/thresholds.md); do not scatter undocumented numerical cutoffs.
5. Return the next discriminating check, the smallest justified intervention, and the required rechecks. Record unknown prerequisites rather than pretending an unprovided plot or diagnostic passed.

## Core workflow and gates

- Check support, units, indexing and the generative specification. Simulate prior predictions against external/domain reference values; include group variation and interpretable derived quantities.
- Validate computation before substantive posterior interpretation: sampler warnings → per-chain behavior/geometry → rank-normalized split R-hat + bulk/tail ESS + estimand-specific MCSE → targeted plots. For non-MCMC approximations, use method-specific validation; fictitious chains do not establish accuracy.
- Criticize the model with targeted PPCs: **what observed feature would reveal the particular way this model could be wrong?** Preserve the sampling, observation and dependence structure.
- Check scientific conclusions under justified prior/likelihood alternatives. Treat power scaling as local sensitivity; validate importance approximations and corroborate consequential findings by refitting.
- Compare models only if useful for the question. First define predictive target, held-out unit, training information and comparable normalized likelihood contributions. Then inspect ELPD uncertainty, Pareto diagnostics, influential units, and candidate adequacy. Stacking is a predictive mixture, not posterior model probabilities.
- Report estimands and uncertainty, computational limitations, model criticism, sensitivity, comparison target and reproducible materials. Update the [model-development record](examples/model-development-record.md) after every substantive change.

A failed check routes back to the stage it challenges. An estimator repair (e.g. moment matching) does not repair model misspecification. A good score does not excuse a PPC failure. A useful PPC does not validate causal identification.

## Diagnostic routing

| Question or trigger | Read | Implementation |
|---|---|---|
| Sampling adequate? R-hat, ESS, MCSE, rank/trace | [Diagnostics](guides/diagnostics.md) | [Python](python/diagnostics.md) / [R](r/diagnostics.md) |
| Divergences, BFMI, weak identification, funnels | [Diagnostics](guides/diagnostics.md) + [taxonomy](guides/failure-taxonomy.md) | Same branches; inspect geometry before tuning |
| Impossible prior outcomes; eliciting priors | [Prior elicitation](guides/prior-elicitation.md) + [predictive checking](guides/predictive-checking.md) | [Python](python/predictive-and-elicitation.md) / [R](r/predictive-and-elicitation.md) |
| PPC failure; tails, zeros, groups, time, censoring | [Predictive checking](guides/predictive-checking.md) | Same predictive branches |
| Stronger prior? Sensitivity or prior-data conflict | [Sensitivity](guides/sensitivity.md) | [Python](python/sensitivity.md) / [R](r/sensitivity.md) |
| LOO table, Pareto-k, repair, stacking, huge data | [Model comparison](guides/model-comparison.md) | [Python](python/model-comparison.md) / [R](r/model-comparison.md) |
| Different groups or multiple likelihoods | [Model comparison](guides/model-comparison.md) + [worked targets](examples/hierarchical-targets.md) | Explicitly select, sum or concatenate aligned contributions |
| Variable selection, shrinkage, projection | [Variable selection](guides/variable-selection.md) | [Python](python/selection-and-sbc.md) / [R](r/selection-and-sbc.md) |
| Custom implementation or inference validation | [SBC](guides/sbc.md) | Same selection/SBC branches |
| Paper, uncertainty figure, results section | [Reporting](guides/reporting.md) + [visualization](guides/visualization.md) | [parity matrix](references/python-r-parity.md) |

Use [decision trees](decision-trees/README.md) for executable triage and return paths. Read [anti-patterns](guides/anti-patterns.md) when interpreting a shortcut request. Use [worked examples](examples/README.md) when a concrete demonstration is needed.

## Non-negotiable checks and escalation

- Keep chain/draw axes and observation IDs intact; distinguish replicated outcomes from expected responses. Do not silently drop failed fits, valid influential observations, groups, censoring, or uncertainty.
- Never answer “the model is fine” from R-hat alone. Never prescribe more iterations or high acceptance targets before checking nonstationarity, geometry and identification.
- Require complete likelihood densities/probabilities on a common observed scale for scoring, including transformation Jacobians and relevant censoring/truncation terms. Exclude prior terms from pointwise likelihoods.
- Avoid ranking incompatible tasks. Specify what remains observed when holding out one response in a multi-outcome model. For new groups, do not condition on group effects learned from held-out observations.
- For unsupported APIs, missing density callbacks, unreliable importance ratios, multimodality or unidentifiable scientific targets, state the obstacle and route to refits, explicit folds, implementation validation or a revised estimand. Do not report unreliable estimates as definitive.
- Change priors or model structure for a scientific/model reason, not to silence a diagnostic. Reparameterization must preserve the intended probability model; document changes to its induced prior if it does not.
- Distinguish prior predictive checks, real-data PPC, fixed-parameter recovery and SBC. Include data-dependent SBC test quantities where they address plausible bugs.

## Evidence and outputs

Support important recommendations with source IDs/links from [bibliography](references/bibliography.md) and [evidence matrix](references/evidence-matrix.md). Use `direct-eabm | eabm-code | method-paper | translated | synthesized`; label package-only API evidence separately. Never attribute an R translation or this skill's action-order heuristic to the book. Resolve conflicts with primary methods/official implementation and record the correction in [source ledger](references/source-ledger.md).

For “what should I check next?”, return: **current gate; evidence/unknowns; next check and why; possible interpretations; ordered actions; follow-up; source**. For a revision, include what changed, why, diagnostic/PPC/sensitivity consequences and the decision. Give code with purpose, inputs, assumptions, expected output, interpretation, failure modes, next action and source as demonstrated in the implementation guides.

Load only the relevant supporting files. [Final QC](validation/quality-control.md) and [adversarial results](validation/adversarial-results.md) describe what was actually tested, capability gaps and limits; do not imply broader runtime verification.

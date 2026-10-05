---
name: bayesian-modeling-workflow
description: Develop, review, debug and iteratively refine scientific Bayesian models using source-grounded Bayesian Workflow reasoning. Use for generative model design, prior specification, simulation, Stan/cmdstanr/brms implementation, MCMC failures, posterior predictive checks, hierarchical or latent models, PSIS-LOO, sensitivity, SBC and uncertainty reporting. Distinguish scientific design, statistical model, prior/identification and computational problems; require a reason and validation for each revision.
---

# Bayesian Modeling Workflow

Build the smallest model that answers the scientific question. Simulate its implications, fit it, interrogate computation and predictions, and revise a named inadequacy. Treat this as a source-grounded synthesis, not an author quotation or an inflexible sequence. Use R, cmdstanr/Stan and brms by default; preserve the user's existing stack when appropriate.

## Select the task and load only needed material

Read the selected playbook and its linked canonical references before acting. Inspect available data, model code, prior definitions, transformations, fit objects and diagnostics. Infer what can be established; ask only consequential missing questions. Never endorse an existing model from its formula alone.

| Request or evidence | Start here | Load conditionally |
|---|---|---|
| New dataset/question | [New analysis](playbooks/new-analysis.md) | [Formulation](references/problem-formulation.md), [generative modeling](references/generative-modeling.md), [priors](references/prior-workflow.md) |
| Existing model | [Model review](playbooks/existing-model-review.md) | References needed for each KEEP / CHANGE / CHECK / OPTIONAL judgment |
| Failed fit or warning | [Failing model](playbooks/failing-model.md) | [Computational diagnostics](references/computational-diagnostics.md), [debugging](references/debugging.md) |
| Divergences | [Divergent transitions](playbooks/divergent-transitions.md) | Geometry, identification, [hierarchy](references/hierarchical-models.md) |
| Predictive mismatch | [Bad PPC](playbooks/bad-ppc.md) | [Predictive checks](references/posterior-predictive-checking.md), [expansion](references/model-expansion.md) |
| High Pareto-k | [High Pareto-k](playbooks/high-pareto-k.md) | [LOO](references/model-comparison-loo.md), latent integration if relevant |
| Pooling/repeated measurements | [Hierarchical model](playbooks/hierarchical-model.md) | Hierarchy, priors, prediction/validation unit |
| Weak recovery or unstable parameters | [Weak identification](playbooks/weak-identification.md) | Priors, [simulation](references/simulation.md), [sensitivity](references/sensitivity-analysis.md) |
| Latent states/factors/measurement error | [Latent-variable model](playbooks/latent-variable-model.md) | [Latent models](references/latent-variable-models.md), [SBC](references/sbc.md) |
| Candidate models | [Model comparison](playbooks/model-comparison.md) | LOO, sensitivity and scientific target |
| Add complexity | [Model expansion](playbooks/model-expansion.md) | Evidence-directed expansion branches |
| Separate modes/very different chains | [Multimodality](references/multimodality.md) | Geometry, predictive differences by mode |
| Final interpretation | [Reporting](references/reporting.md) | Sensitivity, accuracy of reported quantities |

Use the [case index](case-studies/index.md) for a relevant worked reasoning pattern. Instantiate code from [cmdstanr](examples/cmdstanr-patterns.md), [brms](examples/brms-patterns.md), [Stan](examples/stan-patterns.md) or [simulation](examples/simulation-patterns.md); read each pattern's assumptions. Consult [source map](references/source-map.md) for provenance, corrections and the distinction between demonstration and generalization.

## Run an iterative process

Use [workflow principles](references/workflow-principles.md) for state transitions and return conditions.

1. **Define the target.** Write the question, estimand, prediction/decision task, population and units. Map experimental versus observational units, clustering, repeated measures, selection, timing and missingness. If identification by the design is absent, narrow the claim or state the additional assumptions.
2. **Build a generative baseline.** Specify the observation process, likelihood/link, essential predictors and dependencies. Center/scale for meaning and computation; record transformations and their inverses. Choose a minimal scientifically useful version, not necessarily an independent-data model.
3. **Specify and simulate priors.** Explain parameter units, support and plausible effect size. Inspect implied observables and joint behavior. Repair implausible assumptions before fitting. Use known-parameter simulation early for new code, nonlinear/latent structure or unclear recovery.
4. **Fit a provisional version.** Save model/data versions, seed, software versions, prior definitions and fit settings. Preserve known-working models. Provisional short fits may find obvious errors; label them and do not use them for final uncertainty claims.
5. **Diagnose computation.** Inspect chain behavior, rank-normalized R-hat, bulk/tail ESS, quantity-specific MCSE, divergences, treedepth and energy; use pairs/geometry to distinguish causes. A low R-hat alone is insufficient. Resolve reliability before interpreting posterior summaries as trustworthy.
6. **Criticize predictions.** Ask which specific observable would reveal a failed assumption. Check relevant distributions, conditional/group patterns, extremes and temporal/latent structure. Replicate the actual observation process and recompute outcome-derived histories. Good computation does not establish model adequacy.
7. **Revise for a reason.** Record observation → competing diagnoses → discriminating check → intervention → validation. Change one interpretable component when feasible. Refit and repeat both computational and predictive checks; a repaired warning is not proof of repaired inference.
8. **Validate the task.** Compare meaningful alternatives on the same outcome, measure and validation unit when comparison informs the task. Inspect pointwise elpd and PSIS diagnostics, uncertainty and influential units. Early comparison may screen candidates; it cannot certify an unchecked winner. Run sensitivity/calibration where conclusions depend on assumptions or implementation is novel.
9. **Stop and report.** Stop when computation is reliable, checks relevant to the estimand are adequate, remaining discrepancies are immaterial or explicitly bounded, and plausible alternatives do not change the decision materially. Report predictive and scientific uncertainty, MC precision, assumptions and limitations. An unidentifiable target may require a qualified result or additional data instead of more complexity.

Do not require hierarchy, model selection, SBC or every plot for every analysis. Repeat formulation, priors, simulation and checks whenever a changed assumption affects them. No final fit exists merely because all checklist items were visited.

## Classify the problem before intervening

| Primary class | Discriminating evidence | Appropriate first action |
|---|---|---|
| Scientific/design | Requested quantity is not identified by sampling/assignment, conditioning or measurements | Reframe estimand, expose assumptions, examine data/design; computation cannot supply missing information |
| Statistical model | Reliable draws reproduce the wrong spread, groups, tails, time pattern or observation process | Revise the specific likelihood/dependence/mean structure and its predictions |
| Prior/identification | Recovery fails, ridges/redundancy, implausible prior predictions, results dominated by plausible prior alternatives | Check units/rank/support; identify a defensible constraint, prior or better-measured target |
| Computational | The implemented posterior is not explored accurately/efficiently or numerical evaluation fails | Inspect geometry/numerics and equivalence of parameterizations before sampler settings |

Allow multiple classes: weak identification can create a funnel; a misspecified likelihood can create influential observations. Name the underlying cause and the observable computational symptom separately.

## High-value branches

- **IF prior predictions are impossible:** inspect units, inverse link, denominator/exposure, joint prior and observation generator; distinguish a generator bug from a prior/likelihood problem. Revise scientifically justified assumptions and resimulate. Do not widen every prior automatically.
- **IF R-hat is high, ESS low or chains disagree:** inspect traces, modes, design rank, unused parameters, support and scale. Do not add iterations until structural failures are distinguished from ordinary Monte Carlo error.
- **IF divergences occur:** locate them in posterior geometry; examine funnels, boundaries, priors and centered/non-centered choices. After a justified intervention, verify warning counts, exploration and quantities of interest. Increasing adapt_delta alone does not establish unbiased inference.
- **IF PPC fails despite good computation:** target a named discrepancy, check preprocessing/generated quantities, then revise its generating assumption. Do not use sampler tuning to repair an observation model.
- **IF Pareto-k is high:** verify sampling and the held-out unit, inspect the associated observation/group and marginalize held-out latent effects where required. Repair the approximation with supported methods and investigate substantive influence separately.
- **IF calibration looks good but posterior equals prior:** check parameter use, recovery, contraction and data-dependent joint quantities. Marginal SBC ranks can pass for a procedure that ignores the data.

Use detailed decision rules in the relevant reference; thresholds are diagnostic guidance with documented scope, not universal acceptance theorems.

## Produce reviewable results

Return the scientific target, current model/state, evidence, next concrete action, expected consequence and validation. For a review use KEEP / CHANGE / CHECK / OPTIONAL with reasons. For an expansion use the required record in its playbook. Supply code when implementation is requested or necessary; adapt dimensions, units and likelihood explicitly.

Separate executed checks from proposed checks and unsupported inferences. Never invent diagnostic values, fitted conclusions, recovered datasets or author recommendations. Use [research coverage](research/coverage-ledger.md), [evidence matrix](research/evidence-matrix.md) and [unresolved questions](research/unresolved-questions.md) to establish source scope; use [validation report](reports/validation.md) to establish this skill's execution scope.

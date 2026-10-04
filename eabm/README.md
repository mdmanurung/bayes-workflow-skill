# Bayesian Model Analysis (EABM)

An agent skill for deciding **what to inspect, why, what a failure means, what to change and what to verify next**. Derived from Martin, Abril-Pla and Deklerk's [Exploratory Analysis of Bayesian Models](https://arviz-devs.github.io/EABM/), with independently verified R translations and method/package extensions.

Invoke `$eabm` with a model, fitted object, code or diagnostic output and optionally `implementation_language: python | r | both | auto`. The entry point is [SKILL.md](SKILL.md); it routes by statistical question rather than chapter or package.

| Directory | Contents |
|---|---|
| `references/` | Extraction ledger, evidence matrix, bibliography, source hashes, API contracts, parity and numerical heuristics |
| `guides/` | Diagnostic reasoning, predictive criticism, sensitivity, comparison, elicitation, selection, SBC, reporting and anti-patterns |
| `decision-trees/` | Seven executable JSON decision graphs plus a visual overview |
| `python/`, `r/` | Short implementation recipes and runnable fragments |
| `examples/` | Normal versus Student-t; predictive targets; sensitivity/SBC; model-development record |
| `scripts/` | Decision-graph runner and package-integrity audit |
| `validation/` | Runtime evidence, adversarial outputs and final QC |

Scope: post-fit model analysis plus prerequisite generative/prior checks. This complements a broader model-building workflow. It does not supply universal priors, causal identification, or automatic scientific model selection.

Source snapshot: 2026-10-04; EABM commit `d96c4c09ec1dc67c14ede90d5b9f491418f4d35e`. See [provenance and licensing](references/bibliography.md). Preserve attribution and the noncommercial restriction when distributing adaptations of EABM material.

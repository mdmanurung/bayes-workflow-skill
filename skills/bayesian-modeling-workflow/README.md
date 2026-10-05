# Bayesian Modeling Workflow

An agent reasoning and execution manual derived primarily from Gelman, Vehtari, McElreath and collaborators' official *Bayesian Workflow* materials. Develop the smallest useful scientific model; simulate, diagnose, criticize and revise for a reason. This is an original source-grounded synthesis, not a book summary or a rigid checklist.

## Use

Invoke `$bayesian-modeling-workflow` with a dataset/question, model code, diagnostic output or predictive discrepancy. The agent selects a playbook, inspects evidence and returns concrete next steps, code and validation. Existing-model reviews return KEEP / CHANGE / CHECK / OPTIONAL. Every expansion states its observed inadequacy, expected consequence and new risks.

## Architecture

| Location | What it contains | Loading rule |
|---|---|---|
| [SKILL.md](SKILL.md) | Purpose, task routing, compact iterative workflow, four problem classes, safeguards and output requirements | Always |
| [references/](references/workflow-principles.md) | Canonical reasoning for formulation, priors, simulation, computation, PPC, expansion, hierarchy, LOO, latent models, modes, SBC, sensitivity, debugging and reporting | Load the issue-specific module linked by the selected playbook |
| [playbooks/](playbooks/new-analysis.md) | New analysis, existing review, failing fit, divergences, PPC, k, hierarchy, identification, latent model, comparison and expansion | Select by request and observed symptom; combine when causes overlap |
| [examples/](examples/cmdstanr-patterns.md), code/ | Small documented R, Stan, brms, cmdstanr/posterior/bayesplot/loo idioms; six full Stan templates and thirteen R files | Read assumptions/input/output/failure metadata before instantiating |
| [case-studies/index.md](case-studies/index.md) | Local and transferable reasoning across all 22 themes/23 pages | Retrieve a comparable failure/development pattern |
| [references/source-map.md](references/source-map.md) | Principle IDs, exact pinned source paths, case/sections, claim type, supplemental APIs, licenses and errata | Check grounding or source evolution |
| research/ | [Inventory](research/source-inventory.md), [coverage](research/coverage-ledger.md), [matrix](research/evidence-matrix.md), [ambiguities](research/unresolved-questions.md), hashes and manifests | Audit completeness/provenance; not part of routine full-context loading |
| reports/ and tests/ | [Adversarial review](reports/adversarial-review.md), [validation](reports/validation.md) and reproducible smoke tests | Inspect quality/execution scope or rerun checks |

## Grounding and boundaries

Official source snapshot: `ceb65599292320fc7ddb565d73f8d6e41cfe7a64`, retrieved 2026-10-04. All 296 tracked files inventoried; 52 R, 3 Rmd, 130 Stan and 6 Quarto sources inspected. Source inspection does not mean every historical fit was replayed. The matrix was completed before SKILL.md creation, recorded in [evidence checkpoint](research/evidence-checkpoint.json).

The source map distinguishes direct local evidence, repeated demonstrations, synthesis, additional generalization and current primary API guidance. Corrections include sleep priors/baseline/N, roaches zeros, R2D2 residual prior and SBC rejection inequality. Unresolved code-review inferences are qualified; simulated coronavirus MRP inputs and provisional birthdays fits are not presented as validated empirical conclusions.

The main implementation target is R with cmdstanr/Stan, brms, posterior, bayesplot and loo. Python ports were inspected selectively for useful interface/coordinate patterns and are secondary. Missingness, ordinal/general survival and derived biological-score questions receive transferable scientific scrutiny, not invented domain-specific model prescriptions.

## Validation and updating

Read the validation report for executed versus proposed checks. Run `Rscript tests/smoke.R .` from this skill directory for pure-R simulation/algebra checks, and `python3 tests/validate_structure.py .` for file/provenance structure. Compile Stan templates using a current compiler with pedantic mode; actual scientific analyses still require fit diagnostics, prior/PPC and appropriate validation. Integration fragments need the stated inputs and installed packages.

When updating, refresh official inventory and errata first, modify the evidence matrix/source map, update only implicated modules/code and repeat affected tests/agent exercises. Do not silently turn an illustrative local threshold or an unresolved inference into universal guidance.

Primary attribution and applicable per-source license notices are in the source map. No original datasets or entire case scripts/prose are bundled.

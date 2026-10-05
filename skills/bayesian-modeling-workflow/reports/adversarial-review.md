# Final adversarial review

Completed 2026-10-04 after source inspection, the pre-authoring evidence matrix, module construction, code checks and four independent task exercises. The perspectives below are review lenses, not claims that credentialed external reviewers certified the skill. Independent agents solved tasks; the primary author reconciled findings against official sources and current primary documentation.

## Four perspectives

| Perspective | Challenge | Final disposition |
|---|---|---|
| Bayesian statistician | Does the skill confuse calibration with learning, prediction with mechanism/causality, or conditional parameters with population estimands? Does it invent acceptance thresholds? | Distinctions are explicit. SBC needs learning/data-dependent quantities; nonlinear group means need integration and target weights. Diagnostic thresholds are qualified heuristics. elpd uncertainty and scoring measure must match the task. Missingness/causal/ordinal/general-survival transfers are marked supplemental rather than attributed as complete official examples. |
| Applied scientist | Can the workflow handle repeated units, cohorts, dropout, signed scores and meaningful scientific contrasts without demanding unnecessary complexity? | Formulation precedes family/formula choice; units, assignment, baseline conditioning, missingness, selection, exposure and target population are mandatory reasoning. The expansion ladder branches by named inadequacy. Stop conditions permit a useful qualified model or narrower claim. A realistic longitudinal task selected this route. |
| Stan practitioner | Does computation advice address posterior structure before tuning, preserve prior equivalence, and verify generated quantities? | Trees separate geometry, identification, numerical bugs and MC precision. No-divergence fits can still mix poorly. CP/NCP choice depends on information. Correlated-effect orientation is algebraically/simulation checked. Constrained-scale normalization and latent predictive integration are qualified. Six templates compile; a representative template executes HMC/GQ. |
| Agent/tool designer | Can an agent choose a next action without loading the entire manual? Are symptoms linked to discriminating evidence and validation? | SKILL.md is 74 lines with routing, iterative states, four failure classes, safeguards and result contract. Eleven playbooks point to canonical modules; case syntheses supply local reasoning rather than duplicate theory. Four fresh task exercises produced appropriate diagnoses and concrete next checks. |

## Issues challenged and repaired

| Risk discovered or tested | Repair / qualification | Canonical location |
|---|---|---|
| A rigid mandatory sequence could misrepresent early comparison in dogs | Allow early screening; require checking the selected model before final interpretation | Workflow principles; comparison |
| Treating every high-k local-effect likelihood as theoretically invalid | Explain exact augmented-space conditional LOO can be valid but PSIS unstable; distinguish naive in-sample averaging and integrated held-out scores | Model comparison/LOO |
| Confusing approximation repair with substantive model repair | Separate moment matching/refits from observation-model revision; preserve influential-unit investigation | Model comparison/LOO; high-k playbook |
| Universal non-centering or adapt_delta advice | Use information-dependent CP/NCP, geometry plots and matching models before settings; inspect warning-free poor mixing | Computation; hierarchy |
| Proper-prior ridges mislabeled improper posteriors | Separate likelihood invariance, weak identification and an actually improper posterior | Computation; weak identification |
| Centered sum-to-zero priors silently changing inferred scale | State dimensional normalization and marginal-SD convention; source intent remains unresolved rather than declared an author erratum | Hierarchy; unresolved questions |
| Row/column Cholesky orientation could contradict declared covariance | Use canonical column-wise transformation and numerical covariance check; qualify upstream inference | Hierarchy; Stan patterns |
| A bounded prior omitting a parameter-dependent normalizer copied blindly | Derive intended joint prior before reuse; avoid claiming the upstream joint intent is settled | Debugging; unresolved questions |
| `re_formula=NA` misreported as population marginalization | State typical-group conditional prediction; integrate new effects and population weights for marginal targets | Hierarchy; brms patterns |
| Uniform parameter SBC ranks treated as implementation proof | Check unused parameters, contraction, recovery and data-dependent quantities; test mixture allocation and consistent ordering | SBC; simulation patterns |
| Restricted SBC described as universally forbidden or unrestricted success | Current documentation permits a declared restricted domain; disclose exclusions, inference randomness and limits. Post hoc survivors cannot certify the original domain | SBC; source map |
| An illustrative prior or numerical threshold treated as portable | Keep parameter units, corrected sleep-study baseline/priors and joint prior simulation; qualify all local budgets/thresholds | Priors; computation; SBC |
| Quadrature accepted from normal moments alone | Compare independent integrals and increasing resolution. A Q=41 fixture failure led to stronger accuracy checks, not a universal Q=81 prescription | Simulation patterns; R smoke suite |
| Provisional Pathfinder fits or simulated MRP inputs treated as final empirical evidence | Preserve explicit source limitations and demand fit-specific validation | Case syntheses; coverage ledger |
| A random-effect variance interpreted as individual causal-effect variance | Explain missing potential-outcome association; distinguish conditional treatment heterogeneity and observed trajectory variation | Problem formulation; supplemental primary research |
| Source inspection or syntax checks mistaken for full execution | Record compilation, R execution, native HMC and unexecuted package integrations separately | Validation report |

## Duplication and cookbook audit

Canonical explanations live in references; playbooks specify action/output and link to those explanations. Case tables reconstruct observations, diagnoses, interventions and checks with local caveats. SKILL.md contains the minimum safeguards needed even when a later module is not yet loaded. The source map and research manifests are audit material loaded conditionally, not mandatory routine context.

There is no fixed list of models to fit, no arbitrary automatic winner rule, no universal prior scale, no universal iteration/SBC count, and no claim that all models must eventually become hierarchical or latent. Each intervention requires its scientific consequence, new risks and validation. Remaining source-specific uncertainties are preserved in the [unresolved ledger](../research/unresolved-questions.md); they do not justify fabricating resolutions.

## Final assessment and limits

The completed skill satisfies the requested reasoning/execution architecture and covers all official themes at the recorded scope. The adversarial exercises demonstrate appropriate next-action reasoning on four tasks, not exhaustive behavior across every scientific setting. Runtime validation is representative; the [validation report](validation.md) states unexecuted integrations and required application checks. No unresolved issue is concealed as a universal author recommendation or a successful scientific inference.

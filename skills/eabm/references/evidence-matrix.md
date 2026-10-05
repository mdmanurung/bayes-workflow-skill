# Evidence matrix

The ledger was built before guides. This matrix links the recommendation to its source layer. `direct-eabm` means book reasoning; `eabm-code` means executable example; `method-paper` adds a methodological condition/correction; `translated` implements the concept in another language; `synthesized` is this skill's routing/action ordering. Official API evidence is recorded in `implementation_source`, not mislabeled book prose. Full recommendation records are in `evidence-matrix.json`.

| ID | Recommendation | Primary evidence | Supplement / API | R status |
|---|---|---|---|---|
| R01 | Match encoding to task; label units | E01: colour/axes; direct-eabm | M-VIS; D-GGDIST | translated; see parity |
| R02 | Preserve identifiers; align before arithmetic | E02: groups/dimensions; eabm-code | D-AZ; D-POSTERIOR | translated; see parity |
| R03 | Show shape; specify interval and mass | E03: uncertainty; direct-eabm | D-AZ; D-GGDIST | translated; see parity |
| R04 | Inspect chains and geometry before extending | E04: synthetic chains; direct-eabm | M-RHAT; M-ENERGY; D-STAN; D-POSTERIOR; D-BAYESPLOT | translated; see parity |
| R05 | Fix geometry or add draws if stable growth | E04: ESS; direct-eabm | M-RHAT; M-ENERGY; D-STAN; D-POSTERIOR; D-BAYESPLOT | translated; see parity |
| R06 | Compute mean/quantile MCSE in scientific units | E04: MCSE; direct-eabm | M-RHAT; M-ENERGY; D-STAN; D-POSTERIOR; D-BAYESPLOT | translated; see parity |
| R07 | Keep all estimation draws; justify diagnostic thinning | E04: thinning; direct-eabm | M-RHAT; M-ENERGY; D-STAN; D-POSTERIOR; D-BAYESPLOT | translated; see parity |
| R08 | Locate failures; rescale/reparameterize; bounded tuning | E04: divergences; direct-eabm | M-RHAT; M-ENERGY; D-STAN; D-POSTERIOR; D-BAYESPLOT | translated; see parity |
| R09 | Inspect per chain; reparameterize | E04: energy; eabm-code | M-RHAT; M-ENERGY; D-STAN; D-POSTERIOR; D-BAYESPLOT | translated; see parity |
| R10 | Revise justified priors/model then resimulate | E05: heights; direct-eabm | M-PPC; M-ECDF; D-BAYESPLOT-PPC; D-BRMS | translated; see parity |
| R11 | Choose quantities exposing a suspected failure | E05: heights summaries; direct-eabm | M-PPC; M-ECDF; D-BAYESPLOT-PPC; D-BRMS | translated; see parity |
| R12 | Use justified reference; randomized discrete PIT; LOO diagnostics | E05: PIT/coverage; direct-eabm | M-PPC; M-ECDF; D-BAYESPLOT-PPC; D-BRMS | translated; see parity |
| R13 | Consider justified count model; rerun targeted PPC | E05: crabs + notebook; direct-eabm | M-PPC; M-ECDF; D-BAYESPLOT-PPC; D-BRMS | translated; see parity |
| R14 | Cross-validated probabilities; category checks | E05: binary/ordinal; direct-eabm | M-PPC; M-ECDF; D-BAYESPLOT-PPC; D-BRMS | translated; see parity |
| R15 | Replicate observation process; survival checks | E05: survival; direct-eabm | M-PPC; M-ECDF; D-BAYESPLOT-PPC; D-BRMS | translated; see parity |
| R16 | Check every fit; compare estimands and MCSE | E06: refitting; direct-eabm | M-SENSE; M-PSIS; D-AZ-SENSE; D-PRIORSENSE | translated; see parity |
| R17 | Check importance diagnostics; corroborate with refit | E06: power scaling; direct-eabm | M-SENSE; M-PSIS; D-AZ-SENSE; D-PRIORSENSE | translated; see parity |
| R18 | Justify effect-scale priors; repeat diagnostics | E06: body fat; direct-eabm | M-SENSE; M-PSIS; D-AZ-SENSE; D-PRIORSENSE | translated; see parity |
| R19 | State perturbation target; select top-level terms for this question | E06: bacteria hierarchy; direct-eabm | M-SENSE; M-PSIS; D-AZ-SENSE; D-PRIORSENSE | translated; see parity |
| R20 | Align likelihood contributions on common observed scale | E07: likelihood comparability; direct-eabm | M-LOO; M-PSIS; M-STACK; D-LOO; D-LOO-K | translated; see parity |
| R21 | Establish target; compute and diagnose | E07: predictive accuracy; direct-eabm | M-LOO; M-PSIS; M-STACK; D-LOO; D-LOO-K | translated; see parity |
| R22 | Report difference/SE and practical consequences | E07: ELPD differences; direct-eabm | M-LOO; M-PSIS; M-STACK; D-LOO; D-LOO-K | translated; see parity |
| R23 | Inspect data; improve estimate; retain valid observations | E07: Pareto-k; direct-eabm | M-LOO; M-PSIS; M-STACK; D-LOO; D-LOO-K | translated; see parity |
| R24 | Check post-repair k and scores; refit remaining cases | E07/E09: repair LOO; direct-eabm |  | translated; see parity |
| R25 | Diagnose inputs; mix distributions; assess new data | E07: stacking; direct-eabm | M-LOO; M-PSIS; M-STACK; D-LOO; D-LOO-K | translated; see parity |
| R26 | Nest selection or reserve test data | E07: selection; direct-eabm | M-LOO; M-PSIS; M-STACK; D-LOO; D-LOO-K | translated; see parity |
| R27 | Lazy likelihood; shared indices; enlarge until precision adequate | E08 + wells script; direct-eabm |  | translated; see parity |
| R28 | Validate q; check corrected PSIS; MCMC subset check | E08: approximate posterior; direct-eabm | M-LARGE; M-LARGE-2019; D-AZ-SUB; D-LOO-SUB | translated; see parity |
| R29 | Continue criticism and consider count likelihood revision | E09 + roaches script; direct-eabm |  | translated; see parity |
| R30 | Explicitly define held-out block and available outcomes | E10 + laliga notebooks; direct-eabm |  | translated; see parity |
| R31 | Integrate new effects or refit grouped folds | E10: teams; direct-eabm | M-LOO; D-AZ; D-LOO | translated; see parity |
| R32 | Validate reference model; inspect conditional structure | E11: BART; direct-eabm | M-PROJ; D-KULPRIT; D-PROJPRED | translated; see parity |
| R33 | Check reference; project; validate chosen size | E11: Kulprit; direct-eabm | M-PROJ; D-KULPRIT; D-PROJPRED | translated; see parity |
| R34 | Document constraints; verify quantiles and predictive implications | E12: quantiles/entropy; direct-eabm | D-PRELIZ; D-SHELF | translated; see parity |
| R35 | Use external targets at design points; iterate | E12: predictive elicitation; direct-eabm | D-PRELIZ; D-SHELF | translated; see parity |
| R36 | Validate generator; record failures; inspect ranks and diagnostics | E13: SBC; direct-eabm | M-SBC; M-SBC-PRIOR; M-SBC-POST; D-SBC; D-SIMUK | translated; see parity |
| R37 | Add likelihood and scientific test quantities | E13: test quantities; direct-eabm | M-SBC; M-SBC-PRIOR; M-SBC-POST; D-SBC; D-SIMUK | translated; see parity |
| R38 | Use verified conditional method; state local scope | E13: posterior SBC; direct-eabm | M-SBC; M-SBC-PRIOR; M-SBC-POST; D-SBC; D-SIMUK | translated; see parity |
| R39 | Report model, checks, caveats and reproducible artifacts | E14: reporting; direct-eabm | M-REPORT; M-VIS | translated; see parity |
| R40 | Classify failure; choose smallest justified intervention; recheck | E15: iteration; direct-eabm | M-VIS | translated; see parity |

## Explicit additions and corrections

| ID | Recommendation | Source | Evidence status |
|---|---|---|---|
| S01 | Classify computational, geometry, prior, misspecification, predictive instability and scientific failures before choosing an intervention. | E04–E15 | synthesized |
| S02 | Order interventions by diagnosed mechanism and rerun the checks affected by a revision; tuning alone is not a general divergence remedy. | E04; M-RHAT; D-STAN | synthesized |
| S03 | Check importance diagnostics at every power-scaling alpha and corroborate consequential local results with justified refits. | M-SENSE; M-PSIS; D-PRIORSENSE | method-paper |
| S04 | Do not compare a single SBC posterior to its prior; use truth/posterior exchangeability over repeated simulations and data-dependent quantities. | M-SBC-PRIOR; M-SBC | method-paper |
| S05 | Do not infer causal adjustment or causal importance from predictive variable selection. | E11 predictive scope; scientific estimand reasoning | synthesized |
| S06 | Use original-plus-simulated information for the posterior SBC conditional construction. | M-SBC-POST; D-SIMUK | method-paper |
| S07 | Use tri-state executable gates: unknown evidence requests a check, not an assertion that it passed. | E15 iterative reasoning | synthesized |
| S08 | Treat sampled large-data LOO units as a probability sample and report subsampling uncertainty; unsampled units were not individually checked. | E08; M-LARGE | method-paper |
| S09 | Treat a stronger prior as a scientific information/regularization choice validated by induced predictions and sensitivity. | E05; E06; E12 | synthesized |
| S10 | Main text/methods/supplement/reproduction placement is an audience-oriented reporting synthesis. | E14; M-REPORT | synthesized |

See [source defects](source-ledger.md#source-defects-and-boundaries), [bibliography](bibliography.md) and [API checks](api-verification.md). The source hierarchy is EABM prose → executable examples → primary methods → official APIs. Corrections are explicit; source hierarchy does not require reproducing an obvious error.

## Runtime-derived API safeguards

| ID | Recommendation | Source / evidence status |
|---|---|---|
| API01 | ArviZ-stats 1.3 low-level PSIS negates input; pass negative log ratios, unlike R/legacy ArviZ. Check shared-draw weights. | D-AZ-STATS/D-LOO installed source and runtime; translated |
| API02 | simuk 0.3 run_simulations returns None; results are in .simulations; check completed/retained fit counts. | D-SIMUK source and two-fit smoke test; synthesized implementation guard |

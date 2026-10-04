# Final quality-control report

Snapshot: 2026-10-04. This report distinguishes statistical/source review, small runtime verification and unsupported/unexecuted operations. It does not certify every model an agent may encounter.

## Source fidelity and provenance

- Reviewed all substantive rendered EABM chapters alongside executable Quarto sources, linked model notebooks/scripts, helpers, comments and representative plots. [Inspection record](../references/source-inspection.md) gives scope; [manifest](../references/source-manifest.json) pins 36 text/code files to commit `d96c4c09ec1dc67c14ede90d5b9f491418f4d35e`.
- Built the 40-row [source ledger](../references/source-ledger.md) before writing guides. [Evidence records](../references/evidence-matrix.json) separate direct book reasoning, executable examples, primary-method additions, R translations and synthesized routes. No R package recipe is presented as native EABM prose.
- Recorded book/helper inconsistencies and resolved them with executable definitions, primary methods and official APIs: centered/noncentered wording, autocorrelation interpretation, in-sample versus CV scores, football links/outcome naming, SBC self-consistency/alias and rolling source API changes.
- Retrieved 85 bibliography URLs: 84 succeeded; the visualization paper DOI returned a publisher 403. Its verified author preprint and paper/code repository supply an accessible primary alternative. [Link log](source-link-checks.json) records retrieval availability, not statistical validation.
- Attribution and EABM's CC-BY-NC conditions are stated in the README/bibliography. No upstream notebooks or model-fit archives are redistributed.

## Executed checks

| Check | Result and interpretation | Evidence |
|---|---|---|
| PyMC/ArviZ integration | Two genuine NUTS fits, 4 chains, 1,000 warmup + 800 retained draws each; summaries, quantile MCSE, trace/rank/energy/pairs, targeted tail PPC, prior prediction, normalized likelihood/prior groups | [Runtime record](runtime-results.json); runnable `examples/python-workflow.py` |
| HMC screens in the toy fits | Zero post-warmup divergences; BFMI about 1.11–1.40; reported q95 MCSE about 0.005–0.009 against a declared toy 0.05-unit budget. R-hat/ESS screens checked before PPC/scoring | Integration output; figures/diagnostic tables |
| PSIS influence and moment matching | Normal tail-contaminated example original max k≈0.94; supported PyMC MM repaired max k≈0.37. Student-t max k≈0.10. Comparison uses repaired estimates; original diagnostics retained | Integration output; MM is an estimator repair, not a model adequacy claim |
| Python subsampling/update | PLPD pilot 20 units then **40 additional** → 60; subsampling SE fell about 0.49→0.13 in the small example | Runtime record; no ten-million-unit benchmark |
| Shared R/Python arrays | Same independent analytic posterior draws, same normalized likelihood and outcomes. R-hat/ESS/MCSE agree to displayed precision; maximum pointwise ELPD difference about 1.2e-6; small Pareto-fit differences remain | [Parity metrics](parity-results.json); analytic workflows |
| Exact analytic LOO reference | Worst sampled PSIS-versus-exact pointwise error about 0.0038 for base and 0.0006 for stronger prior | Parity metrics; numerical reference, not a general error guarantee |
| Power-sensitivity R/Python | ArviZ CJS-derived summary/plots and priorsense data/sequence/quantities executed; alpha-specific PSIS diagnostics on the same factors. Sign-convention fix verified; modest k/weight differences are retained rather than claiming bitwise parity | Parity metrics and runtime tables; R source/signature record |
| R diagnostics/PPC/energy | posterior summaries; bayesplot rank/PPC plots; synthetic NUTS energy metadata and direct empirical BFMI calculation executed | R runtime record; synthetic energy check verifies interface, not HMC adequacy |
| R large-data estimator API | On-demand Normal callback, PLPD/diff_srs, 10 sampled units updated to **25 total**; correct returned counts and subsampling error | R subsample log in runtime record |
| Analytic SBC | Python and R each 1,000 simulations, 100 independent rank draws; parameter and joint-likelihood ranks plus deliberately biased inference positive control; histogram and discrete-uniform ECDF plots with explicitly pointwise bands | [SBC results](runtime-results.json); scripts and figures. Not a custom-sampler calibration study |
| simuk execution | Two PyMC simulations/fits retained; rank DataTree stored in `.simulations`; `run_simulations` returns None | [Smoke record](simuk-smoke.json); no calibration claim from two simulations |
| PreliZ | Quartile constraints reproduced and maximum-entropy interval mass approximately 0.9; current fixed_stat/mutated-distribution contract checked | Runtime record |
| Independent translation mechanics | Per-unit scalar PSIS, current precomputed-weight LOO, exact R sample SD with ddof=1, rank plotting and signed comparison | [Raw translation transcript](forward-translation.md) |
| Adversarial reasoning | All 11 requested prompt types produced appropriate conditional checks/actions after review; translation discoveries incorporated | [Adversarial results](adversarial-results.md); small qualitative evaluation |

Python used a pure-Python PyTensor execution fallback because this environment lacked its linkable Python development library; the two toy NUTS fits and relevant callbacks still executed. R was provisioned locally for verification rather than assumed from a global `Rscript` command. These environment details do not change the skill's statistical recommendations or package-version record.

Visual QA caught an empty R plot export; a completed export was regenerated and inspected before delivery. The Python analytic SBC likelihood-rank ECDF has pointwise-band excursions (its mean is about 1.8 null mean-standard-errors above the reference). These observations are retained: pointwise bands are not a simultaneous test, and a random finite simulation cannot certify calibration. The deliberately biased positive control shows much larger systematic departures. Use a prespecified simultaneous diagnostic and more simulations for a substantive calibration claim.

## Structural checks and audit disposition

The canonical skill validator, local-resource/evidence audit, exhaustive tri-state routes and recipe syntax checks are recorded in [`structural-results.json`](structural-results.json). Python snippets and scripts parse; R snippets and example scripts were parsed with the actual R runtime. Unknown facts request evidence; numeric/string facts and invalid keys do not silently pass. After a model change, old gate facts must be invalidated. Structural checks do not test statistical truth. The [coverage audit](coverage.md) maps the requested components to delivered resources.

Reviewed scope, progressive disclosure and duplication: the approximately 1,000-word SKILL router loads one relevant guide/branch; detailed modules use the shared question/prerequisites/computation/interpretation/causes/anti-pattern/actions/follow-up/evidence format. Numeric heuristics are centralized and distinguished from illustrative simulation settings. Every intervention specifies affected rechecks; computation, adequacy, prediction and scientific identification remain separate.

## Capability and validation limits

- **Not executed:** CmdStan compilation, brms fitting/reloo/MM adapters, projpred search, full kulprit projection search, full R SBC/CmdStan backend ensemble, full conditional posterior SBC, every EABM model/notebook, or a ten-million-unit job. These routes were checked against primary/official contracts; use actual model/backend/version prerequisites.
- Core R and Python statistical workflows are equivalent, but representation/defaults, relative-efficiency interfaces, comparison schemas and subsampling controls differ. Moment-matching adapters and large-data estimators have partial feature parity.
- Python projection exists via kulprit; it does not provide a drop-in counterpart to projpred's validated-search flag. Use verified outer validation or the original R capability when required.
- PreliZ's full interactive observable-prior tooling has no verified mature comprehensive R API counterpart; direct R simulation/constraint solving preserves the reasoning. simuk and R SBC have different backend/quantity/rank-handling features; conditional SBC needs method-specific validation.
- Generic high-dimensional/multimodal geometry, unidentifiable scientific targets, unsupported callbacks, unreliable importance weights or mismatched likelihoods must escalate to explicit validation/refits/folds or a revised model/estimand; the skill does not fabricate an automated repair.
- Toy prior-predictive scales were generated and recorded; no external domain plausibility judgment is claimed. Good PPCs, low k or analytic SBC results are not proofs of scientific correctness. The skill's inference gates apply anew to each real fit.

Remaining uncertainty is explicit rather than hidden behind a “production-ready” label. The installed package is complete as an agent workflow; its documented runtime envelope and capability gaps remain part of responsible use.

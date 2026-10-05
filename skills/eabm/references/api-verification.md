# API and version contracts

Snapshot: **2026-10-04**. Official documentation was inspected alongside EABM's pinned executable sources and installed-source signatures. [`api-signatures.json`](api-signatures.json) records the precise Python environment. Runtime assertions/results are in [QC](../validation/quality-control.md); **signature inspection is not runtime execution**.

## Verified environments

| Branch | Installed versions | Verification scope |
|---|---|---|
| Python | Python 3.12.14; ArviZ 1.3.0, base 1.3.1, stats 1.3.3, plots 1.3.2; PyMC 6.3.2; Bambi 0.21.0; PreliZ 0.28.0; CmdStanPy 1.3.0; kulprit 0.6.1; simuk 0.3.0 | Installed signatures/source; representative ArviZ/PyMC/PreliZ operations executed; compiler-backed Stan and full projection/SBC ensembles not claimed |
| R | R 4.3.3; posterior 1.7.0; loo 2.10.1; priorsense 1.4.0; bayesplot 1.16.0; ggdist 3.3.3 | Installed signatures/source and shared-array/analytic workflows; brms, CmdStanR, projpred and SBC compiler workflows checked against official docs, not executed |

These are a reproducible tested snapshot, not permanent minimum-version promises. EABM's source requirements target ArviZ≥1.3/PyMC≥6; its historical helper/model files can contain older calls. Check versions and object classes on each real task.

## Python contracts and translation hazards

| Operation | Current contract | Legacy or hazard |
|---|---|---|
| Posterior object | xarray DataTree; `dt["posterior"].to_dataset()`; chain/draw axes | Legacy ArviZ 0.x InferenceData groups are xarray Datasets; do not combine construction syntaxes blindly |
| Dictionary construction | `az.from_dict({"posterior": {...}, "log_likelihood": {...}, ...}, coords=..., dims=...)` | Old `posterior=...` keyword syntax is not the new nested-group contract |
| Diagnostic results | DataTree inputs can return a named-group DataTree; DataArray inputs return DataArray | `np.asarray(az.bfmi(dt))` is wrong; extract `az.bfmi(dt)["energy"]`; serialize diagnostic datasets explicitly |
| Summary | `ci_kind`, `ci_prob`; `r_hat`, `ess_bulk`, `ess_tail`; interval columns reflect chosen type/mass | Do not assume old `hdi_prob` or a fixed interval default |
| Plots | `plot_trace_dist`, `plot_ppc_dist`, `plot_ppc_tstat`, `plot_pair(..., visuals={"divergence":True})` | Legacy `plot_trace`, `plot_ppc` or `divergences=True` are not new-call synonyms |
| Likelihood/prior computation | `pm.compute_log_likelihood(dt)`; `pm.stats.compute_log_prior(dt)` | PyMC 6.3 deprecates log-likelihood via `idata_kwargs`; root `pm.compute_log_prior` moved to `pm.stats` |
| PSIS-LOO | fields `elpd`, `se`, `p`, `elpd_i`, `pareto_k`, `good_k`; scalar `reff` | Legacy `elpd_loo`, `p_loo`, `loo_i`; current `loo` has no `scale=` keyword. R's unitwise efficiency vector requires [precomputed unitwise weights](../python/unitwise-psis.md), not passing a vector to `reff` |
| Comparison | `compare(..., method="stacking", var_name=..., reference=...)`; signed model-minus-reference `elpd_diff` | Legacy positive-loss `elpd_diff` and old `ic=`/`scale=` options; new probability/diagnostic columns need their stated caveats |
| Moment matching | `loo(..., moment_match=True, model=model)` for PyMC/Bambi adapters; explicit unconstrained callbacks otherwise | No universal automatic adapter for every backend/fit; density/Jacobian contracts are essential |
| Subsampling | `loo_subsample(method="lpd"|"plpd", model=.../log_lik_fn=...)`; `pointwise=True` for updating | `update_subsample(observations=n)` adds n new units in 1.3; R updater uses a total count |
| Sensitivity | `psense_summary`, selected factor names; per-alpha diagnostics via public `array_stats.psislw` | No umbrella `az.psislw` in this tested 1.x surface. `array_stats.psislw` internally negates input in 1.3, so pass negative log ratios; R `loo::psis`/legacy `az.psislw` accept log ratios directly. Cross-language weights verified. Do not assume summary validates every plotted alpha |
| Bambi prediction | `model.predict(dt, kind="response")` for replications; default `response_params` for expected/distribution parameters | Default prediction is not a noisy PPC sample; new-group options differ from brms |
| PPC SD | `t_stat="std"` uses population-SD convention; verified callable observation axis first | R `sd` uses sample SD; match with `np.std(x, axis=0, ddof=1)` for one observation axis |
| PreliZ | `maxent(..., fixed_stat=("mode", value))`; `quartile` mutates distribution | Book/historical `mode=` keyword; solver return need not be the fitted distribution |
| Projection | kulprit `ProjectionPredictive`, `project(method="forward", require_lower_terms=True)`, `compare` | Do not invent a `validate_search` keyword from projpred; examine actual family/search support |
| simuk | `SBC(...); run_simulations()` returns None and stores rank DataTree in `.simulations`; `compute_rank_statistics()` returns DataTree; `keep_fits` supports re-evaluation | Prior SBC supports multiple engines; posterior SBC in 0.3 is PyMC-only and uses augmented original+synthetic data; inspect mutable data/adapters and rank dependence |

For legacy 0.x, inspect installed signatures and use its InferenceData constructor/`plot_trace`/`plot_ppc`, `az.loo(..., pointwise=True)` result schema and legacy comparison sign. Statistical reasoning transfers; new large-data/MM APIs may be absent. Upgrade within the project's constraints or use explicit refits/folds. **Legacy fragments were not runtime-tested here.**

## R contracts

| Operation | Contract and key check |
|---|---|
| posterior | draws_array `(iteration, chain, variable)`; `summarise_draws`, rank-normalized `rhat`, bulk/tail ESS, `mcse_quantile(probs=...)`; retain chains until diagnostic extraction |
| bayesplot | PPC `yrep` `(draw, observation)`; NUTS metadata long columns `Iteration, Chain, Parameter, Value`; `mcmc_nuts_energy` consumes this metadata, not ordinary posterior draws |
| loo | normalized `ll` iteration×chain×unit; `relative_eff(exp(ll))` for MCMC; signed comparison differences; pointwise diagnostic IDs; named list candidates |
| loo subsampling | callback `f(data_i, draws)`; default method `plpd`, estimator `diff_srs`; S3 updater is `stats::update` dispatch to `update.psis_loo_ss`, with total requested observations |
| priorsense | `create_priorsense_data(x, log_prior=..., log_lik=...)`; `powerscale_sensitivity`, `powerscale_sequence`, `powerscale_plot_quantities`; selection and density components explicit |
| brms | Proper priors for `sample_prior="only"`; `posterior_predict` includes noise; new levels need declared sampling policy; MM requires `save_pars(all=TRUE)`, valid adapter/backend and possible recompilation; reloo is model/backend-specific |
| CmdStanR | `$draws`/`$sampler_diagnostics` formats and `$diagnostic_summary`; generated `log_lik` must represent intended units; compiler/Stan installation separate from R package |
| projpred | `cv_varsel(..., validate_search=TRUE)`, `suggest_size`, `project`; inspect supported reference/family, size rule and projected cluster weights |
| SBC | generator returns `variables` and `generated`; backend handles data/parallel chains; `compute_SBC`, `plot_rank_hist`, `plot_ecdf_diff` (not invented `plot_rank_ECDF`); derived-quantity callback contract version-specific |

Primary/official URLs are in [bibliography](bibliography.md). Some historical priorsense URLs moved to **mc-stan.org/priorsense** with hyphenated reference-page names; verified links replace stale guessed URLs. Unavailable hosted docs for kulprit/simuk were checked against their official repository and installed source. Every important statistical claim uses the evidence matrix independently of this API record.

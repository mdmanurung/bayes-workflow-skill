# Python ↔ R operation parity

Snapshot: 2026-10-04. **direct** = same diagnostic/estimand with verified implementations; **conceptually equivalent** = same statistical operation but representation/interface differs; **partial** = overlapping capabilities with meaningful gaps; **no mature equivalent** = no verified comprehensive counterpart for this specific feature. These labels do not promise identical numerical output, defaults or supported model classes.

| Operation | Python | R | Parity |
|---|---|---|---|
| Posterior representation | ArviZ 1.x / xarray DataTree; chain × draw × event | posterior draws_array iteration × chain × variable; separate likelihood/outcome metadata | conceptually equivalent |
| Summaries/intervals | ArviZ summary; explicitly select CI type/mass | posterior summarise_draws; quantiles; ggdist intervals | conceptually equivalent; defaults differ |
| Rank-normalized R-hat | ArviZ rhat(method="rank") | posterior rhat | direct |
| Bulk/tail ESS | ArviZ ess(method="bulk"/"tail") | posterior ess_bulk / ess_tail | direct |
| Estimand MCSE | ArviZ mcse(mean/quantile) | posterior mcse_mean / mcse_quantile | direct; preserve quantity/quantile |
| Trace/rank plots | plot_trace_dist; plot_rank | bayesplot mcmc_trace; mcmc_rank_overlay/ecdf | conceptually equivalent; envelopes/thinning differ |
| Divergences / geometry | PyMC sample_stats; ArviZ plot_pair/parallel | cmdstanr sampler_diagnostics; bayesplot nuts_params/mcmc_pairs | conceptually equivalent |
| Energy / BFMI | sample_stats.energy; bfmi / plot_energy | bayesplot mcmc_nuts_energy; cmdstanr diagnostic_summary | direct statistic, conceptually equivalent plots |
| Prior prediction | PyMC sample_prior_predictive; Bambi prior_predictive | brms sample_prior="only" then posterior_predict; CmdStan generated quantities | conceptually equivalent |
| Posterior prediction | PyMC sample_posterior_predictive; Bambi predict(kind="response") | brms posterior_predict; CmdStan generated quantities | conceptually equivalent; distinguish expected response |
| Targeted PPC | plot_ppc_dist/tstat/rootogram/pit; custom xarray statistics | bayesplot ppc_*; custom replicated statistics | conceptually equivalent; newer PAVA/survival/coverage features partial |
| Group/new-group PPC | labeled dimensions; explicit fresh random effects | ppc_stat_grouped; brms allow_new_levels/sample_new_levels; explicit simulation | conceptually equivalent; conditioning must match |
| Pointwise log likelihood | PyMC compute_log_likelihood; Bambi; CmdStanPy generated quantities | brms log_lik; CmdStan generated quantities | conceptually equivalent; adapters/units differ |
| PSIS-LOO / Pareto-k | ArviZ loo; PSIS in arviz-stats | loo; relative_eff; pareto_k_* | direct estimand/diagnostic; partial scalar versus unitwise efficiency API/default; precomputed route available |
| ELPD comparison | ArviZ compare | loo_compare | direct task; signs, columns/uncertainty presentation differ |
| Moment matching | ArviZ model= PyMC/Bambi or density callbacks | loo callbacks; brms moment_match + saved parameters | partial adapter parity; same method |
| Exact LOO refits | explicit leave-out refit workflow / supported adapter when present | brms reloo or explicit refits | conceptually equivalent; no universal automatic Python reloo API |
| Large-data LOO | loo_subsample / update_subsample; lpd/plpd/model callbacks | loo_subsample/update; multiple approximations/estimators | partial; do not map option names mechanically |
| Refitting sensitivity | PyMC/Bambi/CmdStanPy rebuild and refit | brms update/CmdStan refit | conceptually equivalent |
| Power sensitivity | ArviZ psense_summary/plots; explicit weight diagnostics | priorsense powerscale_sensitivity/sequence/diagnostics | direct core method; partial adapters and moment-matching support |
| Stacking weights | ArviZ compare(method="stacking") | loo_model_weights(method="stacking") | direct; optimizer/details may differ |
| Predictive mixture | ArviZ weight_predictions or weighted model selection + replication | weighted model selection + posterior_predict; supported brms mixture workflow | conceptually equivalent; no parameter pooling |
| Parameter/quantile elicitation | PreliZ quartile/maxent; distribution methods | base R quantile/CDF solving; SHELF expert workflow | conceptually equivalent for constraints; partial full tool parity |
| Automated predictive-prior elicitation/explorer | PreliZ ppe/predictive_explorer where supported | explicit simulation/optimization and external elicitation | no mature equivalent for the full verified interactive PPE API; same reasoning implementable |
| Shrinkage | PyMC/Bambi prior definitions | brms/Stan prior definitions | conceptually equivalent; induced scales must match |
| Projection | EABM kulprit ProjectionPredictive | projpred reference/search/project | partial; Python exists, validated search/model families differ |
| Prior SBC | tested manual loop; simuk | SBC generators/backends/compute_SBC | conceptually equivalent core; partial backend/diagnostic parity |
| Posterior SBC | simuk conditional API; method-specific manual workflow | custom conditional construction with SBC machinery if verified | partial; no verified drop-in generic R adapter |
| Scientific plots/reporting | ArviZ / matplotlib | bayesplot / tidybayes / ggdist | conceptually equivalent |

## Translation contract

1. Translate the scientific quantity and probability model first. Compare likelihood/prior parameterizations and prediction conditioning.
2. Preserve chain/event/observation IDs; Python arrays are usually `(chain, draw, event)`, R posterior arrays `(iteration, chain, variable)`, R PPC matrices `(draw, observation)`.
3. Make defaults explicit: interval type/mass, scales, likelihood names, relative efficiency, predictive target and new-group behavior. Inspect installed signatures before using legacy examples.
4. Verify output semantics with a small known example and shared log-likelihood values. A missing adapter is a capability gap, not permission to invent a function.
5. Return the requested branch. In `both`, explain the diagnostic once, then two short implementations.

Sources: E02–E13; package IDs in [bibliography](bibliography.md), [API verification](api-verification.md), and [runtime limits](../validation/quality-control.md). All R mappings are `translated`; parity classifications are `synthesized` from verified capabilities.

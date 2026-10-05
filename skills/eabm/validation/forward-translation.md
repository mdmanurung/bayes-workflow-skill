# Forward validation transcript: eabm skill

Date: 2026-10-04. Task: answer four Bayesian model-analysis questions using `/root/.codex/skills/remote-skills/eabm/SKILL.md`, without modifying the skill. This is an intermediate transcript, not validation of any user's fitted model.

Read: SKILL.md; API contracts; Python/R parity; threshold registry and JSON; evidence matrix and bibliography; SBC, model-comparison and variable-selection guides; Python/R diagnostics; Python/R predictive recipes; Python selection/SBC; Python/R comparison recipes. Official Stan, posterior, loo, bayesplot, ArviZ, projpred and kulprit documentation was checked online. Statistical workflow ordering is `synthesized`; R mappings are `translated`; package API facts are package-only evidence rather than direct book claims.

## 1. How do I validate my custom Stan model?

Validate its implementation, its numerical inference, and its scientific usefulness separately. No model code, fitting interface, data design, priors or fit diagnostics were provided, so all of these gates are currently unknown.

1. **Specify and audit the generative model.** Write the scientific estimand, support/units, grouping or time structure, missingness/censoring mechanism, likelihood and priors. Inspect Stan indexing, constraints, parameter transforms, any required Jacobians, and the correspondence between the model and generated quantities. Compare a few likelihood evaluations against an independent implementation or an analytic reduced case. Compiler warnings and gradient checks can expose implementation mistakes, but cannot certify the model.
2. **Check the generator and prior predictions.** Simulate parameters from proper priors and outcomes under the intended design, including group variation and the observation mechanism. Compare observable scales, extremes and scientifically meaningful quantities with external/domain reference values. Check an independently written generator where feasible: generator and fitter can share a bug. If prior predictions are implausible, revise the scientifically unjustified component and repeat this check.
3. **Validate each fit's computation.** Inspect post-warmup sampler warnings and chain-specific behavior, divergences, energy/BFMI, rank/trace plots, rank-normalized split/folded R-hat, bulk/tail ESS, and MCSE for the actual reported estimands and interval endpoints. Registry screening guidance is four independent chains, R-hat below 1.01, total bulk and tail ESS at least 100 times the chain count, zero post-warmup divergences, and an empirical BFMI warning below 0.3 by chain. These are screens, not sufficient conditions for correctness; MCSE has no universal percentage cutoff. Diagnose support/scaling, identification and geometry before simply extending iterations or raising acceptance. Recheck after every repair.
4. **Use fixed-truth experiments, then simulation-based calibration (SBC).** Fixed-truth simulations at selected configurations help localize coding/identification failures; a posterior estimate need not equal the true value in each experiment. For prior SBC, repeatedly draw truth from the prior, simulate a dataset, fit the model, check the fit, and rank the truth among posterior draws. Inspect rank histograms or ECDF differences with simulation uncertainty. Include scientific derived quantities and data-dependent quantities such as the joint log likelihood: marginal parameter ranks alone can miss an algorithm that returns prior draws. Handle ties with randomized ranks, use suitable near-independent rank draws or established ESS/thinning safeguards, retain full draws for estimation, and report every failed fit. Choose simulation count for the failure size you need to detect; a small pilot is not a powered validation study. Systematic departures can reflect coding/inference failures, dependence or tie-handling problems; histogram shape does not identify a unique cause. Uniform ranks are evidence consistent with calibration at the study's resolution, not proof of correctness.
5. **Criticize and stress-test the real-data fit.** Once computation is adequate, use targeted posterior predictive checks for the features the model could get wrong—dispersion, tails, zeros, groups, serial dependence, censoring, or the scientific contrasts. Check important conclusions under justified prior/likelihood alternatives. Evaluate predictions only for a clearly defined held-out task. Passing SBC does not establish real-data adequacy, and passing PPCs does not establish causal identification.

The next discriminating check is a small independently verified generator plus an analytically tractable special case, followed by an SBC pilot that retains fit failures and tests data-dependent quantities. An R CmdStan/SBC package route or a transparent Stan-interface simulation loop can implement it once the actual interface and model are known. Generic PyMC/Bambi simuk code should not be presented as an automatic custom-Stan adapter. Posterior SBC is a separate conditional construction involving original plus simulated information; simulating from the posterior and refitting only synthetic data with the original prior does not implement it.

Sources: EABM E04/E05/E13 (`direct-eabm`/`eabm-code`), [Stan SBC guide](https://mc-stan.org/docs/stan-users-guide/simulation-based-calibration.html), [Stan warnings](https://mc-stan.org/learn-stan/diagnostics-warnings.html), [Talts et al. SBC](https://arxiv.org/abs/1804.06788), [Modrák et al. test quantities](https://doi.org/10.1214/23-BA1404), [improved R-hat](https://doi.org/10.1214/20-BA1221). Gate ordering and the proposed next check are synthesized, not a direct quote from EABM.

## 2. Translate the older ArviZ workflow to R

The original `plot_trace`/`plot_ppc` syntax suggests a legacy project, but does not identify its version. First recover the original environment's ArviZ version, `type(idata)`, group names/dimensions, likelihood and predictive variable names, observation IDs, and summary/comparison settings. Stored metadata alone may not recover historical rcParams or custom defaults. ArviZ 0.x InferenceData has xarray Dataset groups; current 1.x uses DataTree. Do not apply the new nested `from_dict`/DataTree syntax blindly to the old objects.

Transfer labeled arrays, or use a verified fitting-backend adapter. In R the required inputs are:

| Quantity | R representation | Conversion check |
|---|---|---|
| Posterior draws | `posterior::draws_array`, iteration × chain × scalar variable | Transpose Python chain/draw axes; expand event coordinates to meaningful variable names; exclude warmup |
| Observed `y` | Vector with ordered observation IDs | Same values, units, support and ordering in every object |
| Replicated `yrep` | Draw × observation matrix | Each row is a joint noisy replicated outcome, not expected responses |
| Pointwise `ll` | Iteration × chain × held-out unit array | Complete normalized likelihood, no priors; preserve IDs and chain identity |

There is no universal R conversion for an arbitrary unidentified Python fit object. The following is the R analysis branch after those inputs have been extracted and audited:

```r
library(posterior)

# posterior_array: iteration x chain x variable, with variable dimnames.
draws <- posterior::as_draws_array(posterior_array)

# Explicit new reporting choice: 95% equal-tail intervals.
# Recover and implement the original interval type/mass if exact reproduction
# of the old az.summary() table is required; an HDI is not this interval.
summary_r <- posterior::summarise_draws(
  draws, "mean", "sd", "mcse_mean", "mcse_sd", "rhat", "ess_bulk", "ess_tail",
  q025 = function(x) stats::quantile(x, 0.025),
  q975 = function(x) stats::quantile(x, 0.975)
)
print(summary_r)

# Old az.plot_trace() typically combined trace and marginal density panels.
bayesplot::mcmc_trace(draws)
bayesplot::mcmc_dens_overlay(draws)
# An additional mixing check, not a substitute for the trace:
bayesplot::mcmc_rank_overlay(draws)

# Continuous-outcome distribution check corresponding to a density-overlay PPC.
stopifnot(ncol(yrep) == length(y))
bayesplot::ppc_dens_overlay(y = y, yrep = yrep)

# LOO: complete ll array, iteration x chain x held-out unit.
loo_r <- loo::loo(ll, r_eff = loo::relative_eff(exp(ll)), save_psis = TRUE)
print(loo_r)
loo::pareto_k_table(loo_r)
bad_units <- loo::pareto_k_ids(loo_r)
pointwise_elpd <- loo_r$pointwise[, "elpd_loo"]

# Models A/B must share target, observed values, scale and ordered unit IDs.
stopifnot(identical(unit_ids_a, unit_ids_b),
          dim(ll_a)[3] == dim(ll_b)[3])
loo_a <- loo::loo(ll_a, r_eff = loo::relative_eff(exp(ll_a)))
loo_b <- loo::loo(ll_b, r_eff = loo::relative_eff(exp(ll_b)))
candidates <- list(A = loo_a, B = loo_b)
comparison_r <- loo::loo_compare(candidates)
print(comparison_r, simplify = FALSE)
# Explicit weighting choice; recover the historic choice for reproduction.
weights_r <- loo::loo_model_weights(candidates, method = "stacking")
print(weights_r)
```

This implements the requested operations, not a promise of identical columns/defaults/numerical output. Use bars/rootograms or other appropriate checks for discrete outcomes. Choose targeted PPC statistics in addition to a pooled overlay when the failure question calls for them. If `exp(ll)` underflows, subtract a draw-independent maximum separately for each unit before exponentiating for `relative_eff`; retain the original `ll` for scoring. Candidate draw counts may differ; do not truncate chains to match them.

R `loo()` retains pointwise results without a Python-style `pointwise=TRUE` flag. `loo_compare()` supplies paired differences and their SE; weights require the separate call above. R differences are model-minus-best, normally nonpositive. Legacy ArviZ comparison tables used positive loss relative to best; current ArviZ 1.x uses signed differences. Check the old version/result schema before translating signs. ELPD-difference uncertainty concerns predictive accuracy across units; it is distinct from MCSE. Stacking weights describe a predictive mixture, not posterior model probabilities. Repair unreliable pointwise estimates before treating a comparison as decisive.

Sources: [posterior summaries](https://mc-stan.org/posterior/reference/draws_summary.html), [bayesplot trace/rank](https://mc-stan.org/bayesplot/reference/MCMC-traces.html), [bayesplot distribution PPC](https://mc-stan.org/bayesplot/reference/PPC-distributions.html), [loo](https://mc-stan.org/loo/reference/loo.html), [relative_eff](https://mc-stan.org/loo/reference/relative_eff.html), [loo comparison](https://mc-stan.org/loo/reference/loo_compare.html), [stacking API](https://mc-stan.org/loo/reference/loo_model_weights.html). R code is translated; EABM E02/E04/E05/E07 supplies statistical reasoning. R code was documentation-checked, not run in the current shell.

## 3. Translate the loo/bayesplot/brms/projpred workflow to current Python

Targeted current installed environment: ArviZ 1.3.0; arviz-base 1.3.1; arviz-stats 1.3.3; arviz-plots 1.3.2; xarray 2026.9.0; PyMC 6.3.2; kulprit 0.6.1. Check versions in the real project. Current constructor/result/plot contracts differ from legacy 0.x examples.

The short idiomatic LOO call is `az.loo(dt, var_name="y", pointwise=True)`, using a valid posterior plus complete labeled log likelihood. Its default relative-efficiency calculation is based on posterior variables and yields a scalar; it is not a mechanical replica of R's unit-specific `relative_eff(exp(ll))`. Current `az.loo(reff=...)` accepts a scalar, and passing a vector failed in this runtime. To preserve the unitwise likelihood-efficiency adjustment, precompute PSIS weights for each unit with the documented array interface, then pass those weights and Pareto-k to `loo`:

```python
import numpy as np
import xarray as xr
import arviz as az
from arviz_stats.base import array_stats

# ll: iteration x chain x observation, exactly as in the R question.
# draws: iteration x chain x scalar parameter; warmup excluded.
# param_names and obs_ids must label those last axes.
ll_cd = np.swapaxes(np.asarray(ll), 0, 1)  # chain x draw x observation
draws_cd = np.swapaxes(np.asarray(draws), 0, 1)
assert ll_cd.shape[:2] == draws_cd.shape[:2]
assert ll_cd.shape[2] == len(obs_ids)
assert draws_cd.shape[2] == len(param_names)
assert len(set(param_names)) == len(param_names)

dt = az.from_dict(
    {
        "posterior": {
            name: draws_cd[:, :, j] for j, name in enumerate(param_names)
        },
        "log_likelihood": {"y": ll_cd},
    },
    coords={"obs_id": obs_ids},
    dims={"y": ["obs_id"]},
)
ll_da = dt["log_likelihood"]["y"]
# Rescaling per unit prevents simple exponentiation underflow and leaves ESS
# invariant; use original ll_da for the score and importance ratios.
likelihood_scaled = np.exp(ll_da - ll_da.max(["chain", "draw"]))
reff_i = az.ess(likelihood_scaled, method="mean", relative=True)

log_weights = np.empty_like(ll_cd, dtype=float)
k_values = np.empty(ll_cd.shape[2], dtype=float)
for i in range(ll_cd.shape[2]):
    log_weights[:, :, i], k_values[i] = array_stats.psislw(
        ll_cd[:, :, i], r_eff=float(reff_i.isel(obs_id=i)), axis=(0, 1)
    )
# This 1.x routine accepts LOG LIKELIHOOD and negates it internally.
# Do not copy the old az.psislw(-log_likelihood) input sign here.
lw_da = ll_da.copy(data=log_weights)
k_da = xr.DataArray(k_values, dims="obs_id", coords={"obs_id": obs_ids})
loo_fit = az.loo(
    dt, var_name="y", pointwise=True,
    log_weights=lw_da, pareto_k=k_da,
)
print(loo_fit.elpd, loo_fit.se, loo_fit.p)
print(loo_fit.elpd_i)
print(loo_fit.pareto_k.where(loo_fit.pareto_k > loo_fit.good_k, drop=True))

# Current rank diagnostic: chainwise fractional-rank delta-ECDF.
# This is conceptually equivalent to examining chain ranks, but is not the
# exact histogram-overlay visualization from mcmc_rank_overlay().
az.plot_rank(dt, var_names=[param_names[0]])
```

The loop has the same scientific relative-efficiency target as R; bitwise numerical parity is not claimed because ESS/PSIS implementations and defaults can differ. For a very large dataset, do not allocate these full arrays: use the large-data approach below. The plot keeps real posterior chain identities. Current `plot_rank` does not take legacy `kind="vlines"` or a made-up histogram-overlay option. Its default autocorrelation-aware method differs from older rank envelopes.

For the exact R sample standard-deviation statistic, use `ddof=1`; blindly mapping to NumPy's default population SD changes the statistic:

```python
# yrep from bayesplot is a matrix: predictive draw x observation.
# A separate PPC object avoids assuming these rows map to posterior chains.
yrep = np.asarray(yrep)
y = np.asarray(y)
assert yrep.ndim == 2 and yrep.shape[1] == len(y) == len(obs_ids)
dt_ppc = az.from_dict(
    {
        "posterior_predictive": {"y": yrep[None, :, :]},
        "observed_data": {"y": y},
    },
    coords={"obs_id": obs_ids},
    dims={"y": ["obs_id"]},
)

def sample_sd(x):
    # ArviZ's callable t-stat input places observation dimensions first.
    return np.std(x, axis=0, ddof=1)

az.plot_ppc_tstat(dt_ppc, var_names=["y"], t_stat=sample_sd, kind="hist")
```

The singleton predictive chain axis is only an array representation of marginal replications, not fabricated MCMC diagnostic evidence. Retain genuine chain information for posterior diagnostics. These inputs must be noisy joint predictive replications on the intended observation scale. For multiple observation/event axes adapt the statistic and conditioning explicitly rather than flattening unrelated outcomes.

`brms::loo(fit, moment_match=TRUE)` has a current Python counterpart **when an actual supported PyMC/Bambi model accompanies its matching DataTree**:

```python
loo_mm = az.loo(
    dt_model, var_name="y", pointwise=True,
    moment_match=True, model=model,  # supported PyMC/Bambi model
)
print(loo_mm.pareto_k)
print(loo_mm.influence_pareto_k)  # original pre-repair influence diagnostics
```

A raw brms fit, Stan constrained draws or `ll` alone cannot supply that automatic adapter. For another backend, use the documented `az.loo_moment_match` interface with correct unconstrained draws, joint density and pointwise likelihood callbacks, including required Jacobians, or use explicit leave-out refits. Do not invent callbacks from missing information. Automatic moment matching cannot currently be combined with `log_lik_fn`, `log_jacobian` or mixture mode in `az.loo`. Recheck repaired k and numerical precision; refit unresolved units or use appropriate folds. Moment matching repairs an estimator, not model misspecification.

`projpred::cv_varsel(fit, validate_search=TRUE)` has **partial Python parity**, not a drop-in translation. Python has projection through kulprit for supported Bambi reference models:

```python
import kulprit as kpt

# A computationally adequate, regularized Bambi reference model and its dt_ref.
projection = kpt.ProjectionPredictive(reference_model, dt_ref, rng=23)
projection.project(method="forward", num_samples=200,
                   require_lower_terms=True)
print(projection.compare(stats="elpd"))
```

This is a supported search/projection API, **not a claim that the whole search has been cross-validated**. kulprit 0.6.1 `project` and `compare` have no `validate_search` keyword. projpred's flag reruns search within each validation fold; reproducing that safeguard requires a verified Python procedure that repeats reference fitting, projection search and size selection within outer training folds, or holding out evaluation data from the entire search. Keep the R projpred operation through a supported R integration when its precise validated-search capabilities are required for the original brms fit. Check family/reference-model/search support, projected weights, subset stability, cost and predictive loss. Predictive selection is not causal adjustment; do not drop required confounders based on predictive scores.

Sources: EABM E02/E04/E05/E07/E09/E11; [ArviZ loo](https://python.arviz.org/projects/stats/en/stable/api/generated/arviz_stats.loo.html), [ESS](https://python.arviz.org/projects/stats/en/stable/api/generated/arviz_stats.ess.html), [public array PSIS](https://python.arviz.org/projects/stats/en/stable/api/generated/arviz_stats.base.array_stats.psislw.html), [PPC t-stat](https://python.arviz.org/projects/plots/en/stable/api/generated/arviz_plots.plot_ppc_tstat.html), [rank plots](https://python.arviz.org/projects/plots/en/stable/api/generated/arviz_plots.plot_rank.html), [moment matching](https://python.arviz.org/projects/stats/en/stable/api/generated/arviz_stats.loo_moment_match.html), [kulprit official source](https://github.com/bambinos/kulprit), [projpred validated search](https://mc-stan.org/projpred/reference/cv_varsel.html). API facts were checked against installed source/signatures; the unitwise PSIS and exact sample-SD mapping are synthesized translations.

## 4. Ten million observations: do I need full LOO?

No. Choose an evaluation scheme for the scientific prediction task and a precision budget. Full exact LOO would require refitting for every held-out unit; full PSIS-LOO usually uses one posterior fit, but evaluating/storing all draw-by-unit likelihoods can still be prohibitive. With 4,000 draws, a 10-million-unit double-precision likelihood array alone is about 320 GB before intermediates. Posterior fitting cost is a separate problem from LOO evaluation/storage cost.

For a compatible observation-level target, a probability-sampled LOO estimator can estimate full-data ELPD using a cheap approximation for all units plus accurate sampled-unit corrections. Under simple random sampling without replacement, its difference-estimator structure is

\[
\widehat{\operatorname{ELPD}} = \sum_{i=1}^{N}\widetilde\ell_i
 + \frac{N}{m}\sum_{i\in s}(\ell_i-\widetilde\ell_i).
\]

This differs from fitting a smaller dataset and calling its ordinary LOO result the full-data answer. Start with a documented random pilot; inspect influence, rare contexts and sampled Pareto-k. Increase the sample until the **paired model difference** is stable and its subsampling uncertainty is sufficiently small for the decision. A pilot of 100 is illustrative, not guaranteed adequate. Use common sampled units across models with a supported paired subsample estimator. Properly justified strata require an estimator that supports that design; arbitrary oversampling cannot be treated as simple random sampling.

Use on-demand or chunked likelihood evaluation; current Python offers `az.loo_subsample`/`az.update_subsample` with model or likelihood callbacks, and R offers `loo::loo_subsample` with supported estimators/approximations. Do not mechanically map option names: Python 1.3 updater `observations=n` adds n new units; the R updater requests a total count. PLPD at a posterior mean may be poor for nonlinear or multimodal models. If using a variational/Laplace posterior, validate its approximation and any posterior correction separately; a large N does not make approximate inference automatically accurate.

Report predictive-evaluation uncertainty, MCMC/importance MC error, and subsampling error separately. Unsampled units have not been individually checked for high k. Repair or refit unreliable sampled cases as required. If the goal is new-group prediction or forecasting, use group/time/future folds with the correct omitted information; nominal observation count alone does not choose an appropriate held-out unit.

Sources: EABM E08 (`direct-eabm`/`eabm-code`), [Magnusson et al. 2019](https://proceedings.mlr.press/v97/magnusson19a.html), [Magnusson et al. 2020](https://proceedings.mlr.press/v108/magnusson20a.html), [loo large-data guide](https://mc-stan.org/loo/articles/loo2-large-data.html), [ArviZ subsampling](https://python.arviz.org/projects/stats/en/stable/api/generated/arviz_stats.loo_subsample.html), [R subsampling](https://mc-stan.org/loo/reference/loo_subsample.html). Precision-budget routing is synthesized; the probability-sampling/difference-estimator requirements are methodological.

## Verification performed and limits

- Installed Python package versions were queried rather than assumed. Signatures/source were inspected for constructor, ESS, LOO, compare, PPC t-stat, rank plot, subsampling/updating and kulprit projection. Official docs were checked online.
- Synthetic 4-chain, 200-draw, 12-unit arrays verified R-to-Python chain/draw transposition, labeled DataTree construction, likelihood-mean relative ESS, per-unit scalar `array_stats.psislw`, precomputed-weight pointwise LOO, `elpd`/`elpd_i`/`pareto_k` fields, custom `ddof=1` PPC and current rank plotting. The synthetic adjusted-weight LOO total was -24.247000559440174; dimensions of both pointwise outputs were `obs_id`. These values only confirm execution mechanics.
- A separate comparison smoke check confirmed current signed `elpd_diff` behavior: the lower-scoring model had a negative difference against the best reference. No substantive candidate-selection claim follows from this artificial example.
- Direct unitwise `az.loo(..., reff=DataArray)` and vectorized accessor PSIS both failed with an ambiguous-array-truth-value error in arviz-stats 1.3.3. The separately computed scalar-per-unit weights route succeeded. This correction is recorded here without editing the skill.
- `Rscript` was not available in the current shell. R recipes are checked against current official documentation and the skill's recorded contracts; no R runtime parity is claimed. The skill records a separate R audit, not guaranteed availability in this shell.
- No actual custom Stan code, data or fit was supplied. No Stan compilation, full SBC study, actual moment-matching fit, full projection search, nested search validation, or 10-million-unit run was executed. Installed signatures are not runtime verification of those operations.
- Packaging gap: SKILL.md/API verification link `validation/quality-control.md`, but that file was absent at this skill path. The missing link was reported to the parent; no skill file was changed.

Web source refs for parent reuse after required opening/inspection: `turn12view0` (Stan SBC), `turn12view1` (EABM SBC), `turn12view2` (Stan warnings), `turn12view3` (posterior summaries), `turn11view0` (current loo), `turn13view0` (array PSIS), `turn13view1` (ESS), `turn13view2` (relative_eff), `turn14view4` (PPC t-stat), `turn11view2` (rank plots), `turn11view4` (kulprit), `turn14view2` (projpred), `turn12view4` (loo large data), `turn14view3` (ArviZ subsampling), `turn13view4` (loo compare), `turn13view5` (weights).

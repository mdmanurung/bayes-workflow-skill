# Python predictive comparison recipes

Always apply [the target/reliability guide](../guides/model-comparison.md) first. These fragments use ArviZ **1.3** result fields, not legacy `elpd_loo`/`loo_i` names.

## Pointwise PSIS and paired comparison

**Purpose:** Estimate held-out predictive scores and expose unreliable or influential units before making a decision.

**Inputs:** Adequate fitted DataTrees `dt_a`, `dt_b`, common labeled outcome `y`, aligned unit IDs and complete normalized log likelihood.

**Assumptions:** Same predictive task and scoring measure; conditionally independent units or valid task-specific factorization; MCMC efficiency accounted for by the package or explicitly supplied.

**Code:**

```python
import arviz as az
import xarray as xr

ll_a, ll_b = xr.align(dt_a["log_likelihood"]["y"],
                     dt_b["log_likelihood"]["y"], join="exact", exclude={"chain", "draw"})
# Observation/event labels must match; candidate chains/draw counts may differ.
loo_a = az.loo(dt_a, var_name="y", pointwise=True)
loo_b = az.loo(dt_b, var_name="y", pointwise=True)
bad_a = loo_a.pareto_k.where(loo_a.pareto_k > loo_a.good_k, drop=True)
pointwise_difference = loo_a.elpd_i - loo_b.elpd_i
comparison = az.compare({"A": loo_a, "B": loo_b}, method="stacking")
print(loo_a, bad_a, comparison)
```

**Expected output:** `elpd`, `se`, `p`, `good_k`, `elpd_i`, `pareto_k`; a comparison table with signed `elpd_diff`, `dse`, diagnostic flags and weights. Current differences are model-minus-reference, nonpositive for the default best reference. `p_worse` is an approximation with documented small-data/small-difference caveats, not a universal posterior probability.

**Interpretation:** First inspect bad units and uncertainty. A superior score can coexist with systematic PPC failure. Stacking weights refer to a mixture of predictive distributions.

**Failure modes:** Different dimension names bypass an alignment audit; identical IDs but different outcomes; noncomparable censoring/transform scales; multiple log-likelihood variables left unspecified; search optimism.

**Next action:** Diagnose/repair high k, inspect unit differences and adequacy, then choose a practically useful candidate or mixture. For a large-data object, use the supported difference estimator/uncertainty rather than naively treating sampled contributions as the full dataset.

**Source:** E07, M-LOO/M-PSIS/M-STACK, D-AZ-LOO; schema checked against installed source.

For exact translation of R's likelihood-unit `relative_eff`, see [unitwise PSIS](unitwise-psis.md). Current `az.loo` expects scalar `reff`; its default differs from R's per-unit likelihood vector. Do not pass an unverified vector or silently call these defaults identical.

## Joint likelihood for aligned paired outcomes

**Purpose:** Predict both outcomes of a held-out match rather than only one response.

**Inputs:** `home_goals` and `away_goals` arrays, each with `(chain, draw, match)` and matching IDs.

**Assumptions:** Conditional independence given the modeled latent variables; holding out the joint match is the intended task. Correlated outcomes require the actual joint likelihood.

**Code:**

```python
home, away = xr.align(dt["log_likelihood"]["home_goals"],
                      dt["log_likelihood"]["away_goals"], join="exact")
dt["log_likelihood"]["match_joint"] = home + away
loo_joint = az.loo(dt, var_name="match_joint", pointwise=True)
```

**Expected output:** One pointwise score/Pareto diagnostic per match.

**Interpretation:** Adding factors changes the held-out unit and training information; concatenating them would define two response-level units. Neither automatically implements new-team prediction.

**Failure modes:** Home/away reversed; matches misaligned; latent group effects improperly conditioned on held-out data; missing conditional dependence.

**Next action:** Assess task-specific influence/PSIS reliability; use new-group or time folds when required.

**Source:** E10 football notebooks (`eabm-code`); target distinction `synthesized` from M-LOO.

## Supported moment matching

**Purpose:** Repair a high-k importance approximation while keeping the same model.

**Inputs:** Original PyMC/Bambi `model`, matching posterior DataTree and likelihood name, or complete documented unconstrained callbacks.

**Assumptions:** Current adapter supports this model; density reevaluation/Jacobians correct. Automatic support is not a promise for arbitrary CmdStanPy fits.

**Code:**

```python
loo_mm = az.loo(dt, var_name="y", pointwise=True,
                moment_match=True, model=model)
print(loo_mm.pareto_k, loo_mm.influence_pareto_k)
```

**Expected output:** Original influence-k and repaired approximation-k where supported; adapter warnings/errors remain actionable.

**Interpretation:** The estimator may improve even though an overdispersed count model still fails PPCs. Remaining bad k requires exact refits or suitable folds.

**Failure modes:** Unsupported backend; callbacks evaluated on constrained coordinates incorrectly; singular covariance; multimodality; persisted high k.

**Next action:** Recheck k/precision; refit unresolved units and validate their computation. Score each omitted outcome by integrating its likelihood over the leave-out posterior (log-mean-exp of draw-wise log likelihood); integrate new-group effects correctly.

**Source:** E09, M-MM, D-AZ-MM; current `model=` contract verified.

## Subsampled LOO

**Purpose:** Reduce pointwise evaluation/storage cost with a supported probability-sampling estimator.

**Inputs:** Valid DataTree/model; total unit count; precision budget; random subsample smaller than total units.

**Assumptions:** Target-compatible unit sampling, validated posterior and approximation; pilot includes influential contexts.

**Code:**

```python
sub = az.loo_subsample(dt, observations=100, method="plpd", model=model,
                       var_name="y", pointwise=True, seed=42)
print(sub.elpd, sub.se, sub.subsampling_se, sub.subsample_size, sub.pareto_k)
larger = az.update_subsample(sub, dt, observations=300, method="plpd",
                             model=model, var_name="y", seed=42)
```

**Expected output:** Estimated full-data score plus total/subsampling uncertainty and diagnostics for sampled units; larger sample update. Sample sizes are EABM-style pilots, not precision guarantees. In ArviZ 1.3, `update_subsample(observations=300)` adds 300 **new** units to the original sample; it does not set the total to 300. Inspect the returned `subsample_size`.

**Interpretation:** Grow the sample based on stability/error. Package-specific estimators/defaults differ from R `loo`; use common sampled units and a verified paired difference method when comparing.

**Failure modes:** Too few/too many requested observations; unsupported PLPD callback/model; biased approximate posterior; unsampled outliers; attempting to materialize a huge likelihood group despite an on-demand API.

**Next action:** Validate pilot/approximation/influence, increase the probability sample, use on-demand/chunked likelihood evaluation or scientifically appropriate folds; disclose remaining coverage limits.

**Source:** E08, M-LARGE/M-LARGE-2019, D-AZ-SUB.

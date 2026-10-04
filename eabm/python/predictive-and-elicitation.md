# Python predictive checks and elicitation

Reasoning: [predictive checking](../guides/predictive-checking.md), [elicitation](../guides/prior-elicitation.md). Code targets PyMC 6 / ArviZ 1.x.

## Fit with prior and posterior predictions

**Purpose:** Generate actual replicated outcomes and matching likelihood terms.

**Inputs:** Proper PyMC `model` with observed `y` and labeled observation dimension.

**Assumptions:** Correct generator, plausible design/support, justified priors; check prior predictions before substantive fitting.

**Code:**

```python
import pymc as pm
import arviz as az

with model:
    prior = pm.sample_prior_predictive(draws=500, random_seed=11)
az.plot_ppc_dist(prior, group="prior_predictive", var_names=["y"])
# Fit after inspecting observable plausibility:
with model:
    dt = pm.sample(draws=1000, tune=1000, chains=4, random_seed=12,
                   idata_kwargs={"log_prior": True})
    pm.compute_log_likelihood(dt)
    pm.sample_posterior_predictive(dt, var_names=["y"],
                                  extend_inferencedata=True, random_seed=13)
az.plot_ppc_tstat(dt, var_names=["y"], t_stat="std")
az.plot_ppc_tstat(dt, var_names=["y"], t_stat=0.95)
```

**Expected output:** Prior predictive and fitted DataTrees; plots of dispersion and upper quantile against observed statistics. Draw counts are illustrative computational settings, not adequacy thresholds.

**Interpretation:** Select statistics for the suspected failure. The mean is often weakly discriminating in location models. Inspect scales/zeros/tails/groups and scientific contrasts as appropriate.

**Failure modes:** Using expected means instead of noisy replications; generically overlaying distributions while ignoring dependence; fitting before checking extreme priors; mixing legacy/new keyword names.

**Next action:** Validate computation, then targeted PPCs; revise the mechanism that fails and rerun prior/computation/PPC/sensitivity.

**Source:** E05 (`direct-eabm`, `eabm-code`); D-PYMC/D-AZ-PLOTS.

For an exact translation of R `sd`, use a callable with `ddof=1`; NumPy/ArviZ's default `std` uses `ddof=0`. In the verified 1.x t-stat callback, observation dimensions come first:

```python
import numpy as np
def sample_sd(x):
    return np.std(x, axis=0, ddof=1)  # one observation axis; adapt for other event shapes
az.plot_ppc_tstat(dt, var_names=["y"], t_stat=sample_sd)
```

This is a `translated` convention check, not a different diagnosis. Match the statistic's definition on observed and replicated data and across languages.

## Targeted group and temporal statistics

**Purpose:** Expose group-specific or serial failures hidden by pooled plots.

**Inputs:** `yrep = dt["posterior_predictive"]["y"]` with `(chain, draw, obs_id)`, observed `y_obs` as xarray DataArray, aligned `group_id` and ordered time data.

**Assumptions:** Group/time labels align exactly; conditional existing-group replication differs from fresh-group prediction; lag statistic respects series boundaries.

**Code:**

```python
import xarray as xr
group = xr.DataArray(group_id, dims="obs_id", coords={"obs_id": yrep.obs_id}, name="group")
rep_group_sd = yrep.groupby(group).std("obs_id", ddof=1)
obs_group_sd = y_obs.groupby(group).std("obs_id", ddof=1)
rep_zeros = (yrep == 0).mean("obs_id")
obs_zeros = (y_obs == 0).mean("obs_id")
# Single series already ordered in time; do not span distinct groups:
rep_lag1_cov = ((yrep - yrep.mean("obs_id")) *
                (yrep.shift(obs_id=1) - yrep.mean("obs_id"))).mean("obs_id")
obs_lag1_cov = ((y_obs - y_obs.mean("obs_id")) *
                (y_obs.shift(obs_id=1) - y_obs.mean("obs_id"))).mean("obs_id")
```

**Expected output:** Draw-wise replicated statistics and observed reference values; plot replicated distributions with the reference, by group or time block.

**Interpretation:** Compare the specific feature and its uncertainty; pooled adequacy can hide group failures. Lag covariance is a feature check, not a complete temporal calibration test.

**Failure modes:** Misordered time; cross-group lag; unequal observation exposure; censoring not replicated; sparse-group statistics undefined.

**Next action:** Inspect failing groups/windows; revise justified dispersion/dependence/hierarchy and validate corresponding predictions.

**Source:** E05 reasoning; custom statistics `synthesized`; xarray implementation `translated` from the statistical quantity.

## Quantile elicitation

**Purpose:** Fit a candidate prior under declared quantile or interval constraints.

**Inputs:** External/domain judgments on a named parameter scale and distribution support.

**Assumptions:** Constraints are coherent; family chosen intentionally; prior predictions validate the result.

**Code:**

```python
import preliz as pz
candidate = pz.Normal()
pz.quartile(candidate, q1=-1, q2=0, q3=1, plot=False)
sd_prior = pz.Gamma()
pz.maxent(sd_prior, lower=0.5, upper=3, mass=0.9,
          fixed_stat=("mode", 1.0), plot=False)
print(candidate, sd_prior)  # fitted distributions are mutated in place
```

**Expected output:** Fitted distribution objects/constraint information. Values are a toy domain constraint, not general default priors.

**Interpretation:** Interval mass is not bounded support. The chosen scale prior jointly with location/effect priors may induce unrealistic outcomes.

**Failure modes:** Infeasible constraints; old PreliZ `mode=` keyword; taking a solver return value as the fitted distribution; parameterization mismatch when passing to PyMC.

**Next action:** Confirm implied quantiles/mass; simulate observables/derived quantities, revise and document information source.

**Source:** E12 (`eabm-code`, updated keyword from D-PRELIZ official API).

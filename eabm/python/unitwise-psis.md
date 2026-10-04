# Preserve R's unit-specific relative-efficiency adjustment

**Purpose:** Translate `loo::relative_eff(exp(ll))` when numerical/API equivalence of that adjustment matters.

**Inputs:** ArviZ 1.3 DataTree `dt` with complete `log_likelihood.y` dimensions `(chain, draw, obs_id)`; valid chain structure and posterior group.

**Assumptions:** Same likelihood units/IDs and properly explored MCMC. The idiomatic `az.loo(dt)` uses a posterior-based scalar efficiency; it is not exactly R's likelihood-unit efficiency vector. `az.loo(reff=vector)` fails in the tested 1.3.3 stats implementation.

**Code:**

```python
import numpy as np
import xarray as xr
import arviz as az
from arviz_stats.base import array_stats

ll = dt["log_likelihood"]["y"].transpose("chain", "draw", "obs_id")
scaled_likelihood = np.exp(ll - ll.max(["chain", "draw"]))
reff_i = az.ess(scaled_likelihood, method="mean", relative=True)
lw, k = np.empty_like(ll.values), np.empty(ll.sizes["obs_id"])
for i in range(ll.sizes["obs_id"]):
    # Current psislw negates input: for LOO, supply log likelihood directly.
    # Each call uses the relevant scalar; vector r_eff is not supported here.
    lw[:, :, i], k[i] = array_stats.psislw(
        ll.values[:, :, i], r_eff=float(reff_i.isel(obs_id=i)), axis=(0, 1))
loo_result = az.loo(dt, var_name="y", pointwise=True,
                    log_weights=ll.copy(data=lw),
                    pareto_k=xr.DataArray(k, dims="obs_id", coords={"obs_id": ll.obs_id}))
```

**Expected output:** Precomputed labeled PSIS weights, per-unit k and LOO output with current fields. This operation needs draw×unit storage; for massive data use the on-demand/subsampling route instead.

**Interpretation:** This preserves the efficiency adjustment's target; bitwise parity is not promised. ESS/PSIS numerical details differ slightly across implementations. Rescaling before exponentiating protects likelihood ESS from simple underflow and does not change it; original normalized likelihood remains the scoring input.

**Failure modes:** Wrong axis order; missing units; sign copied from legacy PSIS; constant/underflowed likelihoods with invalid ESS; pretending a scalar minimum preserves all per-unit MCSE behavior; using this large array for ten million units.

**Next action:** Inspect each unit's Pareto/precision diagnostics and repair/refit unresolved estimates. Validate the precomputed route on a small model after package upgrades. Adapter-based moment matching must follow its own contract; do not assume every efficiency option transfers automatically.

**Source:** D-LOO `relative_eff`; D-AZ-STATS/D-AZ-LOO installed source and independent forward runtime test. Statistical method M-PSIS/M-LOO; `translated`/`synthesized` implementation detail. R/Python correspondence is direct for the diagnostic concept but **partial** for this API/default.

# Python computation recipes

Target: ArviZ 1.3 / PyMC 6; inspect [version contracts](../references/api-verification.md) before adapting older InferenceData code. Reasoning: [diagnostics](../guides/diagnostics.md). Every fragment is a diagnostic operation, not an automatic pass/fail certificate.

## Chain-preserving summary and estimand precision

**Purpose:** Screen exploration and numerical precision, including a reported quantile.

**Inputs:** `dt`, an ArviZ/xarray DataTree with `posterior` chain/draw dimensions; named parameters and derived quantities.

**Assumptions:** Warmup excluded; genuine independently initialized chains; relevant moments exist; units and precision tolerance specified.

**Code:**

```python
import arviz as az

names = ["mu", "sigma"]  # replace with model parameters and scientific quantities
summary = az.summary(dt, var_names=names, ci_kind="eti", ci_prob=0.95, round_to=5)
q_mcse = az.mcse(dt, var_names=names, method="quantile", prob=0.95)
az.plot_trace_dist(dt, var_names=names)
az.plot_rank(dt, var_names=names)
```

For a scientific contrast, compute it draw-wise and retain axes before summarizing:

```python
posterior = dt["posterior"].to_dataset()
contrast = posterior["beta_a"] - posterior["beta_b"]
precision = {
    "rhat": az.rhat(contrast),
    "ess_bulk": az.ess(contrast, method="bulk"),
    "ess_tail": az.ess(contrast, method="tail"),
    "mcse_mean": az.mcse(contrast, method="mean"),
}
```

**Expected output:** Parameter/quantity summaries, quantile MCSE, chain-wise traces/ranks. Current `summary` uses `r_hat`, `ess_bulk`, `ess_tail`; interval columns reflect the explicitly chosen kind/mass.

**Interpretation:** Use the registry as screening guidance; compare MCSE in scientific units. Passing R-hat cannot compensate for divergences or low tail precision. Inspect raw unrounded diagnostics for decisions.

**Failure modes:** Flattened chains; absent derived quantities; nonfinite moments; rank envelopes affected by correlation; interval precision overlooked.

**Next action:** Localize nonstationarity/geometry or increase draws only when stable mixing and precision growth justify it; rerun after refitting.

**Source:** E02/E04 (`eabm-code`, `direct-eabm`), M-RHAT, D-AZ; contrast recipe `synthesized`.

## Divergences and energy

**Purpose:** Find where HMC trajectories fail and whether energy exploration is poor.

**Inputs:** HMC DataTree including `sample_stats.diverging` and `energy`, plus scientifically relevant geometry variables.

**Assumptions:** Correct sampler metadata; post-warmup draws; energy unavailable for some inference engines must not be invented.

**Code:**

```python
stats = dt["sample_stats"].to_dataset()
divergences_by_chain = stats["diverging"].sum("draw")
bfmi_by_chain = az.bfmi(dt)["energy"]
az.plot_energy(dt)
az.plot_pair(dt, var_names=["tau", "theta"],
             visuals={"divergence": True})  # restrict theta coords for large hierarchies
```

**Expected output:** Per-chain counts/BFMI, energy distributions and marked failing regions. `visuals` is the current plotting contract; legacy `divergences=True` is not a 1.x synonym.

**Interpretation:** Concentrated failures near small group scales suggest a funnel; boundaries/ridges require model-specific investigation. Centering choice depends on information, not a universal noncentering rule.

**Failure modes:** Misnamed imported sampler statistics; huge pair matrices; treating pooled BFMI as a chain-specific diagnosis; tuning hides efficiency problems.

**Next action:** Support/scaling audit → localized geometry/identification → justified reparameterization or prior/model revision → bounded tuning; rerun full computation/PPC.

**Source:** E04, M-ENERGY, D-AZ-PLOTS, D-STAN (`direct-eabm`, `method-paper`; ordering `synthesized`).

## CmdStanPy import

**Purpose:** Put Stan posterior, replicated outcomes and normalized unit log likelihood into an explicit analysis object.

**Inputs:** CmdStanPy fit with generated quantities `y_rep` and `log_lik`, outcome `y`, observation IDs.

**Assumptions:** Stan likelihood contributions contain all needed density terms; generated quantities correspond to the intended unit; sampler diagnostics retained.

**Code:**

```python
dt = az.from_cmdstanpy(
    posterior=fit, posterior_predictive="y_rep", log_likelihood={"y": "log_lik"},
    observed_data={"y": y}, coords={"obs_id": obs_ids},
    dims={"y": ["obs_id"], "y_rep": ["obs_id"], "log_lik": ["obs_id"]},
)
```

**Expected output:** DataTree with aligned posterior/sample_stats/predictive/likelihood/observed groups.

**Interpretation:** Inspect group names, dimensions, observation ordering and sampler-stat names before running the earlier fragments.

**Failure modes:** CmdStan compiler unavailable; generated quantities absent; backend variable mapping/version differences; conditional effects leak held-out data.

**Next action:** Validate the import against original draws and several manual likelihood values, then computation/PPC/comparison.

**Source:** E02 reasoning (`translated` backend route); D-CMDSTANPY/D-AZ official API. CmdStan compilation is not claimed by the skill's runtime checks.

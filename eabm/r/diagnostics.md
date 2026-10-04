# R computation recipes

Reasoning: [diagnostics](../guides/diagnostics.md). Sources: `posterior`, `bayesplot`, CmdStanR official APIs; R workflows are **translated**, not code supplied by EABM.

## Chain-preserving summary and quantity precision

**Purpose:** Screen exploration and numerical error for parameters and reported quantiles.

**Inputs:** `draws`, a posterior draws_array (`iteration, chain, variable`); `fit$draws()` from CmdStanR or `posterior::as_draws_array(brms_fit)` for supported adapters.

**Assumptions:** Warmup excluded; chain identity intact; moments exist; units and precision budget defined.

**Code:**

```r
library(posterior)
summary <- summarise_draws(
  draws, "mean", "sd", "rhat", "ess_bulk", "ess_tail", "mcse_mean",
  q95 = function(x) stats::quantile(x, 0.95),
  mcse_q95 = function(x) mcse_quantile(x, probs = 0.95)
)
bayesplot::mcmc_trace(draws, pars = c("mu", "sigma"))
bayesplot::mcmc_rank_overlay(draws, pars = c("mu", "sigma"))
# Derive scientifically meaningful contrasts while preserving chain structure:
derived <- mutate_variables(draws, contrast = beta_a - beta_b)
summarise_draws(subset_draws(derived, variable = "contrast"),
               "mean", "rhat", "ess_bulk", "ess_tail", "mcse_mean")
```

**Expected output:** One summary row per variable, rank/trace plots and draw-wise contrast diagnostics. Quantile probabilities/settings are illustrative reporting choices, not adequacy cutoffs.

**Interpretation:** R-hat screens alone are insufficient; tail/quantile precision may be limiting. Compare MCSE to a scientific tolerance using unrounded values.

**Failure modes:** Coercing to draws_matrix too early flattens chains; R/Python axis reversal; nonfinite moments; reporting only fixed-effect diagnostics.

**Next action:** Inspect chains/geometry or extend only stable fits with demonstrated precision growth; rerun all affected diagnostics.

**Source:** E04/M-RHAT reasoning; D-POSTERIOR/D-BAYESPLOT APIs (`translated`).

## CmdStanR divergences, energy and pairs

**Purpose:** Obtain per-chain warnings and locate difficult HMC geometry.

**Inputs:** CmdStanR MCMC `fit` with retained sampler diagnostics; posterior parameter array.

**Assumptions:** HMC/NUTS, post-warmup; selected parameters expose relevant scale/dependence.

**Code:**

```r
fit$diagnostic_summary()  # per-chain divergences, treedepth, E-BFMI
sd <- fit$sampler_diagnostics(format = "draws_array")
# bayesplot's NUTS contract is long: Iteration, Chain, Parameter, Value.
np <- do.call(rbind, lapply(seq_len(dim(sd)[3]), function(v) {
  do.call(rbind, lapply(seq_len(dim(sd)[2]), function(ch) {
    data.frame(Iteration = seq_len(dim(sd)[1]), Chain = ch,
               Parameter = dimnames(sd)[[3]][v], Value = sd[, ch, v])
  }))
}))
bayesplot::mcmc_nuts_energy(np)
bayesplot::mcmc_pairs(fit$draws(format = "draws_array"),
                     pars = c("tau", "theta[1]"), np = np)
# ArviZ-compatible empirical BFMI when only energy arrays are available:
bfmi <- apply(sd[, , "energy__", drop = FALSE], 2, function(e) {
  mean(diff(as.vector(e))^2) / mean((e - mean(e))^2)
})
```

**Expected output:** Chain-specific warning summary, energy plot, marked pairs and manual BFMI. Sampler names such as `divergent__`/`energy__` must match the official bayesplot NUTS convention. Packages can differ slightly in finite-sample variance conventions; retain which calculation was used.

**Interpretation:** Locate failing regions and assess energy per chain. A noncentered form can help weakly informed group effects, but well-informed groups may benefit from centering.

**Failure modes:** Expected stats absent for a different inference method; an incorrectly named long table; huge pairs plot; adjusting acceptance before diagnosing geometry.

**Next action:** Check support/scaling/identification, consider probability-preserving parameterization and bounded tuning, then refit and rerun computation/PPC.

**Source:** E04/M-ENERGY/D-STAN; D-CMDSTANR/D-BAYESPLOT (`translated`). The long-table construction avoids assuming every fit has a `nuts_params` method.

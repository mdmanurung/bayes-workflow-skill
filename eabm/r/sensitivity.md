# R sensitivity recipes

Reasoning: [sensitivity](../guides/sensitivity.md). Current verified core: posterior 1.7, loo 2.10, priorsense official documentation/source.

## Adapter or explicit-density power scaling

**Purpose:** Evaluate selected prior/likelihood strength perturbations with a valid approximation gate.

**Inputs:** A supported CmdStanFit/stanfit/brms fit or `draws` containing model variables and correctly evaluated `lprior`/`log_lik`. For generic objects use the documented `create_priorsense_data` contract.

**Assumptions:** Adequate base computation, proper alpha targets, consistent parameter measure and aligned factors. brms supplies its documented priorsense adapter; inspect selected prior/likelihood terms for hierarchical models.

**Code:**

```r
library(priorsense)
# `fit` may be a supported adapter; explicit arrays use the same selected factors.
data <- create_priorsense_data(fit)
sensitivity <- powerscale_sensitivity(data, variable = c("mu"),
                                      moment_match = FALSE)
sequence <- powerscale_sequence(data, variable = c("mu"),
                                lower_alpha = 0.8, upper_alpha = 1.25,
                                length = 3, moment_match = FALSE)
powerscale_plot_quantities(sequence)
```

Adapter variable names differ (`b_Intercept`, etc.); inspect `posterior::variables` and priorsense data before selecting `mu`. Use `prior_selection` / `likelihood_selection` to identify intended terms; do not assume a wildcard syntax without checking the installed contract. Defaults/illustrative alphas are centralized in the [registry](../references/thresholds.md).

An explicit PSIS check on the factors used for **each** alpha provides a transparent approximation gate:

```r
# log_component: iteration × chain array, sum only selected non-sampling factors.
# Draws must match those in the sensitivity call; here component is prior OR likelihood.
S <- length(log_component)
reff <- min(1, posterior::ess_basic(log_component) / S)
checks <- lapply(c(0.8, 0.99, 1.01, 1.25), function(alpha) {
  log_ratios <- matrix((alpha - 1) * as.vector(log_component), ncol = 1)
  ps <- loo::psis(log_ratios, r_eff = reff)
  w <- as.vector(stats::weights(ps, normalize = TRUE, log = FALSE))
  list(alpha = alpha, pareto_k = loo::pareto_k_values(ps), weight_ess = 1 / sum(w^2))
})
```

For priorsense's returned objects, also inspect its documented `diagnostics`/PSIS information and moment-matching warnings where available. If moment matching is enabled, raw-ratio checks above describe the **unrepaired** approximation; assess the repaired diagnostics separately. See the runnable analytic example for exact-density data construction and the actual returned schema.

**Expected output:** Sensitivity table, powered sequences/quantity plot, alpha-specific tail and weight-concentration diagnostics.

**Interpretation:** CJS-derived local gradients are not raw distances or automatic proof of conflict. Compare direction and size of scientific changes with MCSE and valid refits; local IS cannot explore absent support.

**Failure modes:** `lp__` used as prior; accidental powering of all random-effect conditional factors; insufficient saved density/callback information; poor overlap; selecting nonexistent variables.

**Next action:** Fix components, verify overlap, or use actual refits; validate computation/PPC of every revision. Do not apply a stronger prior solely to remove a sensitivity label.

**Source:** E06/M-SENSE/M-PSIS; D-PRIORSENSE/D-BRMS-SENSE official adapter; R (`translated`); separate weight gate (`synthesized`).

## Defensible refits

**Purpose:** Evaluate an alternative prior family or likelihood and matched scientific conclusions.

**Inputs:** brms fit/model/data and explicit scientifically motivated alternative priors/family.

**Assumptions:** Support/scientific estimand still comparable; priors named by parameter class and scale.

**Code:**

```r
fit_alt <- update(fit, prior = alternative_priors, seed = 31)
summary_alt <- posterior::summarise_draws(posterior::as_draws_array(fit_alt))
yrep_alt <- brms::posterior_predict(fit_alt)
# Recheck computation and the failed PPC features before comparing conclusions.
```

**Expected output:** Actual fitted alternative and its diagnostics/predictions.

**Interpretation:** Refitting includes family/support changes that a local power derivative cannot represent. If changing likelihood family, set the intended `family` explicitly and match derived quantities, rather than equating scale parameters.

**Failure modes:** Unchanged cached model despite a requested change; different estimands; poor alternate fit; preferred-answer prior search.

**Next action:** Report meaningful changes and their Monte Carlo precision; retain the model-development record.

**Source:** E06 (`direct-eabm` reasoning); D-BRMS official API (`translated`).

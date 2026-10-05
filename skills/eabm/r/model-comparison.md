# R predictive comparison recipes

Apply [target and reliability gates](../guides/model-comparison.md) before interpreting a table. Keep likelihood arrays iteration × chain × unit and preserve IDs separately.

## Pointwise PSIS and paired comparison

**Purpose:** Estimate LOO for compatible units and inspect influence/uncertainty before selection.

**Inputs:** `ll_a`, `ll_b` as normalized log-likelihood arrays and identical ordered `unit_ids_a`, `unit_ids_b`; valid posterior computation.

**Assumptions:** Same response values, scale, omitted information and unit; labels alone do not prove comparability. Priors are excluded from log likelihood.

**Code:**

```r
stopifnot(identical(unit_ids_a, unit_ids_b), dim(ll_a)[3] == dim(ll_b)[3])
# Draw counts may differ across models; only unit alignment is essential.
reff_a <- loo::relative_eff(exp(ll_a))
reff_b <- loo::relative_eff(exp(ll_b))
loo_a <- loo::loo(ll_a, r_eff = reff_a, save_psis = TRUE)
loo_b <- loo::loo(ll_b, r_eff = reff_b, save_psis = TRUE)
loo::pareto_k_table(loo_a)
bad <- loo::pareto_k_ids(loo_a)  # current package draw-count-dependent threshold
comparison <- loo::loo_compare(list(A = loo_a, B = loo_b))
print(comparison, simplify = FALSE)
weights <- loo::loo_model_weights(list(A = loo_a, B = loo_b), method = "stacking")
```

Models may have different iteration/chain counts; do not truncate draws to force equality. Very negative log likelihood can underflow on exponentiation: rescale likelihoods per unit by a draw-independent constant before `relative_eff`, while retaining original log likelihood for scoring.

**Expected output:** ELPD/SE, pointwise scores/Pareto-k, paired `elpd_diff`/`se_diff` and predictive weights. Current differences are nonpositive relative to the best model; full tables expose additional uncertainty flags.

**Interpretation:** Inspect unreliable units, adequacy and practical differences before a selection. Tiny differences or approximation-based probabilities are not decisive by themselves.

**Failure modes:** Flattening chain axes; inconsistent outcome units; wrong likelihood normalization; treating aggregate SEs as paired-difference SE; overfitting via repeated search.

**Next action:** Diagnose/repair high k, inspect pointwise differences/covariates, and evaluate a useful candidate or predictive mixture.

**Source:** E07/M-LOO/M-PSIS/M-STACK; D-LOO/D-LOO-K/D-LOO-COMPARE APIs (`translated`).

## brms moment matching and exact refits

**Purpose:** Repair an unstable LOO estimator for a supported fit.

**Inputs:** `fit` saved with `brms::save_pars(all=TRUE)` at fitting; supported backend/compiler environment.

**Assumptions:** Adapter/density support for the actual model; executable model available for exact refits. Some backend/session changes require `recompile=TRUE` as documented; inspect the adapter rather than assuming saved draws alone suffice.

**Code:**

```r
loo_original <- brms::loo(fit, pointwise = TRUE)
loo_mm <- brms::loo(fit, moment_match = TRUE, pointwise = TRUE)
loo::pareto_k_table(loo_mm)
# If still unreliable and the brms reloo adapter supports this model:
loo_exact <- brms::loo(fit, reloo = TRUE, pointwise = TRUE)
```

**Expected output:** Original/repaired diagnostics or exact refit contributions for problematic units; warnings and unresolved k remain reportable. For raw CmdStanR fits use documented loo callbacks or explicit refits; no universal `$loo(moment_match=TRUE)` assumption.

**Interpretation:** Moment matching changes the importance approximation, not the probability model. Exact refits need their own computation and correct group-effect integration.

**Failure modes:** Required parameters not saved; unsupported backend; missing Jacobian/callback information; fitting new-group tasks with observation-level refits.

**Next action:** Validate refits, recheck pointwise estimates/uncertainty; critique the underlying model separately.

**Source:** E09/M-MM; D-BRMS-LOO/D-LOO-MM (`translated`).

## Joint aligned likelihoods

**Purpose:** Score the joint predictive match rather than separate response-level tasks.

**Inputs:** `ll_home`, `ll_away` and aligned match IDs; complete conditional likelihood factors.

**Assumptions:** Conditional independence given parameters; same array shape/sample draws; joint match is omitted.

**Code:**

```r
stopifnot(identical(home_match_ids, away_match_ids),
          identical(dim(ll_home), dim(ll_away)))
ll_match <- ll_home + ll_away
loo_joint <- loo::loo(ll_match, r_eff = loo::relative_eff(exp(ll_match)))
```

**Expected output:** One pointwise score per joint match.

**Interpretation:** Summation and concatenation implement different held-out tasks. New-team/group prediction may require integrated likelihoods or explicit group folds.

**Failure modes:** Incorrect factor independence, home/away swaps, mismatched IDs, leakage through held-out local effects.

**Next action:** Run target-specific diagnostics and folds; compare only the same scientific task.

**Source:** E10 notebook reasoning, M-LOO (`translated`).

## Large-data on-demand subsampling

**Purpose:** Estimate a full-data score without storing all draw-wise likelihoods.

**Inputs:** Dataframe `dat`; posterior draws_matrix with `mu`, `sigma` for this toy Normal likelihood; chosen probability sample size.

**Assumptions:** This likelihood callback is correct only for the stated conditionally iid Normal model; larger/dependent models need their own complete unit callback.

**Code:**

```r
loglik_i <- function(data_i, draws) {
  stats::dnorm(data_i$y, mean = draws[, "mu"], sd = draws[, "sigma"], log = TRUE)
}
sub <- loo::loo_subsample(
  loglik_i, data = dat, draws = posterior::as_draws_matrix(draws),
  observations = 100, loo_approximation = "plpd", estimator = "diff_srs"
)
print(sub)
larger <- stats::update(sub, data = dat, draws = posterior::as_draws_matrix(draws),
                        observations = 300)
# S3 method is update.psis_loo_ss; R observations requests the total size.
# Verify returned sample size; this differs from ArviZ's additional-unit count.
```

**Expected output:** Full-data approximation corrected by sampled-unit LOO with subsampling uncertainty and sampled-unit diagnostics.

**Interpretation:** Grow probability sampling to achieve a practical precision budget; use supported paired subsample comparison, not an ordinary comparison ignoring design error.

**Failure modes:** Nonrandom convenience block, missing covariance for model differences, huge materialization elsewhere, poor PLPD approximation or approximate posterior.

**Next action:** Check sampled high k/influential strata, increase sample via the documented updater, validate stability/error and disclose uninspected units.

**Source:** E08/M-LARGE; D-LOO-SUB (`translated`, partial API parity).

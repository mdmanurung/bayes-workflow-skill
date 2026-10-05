# Template fragment: fit has reliable posterior draws and all parameters saved.
loo_fit <- brms::loo(fit, moment_match = TRUE)
# If flagged k remains, exact refits can be requested (may be expensive):
# loo_fit <- brms::loo(fit, reloo = TRUE)
# Record flagged observation IDs; do not equate repaired PSIS with repaired model fit.

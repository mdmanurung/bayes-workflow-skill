# Template fragment: supply fit (CmdStanMCMC) and consequential variable names.
# Chain identity is retained; do not substitute a merged draws matrix.
draws <- fit$draws(variables = variables, format = "draws_array")
summary_table <- posterior::summarise_draws(
  draws, "mean", "sd", "rhat", "ess_bulk", "ess_tail", "mcse_mean"
)
fit$diagnostic_summary()
fit$cmdstan_diagnose()
q <- posterior::extract_variable_matrix(draws, variable = variables[1])
quantile_mcse <- posterior::mcse_quantile(q, probs = c(0.05, 0.95))
# For a reported probability, diagnose the indicator as an iterations x chains matrix:
probability <- mean(q > threshold)
probability_mcse <- posterior::mcse_mean(1 * (q > threshold))
# A constant indicator requires a rare-event accuracy assessment, not a claim of zero error.

# Template fragment: supply model_file, stan_data, output_dir and seed.
# Choose prior scales/design before fitting; set prior_only=1 for prior-only runs.
mod <- cmdstanr::cmdstan_model(model_file, pedantic = TRUE)
fit <- mod$sample(
  data = stan_data, seed = seed,
  chains = 4, parallel_chains = 4,
  iter_warmup = 1000, iter_sampling = 1000,
  output_dir = output_dir
)
# These counts are a starting fit budget, not a guarantee of convergence/accuracy.
fit$diagnostic_summary()
# Continue with code/diagnostics/posterior_checks.R and targeted predictive checks.

# Template fragment: dat has meaningful numeric y,x and grouping factor group.
# Priors below illustrate a centered/scaled Gaussian outcome and predictor only.
form <- brms::bf(y ~ 0 + Intercept + x + (1 + x | group))
brms::get_prior(form, data = dat, family = stats::gaussian())
priors <- c(
  brms::set_prior("normal(0, 1)", class = "b", coef = "Intercept"),
  brms::set_prior("normal(0, 0.5)", class = "b", coef = "x"),
  brms::set_prior("normal(0, 0.5)", class = "sd"),
  brms::set_prior("lkj(2)", class = "cor"),
  brms::set_prior("normal(0, 1)", class = "sigma")
)
fit_prior <- brms::brm(form, data = dat, family = stats::gaussian(), prior = priors,
                        sample_prior = "only", backend = "cmdstanr",
                        chains = 4, seed = seed)
brms::pp_check(fit_prior, type = "dens_overlay", ndraws = 30)
fit <- brms::brm(form, data = dat, family = stats::gaussian(), prior = priors,
                  backend = "cmdstanr", chains = 4, seed = seed,
                  save_pars = brms::save_pars(all = TRUE))
y_rep <- brms::posterior_predict(fit)
mu <- brms::posterior_epred(fit)
# Validate computation and targeted PPC before interpretation/model comparison.

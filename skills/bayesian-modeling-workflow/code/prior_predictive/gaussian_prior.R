# Original prior-predictive idiom; priors are on alpha/beta/sigma in specified units.
# Positive sigma uses a half-normal; columns of y_rep are observations, rows draws.
prior_predict_gaussian <- function(x, S, alpha_mean, alpha_sd, beta_sd, sigma_scale) {
  stopifnot(is.numeric(x), length(x) > 0L, all(is.finite(x)),
            length(S) == 1L, S >= 1L, S == as.integer(S),
            length(alpha_mean) == 1L, is.finite(alpha_mean),
            length(alpha_sd) == 1L, is.finite(alpha_sd), alpha_sd > 0,
            length(beta_sd) == 1L, is.finite(beta_sd), beta_sd > 0,
            length(sigma_scale) == 1L, is.finite(sigma_scale), sigma_scale > 0)
  alpha <- rnorm(S, alpha_mean, alpha_sd)
  beta <- rnorm(S, 0, beta_sd)
  sigma <- abs(rnorm(S, 0, sigma_scale))
  mu <- outer(beta, x) + alpha
  y_rep <- mu + matrix(rnorm(S * length(x)), S, length(x)) * sigma
  list(alpha = alpha, beta = beta, sigma = sigma, mu = mu, y_rep = y_rep)
}

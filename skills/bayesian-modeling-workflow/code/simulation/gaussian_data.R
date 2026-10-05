# Purpose: fixed-truth data for recovery; x is a finite vector in chosen units.
# Returns truth and observations; original adaptation of declining_exponentials/movies.
simulate_gaussian <- function(x, alpha, beta, sigma) {
  stopifnot(is.numeric(x), length(x) > 0L, all(is.finite(x)),
            length(alpha) == 1L, is.finite(alpha), length(beta) == 1L,
            is.finite(beta), length(sigma) == 1L, is.finite(sigma), sigma > 0)
  mu <- alpha + beta * x
  list(x = x, y = rnorm(length(x), mu, sigma), mu = mu,
       truth = c(alpha = alpha, beta = beta, sigma = sigma))
}

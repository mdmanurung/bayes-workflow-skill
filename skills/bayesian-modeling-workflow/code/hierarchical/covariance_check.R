# Independent covariance test for column-wise correlated non-centered effects.
# tau and L define Sigma = D L L' D. Does not test posterior mixing.
check_ncp_covariance <- function(tau, L, S = 20000L) {
  stopifnot(is.numeric(tau), all(is.finite(tau)), all(tau > 0),
            is.matrix(L), nrow(L) == length(tau), ncol(L) == length(tau),
            all(is.finite(L)), S >= 2L, S == as.integer(S))
  D <- diag(tau, nrow = length(tau))
  z <- matrix(rnorm(length(tau) * S), length(tau), S)
  b <- D %*% L %*% z
  list(expected = D %*% L %*% t(L) %*% D, simulated = cov(t(b)))
}

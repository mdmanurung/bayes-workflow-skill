# Standard-normal expectation quadrature via the Hermite Jacobi matrix.
# Input Q; output nodes and nonnegative weights summing to one.
# Original numerical adaptation for integrated roaches-like held-out likelihoods.
normal_quadrature <- function(Q = 31L) {
  stopifnot(length(Q) == 1L, is.finite(Q), Q >= 1L, Q == as.integer(Q))
  A <- matrix(0, Q, Q)
  if (Q > 1L) {
    k <- seq_len(Q - 1L)
    A[cbind(k, k + 1L)] <- sqrt(k)
    A[cbind(k + 1L, k)] <- sqrt(k)
  }
  eig <- eigen(A, symmetric = TRUE)
  list(nodes = eig$values, weights = eig$vectors[1, ]^2)
}

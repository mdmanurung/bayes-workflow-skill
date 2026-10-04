# Original adaptation of dogs: update history from newly generated responses.
# a,b in (0,1); shock probability a^prior_shocks * b^prior_avoidances.
simulate_history <- function(a, b, T) {
  stopifnot(length(a) == length(b), length(a) > 0L, all(is.finite(a)),
            all(is.finite(b)), all(a > 0 & a < 1), all(b > 0 & b < 1),
            length(T) == 1L, T >= 1L, T == as.integer(T))
  y <- matrix(0L, length(a), T)
  for (j in seq_along(a)) {
    shock <- avoid <- 0L
    for (t in seq_len(T)) {
      p <- exp(shock * log(a[j]) + avoid * log(b[j]))
      y[j, t] <- rbinom(1L, 1L, p)
      shock <- shock + y[j, t]
      avoid <- avoid + 1L - y[j, t]
    }
  }
  y
}

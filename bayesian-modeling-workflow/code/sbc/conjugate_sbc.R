# Executable SBC baseline with exact independent Gaussian posterior draws.
# Original template; does not calibrate Stan, brms or a scientific model.
conjugate_sbc <- function(B = 200L, L = 200L, n = 20L,
                          prior_sd = 1, sigma = 1) {
  stopifnot(length(B) == 1L, B >= 1L, B == as.integer(B),
            length(L) == 1L, L >= 1L, L == as.integer(L),
            length(n) == 1L, n >= 1L, n == as.integer(n),
            length(prior_sd) == 1L, is.finite(prior_sd), prior_sd > 0,
            length(sigma) == 1L, is.finite(sigma), sigma > 0)
  rank <- contraction <- error <- numeric(B)
  for (b in seq_len(B)) {
    truth <- rnorm(1L, 0, prior_sd)
    y <- rnorm(n, truth, sigma)
    variance <- 1 / (1 / prior_sd^2 + n / sigma^2)
    mean_post <- variance * sum(y) / sigma^2
    draws <- rnorm(L, mean_post, sqrt(variance))
    rank[b] <- sum(draws < truth) # continuous independent draws: ties have probability zero
    contraction[b] <- 1 - variance / prior_sd^2
    error[b] <- mean_post - truth
  }
  data.frame(rank = rank, contraction = contraction, error = error)
}

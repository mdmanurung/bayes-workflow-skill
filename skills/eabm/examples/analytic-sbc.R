# Purpose: analytic SBC mechanics and biased positive control.
# Inputs: output directory; Normal prior/known-scale likelihood below.
# Assumptions: iid exact posterior draws, continuous ranks, proper generator.
# Expected output: all ranks, summary and histograms.
# Interpretation: descriptive simulation resolution, not proof or model adequacy.
# Failure modes: dependent/tied ranks, mismatched generator and fitter.
# Next action: replace inference step with actual fitter; keep all fit failures.
# Source: E13/M-SBC-PRIOR/M-SBC; R translation and synthesized analytic example.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1)
dir.create(args[1], recursive = TRUE, showWarnings = FALSE)
set.seed(41)
n <- 12; prior_sd <- 2; noise_sd <- 1; M <- 100; simulations <- 1000
ranks <- matrix(NA_integer_, nrow = simulations, ncol = 3,
                dimnames = list(NULL, c("mu_rank", "loglik_rank", "biased_mu_rank")))
for (i in seq_len(simulations)) {
  truth <- rnorm(1, 0, prior_sd)
  y <- rnorm(n, truth, noise_sd)
  variance <- 1 / (1 / prior_sd^2 + n / noise_sd^2)
  mean <- variance * sum(y) / noise_sd^2
  draws <- rnorm(M, mean, sqrt(variance))
  ll_truth <- sum(dnorm(y, truth, noise_sd, log = TRUE))
  ll_draws <- vapply(draws, function(mu) sum(dnorm(y, mu, noise_sd, log = TRUE)), numeric(1))
  ranks[i, ] <- c(sum(draws < truth), sum(ll_draws < ll_truth), sum(draws + 1 < truth))
}
write.csv(ranks, file.path(args[1], "sbc-ranks.csv"), row.names = FALSE)
mean_se <- sqrt(M * (M + 2) / (12 * simulations))
report <- data.frame(quantity = colnames(ranks), mean_rank = colMeans(ranks),
                     uniform_rank_mean = M / 2, uniform_mean_se = mean_se,
                     simulations = simulations, rank_draws = M, fit_failures = 0)
write.csv(report, file.path(args[1], "sbc-summary.csv"), row.names = FALSE)
png(file.path(args[1], "sbc-ranks.png"), width = 1200, height = 350)
par(mfrow = c(1, 3))
for (j in seq_len(3)) {
  hist(ranks[, j], breaks = seq(-0.5, M + 0.5, length.out = 11),
       main = colnames(ranks)[j], xlab = "Rank", col = "#276b80")
}
dev.off()
grid <- 0:M
reference_cdf <- (grid + 1) / (M + 1)
lower <- qbinom(.025, simulations, reference_cdf) / simulations - reference_cdf
upper <- qbinom(.975, simulations, reference_cdf) / simulations - reference_cdf
png(file.path(args[1], "sbc-ecdf.png"), width = 1200, height = 350)
par(mfrow = c(1, 3), oma = c(0, 0, 2, 0))
for (j in seq_len(3)) {
  empirical <- vapply(grid, function(r) mean(ranks[, j] <= r), numeric(1))
  limits <- range(c(lower, upper, empirical - reference_cdf))
  plot(grid, empirical-reference_cdf, type="n", ylim=limits, main=colnames(ranks)[j],
       xlab="Rank", ylab="ECDF - discrete uniform")
  polygon(c(grid,rev(grid)),c(lower,rev(upper)),col="#acc9d1",border=NA)
  lines(grid,empirical-reference_cdf,type="s",col="#276b80")
  abline(h=0)
}
mtext("Pointwise 95% binomial bands; not simultaneous", outer=TRUE)
dev.off()
print(report)

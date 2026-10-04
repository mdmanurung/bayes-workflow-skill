# Usage: Rscript tests/smoke.R /absolute/path/to/skill
args <- commandArgs(trailingOnly = TRUE)
root <- if (length(args)) normalizePath(args[1], mustWork = TRUE) else normalizePath(".")
files <- list.files(file.path(root, "code"), pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
for (f in files) parse(f)
cat("R syntax:", length(files), "pattern files parsed\n")
# Parse fenced R examples as well; executing package fragments needs their stated inputs.
markdown <- list.files(file.path(root, "examples"), pattern = "\\.md$", full.names = TRUE)
chunks <- list()
for (f in markdown) {
  lines <- readLines(f)
  starts <- which(lines == "```r")
  for (i in starts) {
    end <- which(seq_along(lines) > i & lines == "```")[1]
    chunk <- paste(lines[seq.int(i + 1L, end - 1L)], collapse = "\n")
    parse(text = chunk)
    chunks[[length(chunks) + 1L]] <- chunk
  }
}
cat("R syntax:", length(chunks), "documented example blocks parsed\n")
generator_code <- Filter(function(s) grepl("^sbc_gaussian_generator <- function", s), chunks)
stopifnot(length(generator_code) == 1L)
eval(parse(text = generator_code[[1L]]))
set.seed(20261004)
fixture <- sbc_gaussian_generator()
g <- fixture$generated; truth <- fixture$variables
stopifnot(identical(dim(g$X), c(40L, 2L)), qr(cbind(1, g$X))$rank == 3L,
          length(truth$beta) == 2L, truth$sigma > 0, g$prior_only == 0L,
          abs(mean(g$X[, 2])) < 1e-12)
mu <- as.numeric(truth$alpha + g$X %*% truth$beta)
manual_log_lik <- -log(truth$sigma) - 0.5 * log(2 * pi) -
                  0.5 * ((g$y - mu) / truth$sigma)^2
stopifnot(max(abs(truth$log_lik - manual_log_lik)) < 1e-12)
cat("Independent SBC generator shape, design and data-dependent truth: passed\n")
for (f in c("simulation/gaussian_data.R", "prior_predictive/gaussian_prior.R",
            "simulation/sequential_binary.R", "posterior_predictive/targeted_checks.R",
            "sbc/conjugate_sbc.R", "hierarchical/covariance_check.R", "loo/normal_quadrature.R"))
  source(file.path(root, "code", f))
set.seed(20261004)
sim <- simulate_gaussian(seq(-1, 1, length.out = 50000), 2, -0.4, 0.6)
stopifnot(abs(mean(sim$y - sim$mu)) < 0.01,
          abs(sd(sim$y - sim$mu) - 0.6) < 0.01)
prior <- prior_predict_gaussian(c(-1, 0, 1), 50000, 2, 0.2, 0.5, 0.3)
stopifnot(identical(dim(prior$y_rep), c(50000L, 3L)),
          max(abs(colMeans(prior$y_rep) - 2)) < 0.02,
          max(abs(apply(prior$y_rep, 2, var) - c(0.38, 0.13, 0.38))) < 0.02)
cat("Gaussian truth and prior predictive moments: passed\n")
L <- matrix(c(1, 0.6, 0, 0.8), 2, 2)
covariance <- check_ncp_covariance(c(0.2, 1.5), L, 100000)
stopifnot(max(abs(covariance$simulated - covariance$expected)) < 0.04)
# Wrong row orientation has a different covariance; distinguish it from MC noise.
D <- diag(c(0.2, 1.5)); wrong <- t(D %*% L) %*% (D %*% L)
stopifnot(max(abs(wrong - covariance$expected)) > 0.1)
cat("Correlated effect covariance and orientation discrimination: passed\n")
y <- simulate_history(rep(0.2, 30000), rep(0.6, 30000), 3)
stopifnot(all(y[,1] == 1L), abs(mean(y[,2]) - 0.2) < 0.015,
          abs(mean(y[,3]) - 0.104) < 0.015,
          all(simulate_history(0.2, 0.6, 1) == 1L))
cat("Recursive binary history and one-trial edge case: passed\n")
chk <- check_statistic(c(0,0,1), matrix(c(0,0,0,1,1,1), 2, byrow=TRUE),
                       function(z) mean(z == 0))
stopifnot(chk$observed == 2/3, identical(as.numeric(chk$replicated), c(1,0)))
cat("Targeted predictive statistic: passed\n")
sbc <- conjugate_sbc(B=4000L, L=100L, n=20L)
stopifnot(abs(mean(sbc$rank) - 50) < 2.5,
          all(abs(sbc$contraction - 20/21) < 1e-12),
          abs(mean(sbc$error^2) - 1/21) < 0.006)
breaks <- seq(-0.5, 100.5, length.out=11)
observed <- tabulate(as.integer(cut(sbc$rank, breaks)), nbins=10)
expected <- tabulate(as.integer(cut(0:100, breaks)), nbins=10)/101 * nrow(sbc)
chi <- sum((observed-expected)^2/expected)
stopifnot(chi < 50)
cat("Exact-draw SBC rank, learning and analytic recovery checks: passed; chi-square", chi, "\n")
# Independent probability identity behind discrete administrative censoring.
for (p in c(0.001,0.2,0.9)) for (deadline in c(0L,1L,20L)) {
  event_mass <- if (deadline) sum(p*(1-p)^(0:(deadline-1L))) else 0
  survival <- (1-p)^deadline
  stopifnot(abs(event_mass + survival - 1) < 1e-12)
  # R's independent binomial pmf agrees with geometric survival/event construction.
  stopifnot(abs(exp(dbinom(0,deadline,p,log=TRUE)) - survival) < 1e-12)
}
cat("Censoring probability identities: passed (not a Stan runtime test)\n")
q <- normal_quadrature(81L)
stopifnot(abs(sum(q$weights)-1) < 1e-12,
          abs(sum(q$weights*q$nodes)) < 1e-12,
          abs(sum(q$weights*q$nodes^2)-1) < 1e-12,
          abs(sum(q$weights*exp(0.2*q$nodes))-exp(0.02)) < 1e-12)
for (count in c(0L,3L,12L)) for (s in c(0.05,0.5,1)) {
  est <- sum(q$weights*dpois(count,exp(0.7+s*q$nodes)))
  ref <- integrate(function(z) dpois(count,exp(0.7+s*z))*dnorm(z), -10, 10,
                   rel.tol=1e-9)$value
  stopifnot(abs(est-ref) < 1e-6)
}
stopifnot(identical(normal_quadrature(1L)$nodes, 0),
          identical(normal_quadrature(1L)$weights, 1))
cat("Normal quadrature moments, one-node case and independent held-out integrals: passed\n")
cat("All pure-R smoke checks passed. External package fragments and MCMC need integration checks.\n")

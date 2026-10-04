# Simulation and calibration patterns

Read [simulation tasks](../references/simulation.md) before choosing code. Use `set.seed` at experiment entry and record seed/design/truth. Parallel experiments require independent reproducible RNG streams.

| Pattern | Purpose / assumptions | Inputs → output | Interpretation / failure mode | Inspiration |
|---|---|---|---|---|
| [gaussian_data.R](../code/simulation/gaussian_data.R) | Fixed-truth additive Gaussian recovery | finite x, scalar alpha,beta,positive sigma → truth,mu,y | One fit does not establish coverage; x scale determines information | declining_exponentials/declining_exponentials.R; movies/movies.R |
| [gaussian_prior.R](../code/prior_predictive/gaussian_prior.R) | Direct joint prior/observable simulation | x,S,unit-specific coefficient and half-normal scale priors → S×N mu,y_rep and parameter draws | It tests exactly these priors, not brms defaults or another latent structure | misc/chapter_05/section_05_09/prior_predictive_simulations.R |
| [sequential_binary.R](../code/simulation/sequential_binary.R) | Full history-dependent binary replication | vectors a,b in(0,1),T≥1 → group×trial responses | First shock is deterministic; conditioning on observed history would be another check | dogs/dogs_2.stan; dogs/dogs_5.stan |
| [conjugate_sbc.R](../code/sbc/conjugate_sbc.R) | Exact-draw calibration baseline | B,L,n,prior_sd,sigma → ranks,contraction,estimation errors | Continuous scalar baseline; not a Stan/brms backend or proof of a scientific model | sbc/sbc.R methodology; original analytic example |
| [covariance_check.R](../code/hierarchical/covariance_check.R) | Verify NCP covariance orientation | tau,L,S → expected and simulated covariance | Confirms transformation algebra, not MCMC adequacy | dogs/dogs_5.stan; prior/latent checks |

## Prior simulation

```r
source(file.path(skill_dir, "code/prior_predictive/gaussian_prior.R"))
set.seed(104)
prior <- prior_predict_gaussian(seq(-1, 1, length.out=40), S=1000,
  alpha_mean=0, alpha_sd=1, beta_sd=0.5, sigma_scale=1)
# Illustrative standardized units only; inspect original scientific scale in an actual analysis.
apply(prior$y_rep, 1, range)
```

## Extend SBC to a fitted model

Use the supported SBC package backend for the actual fitted model. The official [sbc.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/sbc/sbc.R) develops generators, datasets, backends and rank checks in stages. This original adaptation pairs an independent R generator with the bundled Gaussian Stan template. Priors are in illustrative standardized units, design is fixed, and `log_lik` truth tests a data-dependent function as well as parameters.

```r
sbc_gaussian_generator <- function(N = 40L) {
  x <- seq(-1, 1, length.out = N)
  X <- cbind(x, x^2 - mean(x^2)) # two slopes; no intercept column
  alpha <- rnorm(1, 0, 1)
  beta <- rnorm(2, 0, 1)
  sigma <- abs(rnorm(1, 0, 1))
  mu <- alpha + X[, 1] * beta[1] + X[, 2] * beta[2]
  y <- rnorm(N, mu, sigma)
  list(variables = list(alpha = alpha, beta = beta, sigma = sigma,
                        log_lik = dnorm(y, mu, sigma, log = TRUE)),
       generated = list(N = N, P = 2L, X = X, y = y,
                        alpha_prior_mean = 0, alpha_prior_sd = 1,
                        beta_prior_sd = c(1, 1), sigma_prior_scale = 1,
                        prior_only = 0L))
}
```

With SBC, cmdstanr and CmdStan installed, and `skill_dir`/`project_dir` defined:

```r
set.seed(20261004)
generator <- SBC::SBC_generator_function(sbc_gaussian_generator)
datasets <- SBC::generate_datasets(generator, n_sims = 20L) # exploratory budget
mod <- cmdstanr::cmdstan_model(file.path(skill_dir,
  "code/stan_patterns/gaussian_regression.stan"))
backend <- SBC::SBC_backend_cmdstan_sample(mod,
  chains = 4, iter_warmup = 1000, iter_sampling = 1000)
results <- SBC::compute_SBC(datasets, backend, keep_fits = TRUE,
  cache_mode = "results", cache_location = file.path(project_dir, "sbc-results.rds"))
results$default_diagnostics
results$backend_diagnostics
SBC::plot_rank_hist(results)
```

Inputs are a matching proper generator, compiled model and sampling plan; output contains ranks, learning summaries, fit diagnostics and messages. Twenty simulations are an exploratory example, not a calibration acceptance threshold. Inspect failures/messages and contraction, and rank reference uncertainty; increase the budget for the intended precision. Do not supply `data` or `parallel_chains` to this backend. Assess rank thinning/dependence using the supported API, without aggressively thinning the fitting output. Keep early fits for diagnosis; change cache identity when generators, priors, data-dependent initialization or inference settings change. Current [generator](https://hyunjimoon.github.io/SBC/reference/SBC_generator_function.html), [backend](https://hyunjimoon.github.io/SBC/reference/SBC_backend_cmdstan_sample.html) and [compute_SBC](https://hyunjimoon.github.io/SBC/reference/compute_SBC.html) APIs were checked; the full package experiment was not executed here.

Log every fit failure/diagnostic problem and handle posterior dependence/ties. Add a data-dependent quantity and contraction check for unused-parameter risks. Use predeclared data-only restrictions only as a clearly changed calibration domain. The conjugate function demonstrates rank mechanics and analytical recovery, but does not test the production inference engine; use that engine in actual implementation SBC.

[normal_quadrature.R](../code/loo/normal_quadrature.R) returns standard-normal expectation nodes/weights for the integrated local-effect template. Input is positive integer node count Q; output weights sum to one. It is a numerical implementation choice, not an author-prescribed node count. Verify moments and integrals as Q increases; hard tail/narrow likelihood integrands can be poorly approximated despite valid normal moments. The source uses adaptive 1D quadrature. Conditional/integrated interpretation is canonical in [LOO](../references/model-comparison-loo.md).

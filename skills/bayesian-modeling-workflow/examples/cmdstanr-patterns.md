# cmdstanr, posterior, bayesplot and loo patterns

All patterns are original adaptations; sources are pinned in [source map](../references/source-map.md). R files marked **fragment** require the named objects and are intended to be read/adapted, not sourced without inputs. Pure-function simulation files can be sourced directly. Syntax/compiler checks are distinct from fitting; see [validation](../reports/validation.md).

| Pattern | Purpose / assumptions | Inputs → output | Interpretation / common failure | Source |
|---|---|---|---|---|
| [cmdstanr_fit.R](../code/fitting/cmdstanr_fit.R) | Compile pedantically and fit a specified posterior or prior-only generator | model_file, validated stan_data, seed, output_dir → CmdStanMCMC | Starting budget is provisional; positive prior scales required; missing-prior pedantic warnings can arise from hyperparameters supplied as data and need manual verification | bioassay/bioassay.R; digits/digits.R |
| [posterior_checks.R](../code/diagnostics/posterior_checks.R) | Chain-aware convergence and QOI precision | fit, variables, threshold → summary/quantile/probability MCSE | Preserve iteration × chain structure; constant indicators do not establish rare-event accuracy; no metric establishes model adequacy | digits/digits.R; problems/problems.R; posterior official API |
| [diagnostic_plots.R](../code/visualization/diagnostic_plots.R) | Diagnose geometry/energy | fit, selected variables → plots | Choose variables implicated by symptom; divergence-free plots do not establish exploration | problems/problems.R; bayesplot official API |
| [psis.R](../code/loo/psis.R) | Relative-efficiency aware PSIS | reliable posterior fit with unit log_lik → loo object/flags | Conditional latent log_lik may target the wrong held-out question; k repair and substantive model repair differ | roaches/roaches.R; loo official API |
| [targeted_checks.R](../code/posterior_predictive/targeted_checks.R) | Compare scientific statistic in observed/replicated data | y, S×N y_rep, stat → observed value/replication distribution | Choose statistic for an assumption; broad density check can miss conditional misfit | dogs/dogs.R; roaches/roaches.R |

## Instantiate a small known-data Gaussian fit

```r
# skill_dir is the installed skill directory; project_dir is the analysis output location.
source(file.path(skill_dir, "code/simulation/gaussian_data.R"))
set.seed(20261004)
sim <- simulate_gaussian(x = seq(-1, 1, length.out = 80),
                         alpha = 0.5, beta = 0.7, sigma = 0.4)
stan_data <- list(N = length(sim$y), P = 1L,
  X = matrix(sim$x, ncol = 1), y = sim$y,
  alpha_prior_mean = 0, alpha_prior_sd = 1,
  beta_prior_sd = 1, sigma_prior_scale = 1, prior_only = 0L)
model_file <- file.path(skill_dir, "code/stan_patterns/gaussian_regression.stan")
output_dir <- file.path(project_dir, "known-data-fit")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
seed <- 20261004
source(file.path(skill_dir, "code/fitting/cmdstanr_fit.R"))
variables <- c("alpha", "beta", "sigma")
threshold <- 0
source(file.path(skill_dir, "code/diagnostics/posterior_checks.R"))
y_rep <- posterior::as_draws_matrix(fit$draws("y_rep"))
bayesplot::ppc_dens_overlay(sim$y, y_rep[seq_len(30), , drop = FALSE])
```

These unit-scale priors/data are an executable illustrative test, not scientific defaults. Inspect coverage over repeated datasets rather than demand the truth equal the posterior mean in one run. Set `prior_only=1L` to exclude observed-response likelihood; do not apply posterior LOO to that prior-only fit. The GQ log_lik remains computable but is not a posterior predictive validation object.

Use multiple chains for final HMC. If initialization is difficult, inspect support/scale and consider supported Pathfinder initialization only after its scientific/numerical causes are understood; do not substitute an approximation for final exploration unnoticed.

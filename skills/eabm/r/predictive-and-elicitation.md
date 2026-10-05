# R prior/posterior prediction and elicitation

Read [predictive checking](../guides/predictive-checking.md) and [prior elicitation](../guides/prior-elicitation.md). EABM reasoning is shared; all R implementations are **translated**.

## Proper prior prediction and targeted PPC in brms

**Purpose:** Validate observable prior scales and generate noisy outcome replications for model criticism.

**Inputs:** Dataframe `dat` with response `y` and scientifically scaled predictor `x`; proper priors appropriate to these units.

**Assumptions:** Toy Normal priors below are illustrative for standardized units; every parameter has a proper prior for `sample_prior="only"`. CmdStan/brms backend installed. Prior and posterior use the same probability model.

**Code:**

```r
library(brms)
priors <- c(prior(normal(0, 1), class = b),
            prior(normal(0, 2), class = Intercept),
            prior(exponential(1), class = sigma))
prior_fit <- brm(y ~ x, data = dat, family = gaussian(), prior = priors,
                 sample_prior = "only", chains = 4, seed = 11)
yprior <- posterior_predict(prior_fit, ndraws = 300)
bayesplot::ppc_stat(dat$y, yprior, stat = "sd")
# After validating prior predictions:
fit <- brm(y ~ x, data = dat, family = gaussian(), prior = priors,
           chains = 4, seed = 12, save_pars = save_pars(all = TRUE))
yrep <- posterior_predict(fit, ndraws = 300)
bayesplot::ppc_stat(dat$y, yrep, stat = "sd")
bayesplot::ppc_stat(dat$y, yrep,
                   stat = function(x) stats::quantile(x, 0.95))
```

**Expected output:** draw × observation predictive matrices and distributions of replicated statistics against observed values. Inspect the prior posterior-computation warnings too when prior sampling is difficult.

**Interpretation:** `posterior_epred` gives expected responses, whereas `posterior_predict` includes outcome noise. For PPC dispersion/zeros/tails, use replications with the actual observation process.

**Failure modes:** Improper flat brms defaults; mismatched standardized units; prior fit treated as likelihood-conditioned; location checks only; censored durations replicated incorrectly.

**Next action:** Revise scientifically motivated prior/model features; validate computation before interpreting targeted posterior checks.

**Source:** E05 reasoning; D-BRMS/D-BAYESPLOT-PPC APIs. brms compilation is documentation-verified rather than runtime-executed in this skill audit.

## Groups and repeated measurements

**Purpose:** Expose within/between-group failures and distinguish prediction populations.

**Inputs:** `yrep`, observed `dat$y`, group/time labels; hierarchical `fit` when generating new groups.

**Assumptions:** Observations ordered and group labels aligned; lag quantities computed within series; new-group random effects sampled from the population distribution.

**Code:**

```r
bayesplot::ppc_stat_grouped(dat$y, yrep, group = dat$group, stat = "sd")
bayesplot::ppc_stat(dat$y, yrep, stat = function(x) mean(x == 0))
# For a brms model with group effects, `new_dat` includes genuinely new group IDs:
new_group_rep <- brms::posterior_predict(
  fit, newdata = new_dat, allow_new_levels = TRUE,
  sample_new_levels = "gaussian"
)
# A single ordered series; repeat separately for each group:
lag_cov <- function(x) mean((x[-1] - mean(x)) * (x[-length(x)] - mean(x)))
bayesplot::ppc_stat(dat$y, yrep, stat = lag_cov)
```

**Expected output:** Group-specific statistic plots, fresh-group predictions and lag covariance check.

**Interpretation:** Fresh groups differ from `re_formula=NA` population means: excluding a random effect does not integrate its uncertainty. Conditional existing-group PPCs need additional between-group/new-group checks when generalization is the goal.

**Failure modes:** Cross-group/time lag; tiny groups; ambiguous new-group sampling settings; group labels leaked from held-out fits.

**Next action:** Localize failure to group/dependence/observation mechanism; generate/score predictions for the actual target.

**Source:** E05 plus target reasoning; D-BRMS official new-level options (`translated`); lag feature `synthesized`.

## Quantile constraints without forced PreliZ parity

**Purpose:** Implement the same elicitation reasoning directly on an R distribution scale.

**Inputs:** Plausible lower/upper quantiles and their probabilities from domain/external information.

**Assumptions:** Normal candidate is appropriate; symmetric quantile constraint coherent; toy outcome units.

**Code:**

```r
lo <- -1; hi <- 1
probs <- c(0.25, 0.75)
sigma <- (hi - lo) / diff(stats::qnorm(probs))
mu <- lo - sigma * stats::qnorm(probs[1])
stopifnot(isTRUE(all.equal(stats::qnorm(probs, mu, sigma), c(lo, hi))))
prior_draws <- stats::rnorm(1000, mu, sigma)
```

For skewed/positive distributions, solve the requested CDF/quantile constraints on transformed parameters using `uniroot`/`optim`, and verify residuals/support; do not assume a symmetric Normal solution. SHELF provides a verified structured expert-elicitation workflow. It is a **partial** counterpart to PreliZ; there is no promised generic R implementation of every interactive/maximum-entropy feature.

**Expected output:** Candidate parameters and exact quantile validation for this example.

**Interpretation:** Candidate parameter plausibility must still imply plausible observables jointly with the model.

**Failure modes:** Treating interval mass as support, fitting incompatible constraints, confusing variance with SD or Gamma rate with scale.

**Next action:** Prior-predictive simulation, iteration and sensitivity after fitting.

**Source:** E12 reasoning; base R distribution API and D-SHELF; analytic translation `translated`.

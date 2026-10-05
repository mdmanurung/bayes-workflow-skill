# brms patterns

Basis: sleep study, nabiximols, roaches and variable selection, plus official brms API. Adapt family/link/priors and target before running. No examples prescribe a prior independent of units.

| Pattern | Purpose and assumptions | Inputs → output | Interpretation / failures |
|---|---|---|---|
| [prior_and_posterior.R](../code/brms_patterns/prior_and_posterior.R) | Inspect class/coef priors, simulate a prior-only model, then fit a correlated hierarchy | centered/scaled Gaussian dat(y,x,group), seed → prior and posterior brmsfit, y_rep, mu | `0+Intercept` is an explicit baseline convention; normal SD priors are truncated positive; these toy scales do not suit raw milliseconds/log outcomes automatically |
| [loo_repair.R](../code/brms_patterns/loo_repair.R) | Supported PSIS moment matching and optional exact refits | reliable brmsfit with save_pars(all=TRUE) → repaired loo | Refit capability/original data and saved parameters needed; high k can still identify misspecification |

## Targeted predictive checks

```r
brms::pp_check(fit, type = "stat", stat = "sd")
brms::pp_check(fit, type = "stat", stat = function(y) mean(y == 0))
# For conditional checks, draw y_rep and use the same group/predictor subsets in y and replications.
```

The zero statistic is relevant for counts, not every continuous outcome. Inspect grouped/conditional quantities using an explicit design and `posterior_predict`; do not automatically request dozens of generic plots.

## Contrasts and population interpretation

`posterior_epred` returns draw-level expected responses; `posterior_predict` adds observation variability. Draw contrasts across conditions using aligned draws and the same target design. `re_formula=NA` sets random effects to zero. With nonlinear links this is a conditional typical-group curve, not the population-integrated mean.

For a new-group mean, one possible Monte Carlo integration pattern is:

```r
# pop_dat has many new group IDs and the target predictor composition.
# Reuse IDs for paired counterfactual conditions and make one combined epred call.
mu_new <- brms::posterior_epred(fit, newdata = pop_dat,
  re_formula = NULL, allow_new_levels = TRUE, sample_new_levels = "gaussian")
stopifnot(length(weights) == ncol(mu_new), all(weights >= 0), sum(weights) > 0)
mu_population <- drop(mu_new %*% (weights / sum(weights)))
```

This draws group effects from each posterior population distribution; many new groups approximate integration, and nested Monte Carlo error must be assessed. A single new group is a new-group prediction, not an accurate conditional population mean. Weighting alone does not justify causal transport; state target/design assumptions. Source basis: coronavirus poststratification and nabiximols contrast construction; zero-effect versus integration distinction is an explicitly labeled generalization supported by the official epred API.

## Regularization

For many scaled predictors, inspect total prior signal before fitting. brms supports an R2D2 prior, e.g. `set_prior("R2D2(mean_R2 = 0.333, prec_R2 = 3, cons_D2 = 0.5)", class="b")` as an illustrative total-signal specification. The source contrasts it with scaled normal and regularized horseshoe priors. Verify current generated code, residual-scale coupling and priors with `get_prior`/`make_stancode`; use the corrected half-Student-t residual prior interpretation. Do not treat default numbers as prior knowledge or select causal covariates using the projection ranking.

Before selecting variables, validate the reference model, use a supported validated selection path such as `projpred::cv_varsel`, and inspect correlated-variable/search instability. Small demonstration validation budgets are not final guarantees. See [source map P04/L07](../references/source-map.md).

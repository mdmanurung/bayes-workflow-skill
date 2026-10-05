# Stan implementation patterns

Original, concise templates inspired by official model sequences. Consult the source link and adapt the scientific meaning before use. All supplied prior scales/shapes must be strictly positive and independently justified; compiler bounds allowing zero are not permission to use invalid zero scales.

| Pattern | Purpose / assumptions | Inputs → outputs | Interpretation / common failure | Exact inspiration |
|---|---|---|---|---|
| [gaussian_regression.stan](../code/stan_patterns/gaussian_regression.stan) | Additive Gaussian independent observations conditional on predictors | N,P,X without intercept,y, unit-specific priors,prior_only → alpha,beta,sigma,mu,y_rep,log_lik | Appropriate only after residual/dependence checks; log_lik is full density, not pointwise likelihood without constants | digits/linear.stan |
| [hierarchical_ncp.stan](../code/stan_patterns/hierarchical_ncp.stan) | Correlated varying intercept/slope with column-wise standardized effects | group,x,y, prior scales and LKJ shape → effects, covariance, conditional y_rep/log_lik | Weak groups may benefit; raw x reference defines covariance; row-wise latent likelihood is not new-group CV | movies/ratings_3.stan; dogs/dogs_5.stan; sleep_study/sleep_study.R |
| [hierarchical_cp.stan](../code/stan_patterns/hierarchical_cp.stan) | Same statistical hierarchy in centered coordinates | Same inputs → same scientific quantities | Compare matching priors; strong groups may mix better, small tau can create funnel | park_rule/park_3.stan; park_rule/park_4.stan; problems hierarchy variants |
| [poisson_mixture.stan](../code/stan_patterns/poisson_mixture.stan) | Independent allocations with logistic weights and ordered component rates | count y, design X, common log-rate prior, beta prior → component rates,y_rep,pointwise log_lik | Sorting exchangeable prior rates matches ordered prior; near-overlap remains weak; whole-dataset vectorization would change model | sbc/models/mixture_fixed_ordered.stan; sbc/models/combined_first.stan |
| [geometric_censoring.stan](../code/stan_patterns/geometric_censoring.stan) | Discrete daily constant hazard with known administrative censoring | group,time,event,censor_day,beta prior → hazards,observed replicated records,log_lik | Continuous time, varying hazard or informative censoring require another model; event at deadline allowed | cat_adoptions/adoptions_censored.stan |

Some table filenames identify model families; the [source map](../references/source-map.md) and [inventory](../research/source-inventory.tsv) provide the actual pinned paths. The code is newly written rather than copied verbatim.

## Pointwise mixtures

```stan
for (n in 1:N)
  target += log_mix(theta[n], logp_component1[n], logp_component2[n]);
```

This mixes each observation. Moving summed log likelihoods inside one `log_mix` mixes an entire dataset and is a different model. Validate against enumeration for a tiny dataset.

## Stable discrete observation probabilities

For a rounded continuous latent outcome in a bin [a,b], compute its mass as a stable CDF/CCDF difference. Choose the appropriate tail formulation to avoid subtraction of nearly equal numbers; validate against integration. Do not replace this with density at the midpoint without an explicit approximation assessment. World Cup motivates this pattern; it is especially fragile at singular transformed densities.

## Hierarchical covariance

For `z` shaped K×J, `b = diag_pre_multiply(tau,L)*z` implies covariance D L L' D per group. Row-wise J×K effects require the transpose orientation. Use the independent [covariance check](../code/hierarchical/covariance_check.R). Centered/non-centered equivalence assumes the same priors/constraints; sum-to-zero and hard identification changes require a new prior interpretation.

## Latent marginalization and generated quantities

Use log-space forward/sum-exp calculations for HMMs and reset each track. Missing emission components contribute no observed likelihood, rather than using numeric sentinels as measurements. Test singleton/boundary paths. For held-out continuous latent effects integrate their population conditional distribution; generated-quantity integration can provide CV scores without changing the posterior fit (roaches).

`prior_only` permits prior simulation with the same observation generator. Generated log_lik from such a fit must not be mistaken for posterior LOO. Each y_rep corresponds to one posterior/prior dataset; sequence and censoring templates preserve their observation process.

Constrained centered effects: for `sum_to_zero_vector[J] d` and inferred sigma, a normalized subspace Gaussian requires the dimension adjustment described in [hierarchical models](../references/hierarchical-models.md). Hard constraints also change the intercept/prior unless removed mean uncertainty is retained/integrated. Treat these as statistical and software decisions, not automatic speed fixes.

## Integrated local effects for new observations

[poisson_lognormal_integrated.stan](../code/stan_patterns/poisson_lognormal_integrated.stan) fits independent observation-specific Gaussian log-rate effects and computes both conditional and integrated log likelihood. Inputs: nonnegative counts, X without intercept, log positive exposure, unit-specific proper priors, standard-normal quadrature nodes/weights and prior_only. Outputs: `log_lik` integrated over a fresh local effect, `log_lik_cond`, conditional replications and new-unit replications. Source: [roaches/poisson_vi_integrate.stan](../references/source-map.md), an original adaptation using fixed quadrature instead of source adaptive integration.

Prepare nodes/weights with [normal_quadrature.R](../code/loo/normal_quadrature.R). Integrate probabilities using log-sum-exp; do not average log likelihoods or use fitted local effects as fresh effects. Verify quadrature resolution against independent integration over difficult posterior values; high sigma/counts may need more nodes or adaptive integration. Validate exposure units and prior predictions to avoid rate/RNG overflow. These new-unit replications must be combined with reliable LOO weighting for LOO predictive checks; by themselves they use full-data global posterior draws.

Correct conditional likelihood can support exact augmented-space LOO in theory; integrated PSIS often has much better importance-weight behavior. Generated-quantity integration preserves the fitted posterior. Whole-group held-out prediction requires a joint shared-effect integral rather than row-wise independent local integrals.

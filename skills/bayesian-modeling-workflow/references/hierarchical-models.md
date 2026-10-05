# Develop and diagnose hierarchical models

Basis: H01–H05, P03 in [source map](source-map.md).

## Establish exchangeability and prediction target

Ask what group labels represent, which groups can borrow information, which predictors explain systematic group differences, and whether the target is existing groups, new groups or a different cohort population. Exchangeability conditional on predictors is a scientific assumption, not a property conferred by syntax. Repeated observations within a subject do not create new independent subjects.

**Complete pooling** assumes no residual group variation. **No pooling** estimates groups separately and can be unstable in sparse groups. **Partial pooling** shares a population distribution while allowing variation; its shrinkage reflects group information and estimated heterogeneity. These are diagnostic comparators where useful, not three mandatory fitted models for every dataset.

## Build upward for a reason

1. Plot/count groups and within-group predictor variation. Start with the population mean structure and essential dependence.
2. Add varying intercepts if group baselines matter; inspect within- versus between-group variation and shrinkage.
3. Add varying slopes if effect heterogeneity is scientifically relevant and the design supplies within-group contrast. A predictor constant within a group cannot independently identify its within-group slope from that group's data.
4. Add correlated effects when their joint structure matters and groups provide information; choose meaningful centering so intercept/slope covariance has an interpretable reference.
5. Add group-level predictors/cohort structure or poststratification only when needed for the target. Match population cell ordering/weights and propagate uncertain calibration if relevant.

For each new component, simulate plausible groups from hyperpriors, not just the conditional fitted means. Examine SD/correlation priors, sparse-group behavior, and group-specific trajectories. A group distribution that borrows across incompatible populations may hide meaningful differences rather than stabilize valid inference.

## Decision rules

**IF sparse groups are extreme/uncertain:** inspect sample sizes, exposure, predictor support, measurement differences and posterior shrinkage. Partial pooling helps when groups legitimately share a distribution. Compare predictions and sensitivity; do not claim shrinkage identifies each group's true effect.

**IF hierarchical variance is near zero:** consider real homogeneity, weak data, a too-concentrated hyperprior, variance/mean confounding and funnel geometry. Inspect prior versus posterior SD, recovery at several heterogeneity values, group PPC and CP/NCP diagnostics. A continuous SD prior near zero does not estimate a probability of exact equality; do not automatically remove group structure or increase adapt_delta. Simplify only when the task and sensitivity justify it.

**IF correlations are weakly informed:** inspect group count, each group's intercept/slope information and predictor centering. Posterior near LKJ prior may be expected. Consider an independent-effect model or a defensible regularizing correlation prior; compare meaningful group contrasts and sensitivity. Correlation bounds do not make it well identified.

**IF a hierarchy samples badly:** inspect SD/latent/raw coordinates and prior implications. Non-centering often helps weakly informed groups because it separates standardized latent draws from population scales. Centering can help strongly informed effects, as park rule and birthdays demonstrate. Evaluate equivalent versions with matching priors and data using exploration, QOI accuracy and ESS/time; some mixed-information settings merit a partial/mixed parameterization, which is an additional generalization requiring testing.

## Centered versus non-centered

Centered: `b_j ~ normal(mu, tau)`.
Non-centered: `z_j ~ normal(0,1); b_j = mu + tau*z_j`.
For correlated column-wise effects, use `diag_pre_multiply(tau,L)*z`; confirm the implied covariance algebraically and by simulation. Avoid orientation mistakes when converting to row-wise matrices. An exact coordinate change preserves the model; removing/strengthening priors or imposing finite-group sum-to-zero constraints may change it.

Location/scale constraints must match the intercept's meaning. A sum-to-zero vector describes deviations about a finite-group average; a superpopulation mean has a different prior interpretation. Document any marginal-SD scaling correction and test it, rather than using constraints as an unexplained speed trick.

## Interpretation and validation

Report population hyperparameters, conditional group effects and new-group uncertainty separately. Under nonlinear links, zero group deviations are not a population marginal mean. For a population estimand draw/integrate new effects and weight subjects/cohorts/cells appropriately. Conditional subject-row LOO estimates another measurement in a known subject; new-subject prediction may require leave-subject-out and integrating that subject's effects. Neither score establishes causal transport.

## Normalize constrained scale priors

For a centered `sum_to_zero_vector[J] d`, J normal density factors contain J scale normalizers while the constrained vector has J−1 free dimensions. If sigma is inferred and the intended prior is the normalized Gaussian distribution on that subspace, use `d ~ normal(0,sigma); target += log(sigma);`. A scale correction sqrt(J/(J−1)) instead defines sigma as the constrained elements' marginal SD; state which convention is intended. No correction for an inferred scale is needed when the standardized constrained vector's prior scale is fixed and scaling occurs deterministically in an NCP.

This is supplemental current [Stan constraint-transform guidance](https://mc-stan.org/docs/reference-manual/transforms.html#sum-to-zero-transforms), not a claimed official book erratum. The inspected centered park-rule files lack that scale-normalization term; do not copy them as a normalized conditional Gaussian prior without resolving the joint intent. This caveat is also in the unresolved-source ledger.

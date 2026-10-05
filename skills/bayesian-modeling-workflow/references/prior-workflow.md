# Specify, interrogate and revisit priors

Basis: P01–P07 in [source map](source-map.md). Numerical examples illustrate units and parameterization, not recommended default values for other datasets.

## Procedure

1. Name the parameter and distinguish statistical coordinates from the scientific quantity it induces.
2. Fix measurement scale, support, reference points, link and transformation. For brms inspect `get_prior()` and the generated model: a default centered intercept is not necessarily the raw baseline intercept.
3. State plausible baseline and effect ranges using independent scientific information where available. Consider joint effects across the actual predictor design.
4. Choose a proper family whose center, tails and support reflect those ranges; distinguish substantive assumptions from an identifying convention.
5. Simulate independent prior draws and replicated observations, including group and observation variation.
6. Inspect baseline distribution, plausible slopes/contrasts, extremes, probabilities, trajectories, between/within-group variation and total signal.
7. If implausible, inspect units and generator first, then revise the responsible prior/likelihood. Repeat simulation.
8. Fit and compare prior/posterior for identifiable scientific functions and weak directions.
9. Investigate prior–data conflict or lack of learning; do not mechanically widen or strengthen priors to obtain a preferred posterior.
10. Refit plausible alternatives for assumptions that materially affect the estimand, especially weak hierarchy/nonlinearity/latent effects. Report consequences.

## Parameter-specific choices

| Parameter | How to reason | Failure to avoid |
|---|---|---|
| Intercept | Baseline response at stated predictor reference, on the link scale; empirical knowledge may inform it | Using population raw-mean units for a log intercept or brms centered intercept |
| Slopes/interactions | Plausible response contrast per meaningful predictor change, jointly across covariates | Independent broad priors producing extreme total signal as dimension grows |
| Residual scale | Positive scale on actual outcome scale, allowing credible scatter/tails | Copying a rate parameter across units or forcing negligible error |
| Hierarchical SDs | Plausible between-group variability and observable group contrasts | Broad hyperpriors allowing unrealistic groups or pinching variance to zero without justification |
| Correlations | Joint variation, group number and dimension; Cholesky LKJ where appropriate | Assuming LKJ(1) supplies equally uniform marginal correlations in all dimensions; estimating elaborate correlations with few groups |
| Nonlinear parameters | Scientific support, units, attainable curves and identifiable functions | Broad improper priors on unused/weak components; hard bounds chosen only to remove warnings |
| Latent effects | Meaningful scale/location anchors; distribution of observations after integrating them | Mistaking an arbitrary sign/scale convention for scientific evidence |
| Regularization | Total signal/sparsity and design correlations; scaled Gaussian, RHS or R2D2 if justified | Selecting priors separately without examining induced R-squared, or assuming sparsity for every scientific effect |

## Concrete sleep-study reasoning

The reviewed Gaussian regression works in milliseconds, removes adaptation days and sets the new baseline to original day 2. The explicit `0 + Intercept + Days` formulation makes baseline priors easier to interpret. An illustrative intercept prior is normal(200,100), slope normal(0,20) and residual SD exponential(rate .02); a centered-intercept alternative uses normal(250,100). These values are corrected source examples, not portable prescriptions.

Moving to lognormal error changes the intercept/scale units; copying millisecond priors produces absurd predictions. The source revises the log intercept (e.g. normal(5,.55)) and slope/scale priors, then simulates original-scale responses. Varying slopes require priors on both between-subject SDs and their correlation, and checks of subject trajectories/shrinkage. Robust Student-t errors address specific outliers that inflate Gaussian variance; extra distributional parameters introduce their own prior/identification obligations.

## What role is the prior playing?

- **Weakly informative:** excludes unrealistic implications while retaining a wide scientifically plausible region. It is scale dependent and still substantive.
- **Regularizing:** expresses limited signal/sparsity/heterogeneity and reduces noisy overfitting; verify the induced joint predictions.
- **Strongly informative:** encodes precise external knowledge; document source compatibility, transport and sensitivity.
- **Identification:** establishes a location/scale/sign/order or removes a redundant degree of freedom. Some constraints are conventions; substantive restrictions may change inference. Do not claim data identify an anchored convention.

## Decision rules

**IF posterior is close to prior:** inspect whether the parameter enters the likelihood, data variation/group size, confounding, posterior of derived functions and recovery. Possible explanations include genuinely uninformative data, a bug, redundant coordinates or a very concentrated prior. Validate a code fix with simulation; validate a stronger prior with scientific information and sensitivity. Lack of change alone does not prove an error.

**IF posterior is unexpectedly narrow:** check duplicated observations/likelihood contributions, ignored clustering/overdispersion, wrong denominator, accidental double prior, restrictive support and chain collapse. Reproduce a known-data fit and repeat predictive/MC checks after correcting the identified cause. Do not widen intervals by an arbitrary multiplier.

**IF prior and likelihood disagree:** verify units, coding and population comparability; inspect relevant prior predictions and data-informed functions. Evaluate whether tails, measurement bias or omitted structure explain conflict. Compare defensible prior families or explicit bias models, then assess conclusions. A heavy-tailed prior can alter shrinkage; it is not a general cure for incompatible scientific assumptions.

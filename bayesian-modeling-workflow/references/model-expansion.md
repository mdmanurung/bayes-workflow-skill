# Evidence-directed model expansion

Basis: E01–E04 in [source map](source-map.md). Use a branching ladder, not a compulsory progression from independent regression to latent complexity. A revision may simplify the model or improve an observation process before adding predictors.

| Branch from current model | Evidence and scientific reason | New identification/prior obligations | Computational consequences and acceptance check |
|---|---|---|---|
| Executable generator → minimal useful model | Need an estimand and observation process that toy model lacks | Baseline/effect/error scale on scientific units | Recovery, transformed quantities, prior PPC; does it answer question? |
| Mean/predictor structure | Conditional residual trend, justified effect modification or known nonlinearity | Interaction/nonlinear combinations may be weak; joint total signal | Correlation/scale can worsen; check contrast predictions and geometry |
| Group structure | Repeated/group dependence; heterogeneity matters to target | Exchangeability, SDs and correlations; sparse groups weakly informed | Funnel/ridges; compare pooling/shrinkage, known versus new group checks |
| Observation model | Dispersion, tails, bounds, censoring or assay errors wrong | Tail/dispersion/zero parameters or calibration may trade off with mean | Additional weak coordinates; inspect original failing statistic and coefficient changes |
| Mechanistic/nonlinear components | Specific scientific mechanism and observable inadequacy | Overlapping components, invariances, plausible curves and support | Curvature/modes/solver expense; test components separately and recovery regimes |
| Temporal/dependence components | Residual autocorrelation/seasonality or sequence behavior | Confounded trend/periodic/intercept/latent scales; basis approximation | High-dimensional correlations; check residual structure and forecast validation |
| Latent structure | Unobserved process necessary to measurement/scientific target | Location/scale/sign/label anchors, information per latent unit | Marginalization or CP/NCP; integrated held-out prediction and SBC |
| Regularization/reduction | Excess joint signal, unstable prediction, need simpler deployable model | Prior signal/sparsity and search uncertainty | Shrinkage geometry; validate reference and selection path; assess stability |

For every expansion record:

```
Observed inadequacy:
Relevance to estimand:
Scientific/statistical explanation and competing hypotheses:
Discriminating evidence:
Proposed modification:
Expected observable consequence:
New identification risk and prior response:
New computational risk and parameterization response:
Validation check and result:
```

## Rules for accepting a change

Do not add an interaction, random slope, latent factor or zero component merely because it fits. Require a scientific role or a specified predictive discrepancy. Reuse the prior workflow after every change of dimension, units or parameter meaning. Check computations and original PPC after refitting, plus a targeted check for the new component. Compare predictive scores only if their target is meaningful and unchanged.

A predictive tie can favor simpler implementation for deployment, but not deletion of a scientifically required confounder or dependency. Conversely, a richer mechanism with weakly identified parameters may have stable useful predictions; report that distinction instead of interpreting every latent coordinate.

Do not force variance/robustness/latent branches into an arbitrary order. Nabiximols/roaches require an observation revision; movies/coronavirus require pooling structure; golf motivates mechanistic expansion and discrepancy; birthdays decomposes temporal residuals and sometimes changes priors or removes redundancy rather than adding components.

Stop if the existing model meets task adequacy and no specific material failure motivates expansion. If the next parameter is not identifiable, consider a better-measured scientific function, external calibration or data acquisition. Complexity that improves a score negligibly but weakens interpretation/computation is not automatically useful.

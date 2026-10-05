# Design targeted predictive checks

Basis: Q01–Q05 in [source map](source-map.md). Ask: **Which specific aspect of the observed data would reveal failure of this assumption?**

Use replicated datasets conditional on the design and posterior parameters, generated through the intended observation process. Plot a manageable set of replications or the distribution of a targeted statistic against its observed value. Keep the test quantity on interpretable units. A posterior predictive discrepancy is a diagnostic question, not an automatic hypothesis-test cutoff.

| Purpose | Useful observable | Likely next hypothesis |
|---|---|---|
| Global fit | Overall distribution, range and representative replications | Broad location/scale/likelihood error; preprocessing mistake |
| Distribution | Spread, tails, skew, zeros, bounded endpoints, rootogram | Overdispersion, wrong support, missing mixture/error process |
| Conditional | Patterns versus predictor/time; binned residual mean/spread; reliability | Wrong functional form, heteroskedasticity, missing interaction |
| Group | Within/between variation, group means/slopes, sparse-group shrinkage | Pooling assumptions or varying effects inadequate |
| Extreme observations | Maximum, large counts, zero/endpoint rates, unusual trajectory | Tail/variance failure, coding error or genuine influential unit |
| Scientific summary | Clinically meaningful contrast, switch counts, distance-specific success | The scientific mechanism or quantity is not represented |
| Structure | Serial correlation, cross-variable correlation, track/state durations, cohort patterns | Dependence or latent structure missing |

Select checks connected to the estimand and proposed revisions. A histogram that looks adequate can hide conditional reliability problems (roaches), and an overall time trend can hide sequence switching (dogs). Marginal prediction of each component does not establish the joint dependence needed for a decision (misc reverse-engineering).

## Interpret and revise

**IF a check fails:** verify data/transformation and generated quantities first. World Cup's misfit exposed a transform bug. Then state whether mean, variance, tails, pooling, dependence or observation/censoring is implicated. Use a second check to distinguish explanations: overdispersion versus excess zero structure, mean misspecification versus changing variance, group heterogeneity versus individual noise. Compare small scientifically plausible modifications, repeat the original check and add a new check for the introduced component.

**IF no check fails:** assess whether checks had resolution/power for the task. Sparse data may not identify subtle mechanisms, and flexible observation-level latent effects can fit in-sample nearly perfectly. Use held-out prediction or sensitivity where relevant; do not claim the model is true.

## Replication target matters

For repeated subjects, distinguish replications with their estimated effects from new subjects drawn from the population hierarchy. The former checks observations for known groups; the latter checks the group distribution and transport. Recompute outcome-derived histories recursively when simulating full sequences; leave-future-out validation must use only information available at that origin. For censored outcomes, replicate censoring or condition on a clearly stated censoring design and compare observed records accordingly.

Posterior expected responses (`posterior_epred`) exclude observation noise and are useful for mean contrasts; replicated outcomes (`posterior_predict`) include it and are needed for distribution checks. Setting `re_formula=NA` excludes group deviations by setting them to zero; under nonlinear links it does not average over the group population. Integrate group effects and target weights when that is the estimand.

## LOO predictive checks

In-sample PPC uses data to fit and check, which can conceal flexible misfit. LOO predictive intervals/PIT/reliability assess held-out behavior when the predictive target matches and approximation diagnostics are reliable. For discrete outcomes handle PIT ties/randomization using supported package routines rather than applying a continuous uniformity argument unchanged. Interpret simulated/reference envelopes under the actual fitted checking procedure; posterior predictive PIT need not be exactly uniform. Fix poor PSIS before interpreting LOO-PIT evidence. Model checking and model comparison remain distinct.

# Criticize the model with informative replications

Contents: [prior predictions](#prior-predictive-checks), [posterior predictions](#posterior-predictive-checks), [targeted quantities](#choose-a-quantity-that-exposes-the-failure), [hierarchies/dependence](#hierarchical-and-dependent-data), [calibration](#pit-coverage-and-predictive-p-values).

Ask: **What feature of these data would expose the specific way this model might be wrong?** Choose that feature before looking for a reassuring plot. A model can recover means because it fitted location parameters while missing tails, zeros, group heterogeneity or dependence.

## Prior predictive checks

**Question:** Do the joint prior and likelihood generate observables and scientific contrasts compatible with prior knowledge?

**Prerequisites:** Proper simulatable priors, specified design/predictors/group structure and observation process. Establish units/support and external/domain reference values; use the same design size when maxima or rare-event frequencies depend on it.

**Computation:** Python: `pm.sample_prior_predictive(draws=...)`, then `az.plot_ppc_dist(prior, group="prior_predictive")` or direct test-quantity calculations. R: `brm(..., sample_prior="only")` with proper priors followed by `posterior_predict`; custom Stan: an explicit prior simulator/fixed-parameter generator, not a fit conditioned on observed outcomes.

**Interpretation:** Inspect typical observable scale, impossible/extreme outcomes, tails, variation among groups, effects across predictor values, and induced priors on scientifically interpretable differences/probabilities. Individual priors that look reasonable can have implausible joint predictions, particularly through nonlinear links or many predictors.

**Likely causes:** Units or link mistakes; very diffuse intercepts/scales; overly tight priors; accidental dependence or inconsistent prior statements; likelihood support/observation-process mismatch.

**Do NOT:** Tune priors to match the same outcomes later used for inference without acknowledging data reuse, select a prior solely because it produces a desired result, or inspect only parameter marginals.

**Actions:** Verify implementation/units; localize the component causing implausible predictions. Elicit bounds/quantiles on observable quantities or plausible parameter effects, revise one justified component, and resimulate. If the scientific support is wrong, revise the likelihood/measurement model as well as priors.

**Follow-up:** Repeat targeted prior predictions and induced-quantity checks; record the justification, reference values and changes. Then fit and validate computation.

**Evidence:** E05 heights and E12 (`direct-eabm`, `eabm-code`); M-VIS/M-PPC (`method-paper`); R (`translated`); hierarchical extensions (`synthesized`).

## Posterior predictive checks

**Question:** Can the fitted model reproduce the scientifically relevant data features and observation process?

**Prerequisites:** Adequate computational approximation; posterior replicated outcomes rather than expected response values; aligned observation IDs/design; explicit conditional versus new-group replication.

**Computation:** Python: `pm.sample_posterior_predictive(..., extend_inferencedata=True)`; `az.plot_ppc_tstat(dt, t_stat=...)`, discrete rootograms, group subsets or custom statistics. R: `brms::posterior_predict(fit)` or Stan generated `y_rep`; `bayesplot::ppc_stat(y, yrep, stat=...)` / grouped variants. See the language recipes for matching shapes.

**Interpretation:** Compare observed T(y) to the distribution of T(y_rep) across whole replicated datasets. Diagnose the feature, direction, affected groups and scientific consequence. Pooled agreement can conceal local failures. A passed check supports adequacy only for that feature/design.

**Likely causes:** Wrong likelihood tails/dispersion/support; missing nonlinear/group/dependence structure; outlying subpopulations; incorrect exposure/denominator/censoring handling; erroneous data or index mapping.

**Do NOT:** Use a generic density overlay as sufficient validation, treat posterior predictive p-values as ordinary significance tests, or mistake latent-mean uncertainty for future-observation uncertainty.

**Actions:** Validate observed/replicate alignment and data quality. Add a diagnostic that distinguishes plausible explanations for the failure. Revise one mechanism that explains it (not just an automatically more flexible model); retain valid unusual observations and check neighboring features that revision could harm.

**Follow-up:** Refit, validate computation, rerun the original failed quantity and collateral checks, evaluate sensitivity and target-matched comparison if useful. Record residual failures even if the model is adequate for the specified purpose.

**Evidence:** E05 (`direct-eabm`, `eabm-code`); M-VIS/M-PPC (`method-paper`); R (`translated`); mechanism-based action order (`synthesized`).

## Choose a quantity that exposes the failure

| Suspected failure / data | Targeted checks | Likely interpretation / next discriminating check |
|---|---|---|
| Wrong location | Means/medians by covariate region, group and time; signed residual patterns | Missing intercept/group/nonlinear term; a globally fitted mean may be a weak check |
| Wrong spread / heteroscedasticity | SD/IQR/MAD, residual spread versus predicted mean/covariates, within-group spread | Variance changes, omitted structure or outliers; distinguish before changing likelihood |
| Heavy/light tails | Upper/lower quantiles, maxima/minima, exceedance counts and tail asymmetry | Tail likelihood or mixture/measurement process; maxima depend on replicated sample size |
| Skewness | Quantile asymmetry, median–mean difference, asymmetric residual tails | A symmetric Student-t addresses heavy tails, not skewness by itself |
| Excess zeros | Zero frequency by exposure/group; positive-count distribution; rootograms | Overdispersion, omitted predictors, detection limit, rounding or structural absence; zeros alone do not mandate a hurdle/zero-inflated model |
| Counts | Variance/mean pattern, low-count cells, zeros/maxima, rootogram with frequency uncertainty | Compare Poisson assumptions to justified over/underdispersion and exposure models |
| Binary outcomes | Calibration versus probability/covariates; subgroup event frequencies; proper held-out scores | Global class proportions are often nearly tautological; sparse bins/imbalanced classes need uncertainty |
| Proportions | Replicated successes with actual denominators; endpoint frequency; subgroup dispersion | Check binomial versus extra-binomial variation; continuous beta models cannot directly model exact endpoints |
| Categorical/ordinal | Category-specific or cumulative calibration, rare categories, transition patterns | Respect category ordering and thresholds; a marginal confusion table can hide probability errors |
| Repeated measures | Within-person differences, correlation, variance decomposition, trajectories | Need design-matched replication; independence assumptions can miss repeated/temporal structure |
| Time/space | Residual ACF, runs, increments, lag relationships, extremes/clusters, forecast horizons | Preserve order/spacing and observed masks; irregular timepoints need interval-aware checks |
| Hierarchical variation | Group means/spreads/slopes; between-group variance; extreme groups; new-group predictions | Conditional effects can fit existing groups yet population distribution/new groups remain wrong |
| Censored/truncated data | Replicate censoring/detection rules; survival curves, time-specific survival and event fractions | Raw observed durations are not uncensored outcomes; model the observation process |
| Scientific derived quantity | Response contrasts, protected-group differences, dose-response, exceedance risk, clinically meaningful thresholds | Diagnose the quantity used in the claim even when nuisance-parameter PPCs look good |

Most extended rows are `synthesized` applications of E05's targeted-check logic and M-VIS/M-PPC, not examples all demonstrated by EABM. Preserve this distinction when explaining them.

## Hierarchical and dependent data

Use two explicit replication targets where relevant:

- **Conditional existing groups:** Retain the fitted group effects and generate new outcomes at the observed design. Check residual/within-group structure and scientifically relevant contrasts.
- **Population/new groups:** Draw new effects from their posterior population distribution, then generate outcomes. Check whether the hierarchy plausibly generates groups and transports to unseen participants/sites. Removing fitted effects or setting them to zero is not generally integration over new effects.

Calculate one statistic per replicate over the intended unit. For observed incomplete follow-up, preserve the observation mask/time schedule if checking the recorded-data model; if testing a missingness mechanism, simulate that mechanism too. Do not pad ragged cohorts with fictitious observations. Separate actual repeated individuals from independent repeated acquisitions.

In multivariate/multi-likelihood models, check each outcome and their joint dependence/derived combinations. Marginally good fits do not guarantee adequate joint predictions. New-group/time evaluation requires folds or held-out replications that match information availability; ordinary row-wise LOO can be the wrong task.

## PIT, coverage and predictive p-values

PIT/ECDF plots can reveal location and dispersion errors: combine them with original-scale diagnostics. For discrete responses, use a verified randomized/discrete-aware PIT implementation; tied counts do not have a continuous uniform PIT. For dependent units, generic independent uniformity envelopes may not apply.

In-sample posterior predictions reuse the fitted data. Their PITs or predictive p-values do **not** generally have the simple independent uniform null distribution assumed by ordinary frequentist tests. Interpret exploratory patterns rather than certifying calibration. For stronger assessment use properly diagnosed LOO-PIT or held-out predictions, keeping the appropriate dependence/holdout design.

Repeated-simulation coverage of parameter intervals is an SBC/calibration question; coverage of predictive intervals on new outcomes is a predictive question. A single credible interval does not itself imply a frequentist coverage guarantee for a fixed true parameter.

A posterior predictive p-value summarizes how extreme T(y) is relative to replicated T. Report the discrepancy and mechanism, not a binary “valid model” verdict. Very good agreement for a statistic largely determined by fitted parameters can have little diagnostic power.

Evidence: E05 (`direct-eabm`); M-VIS, M-PPC, M-ECDF and M-SBC for caveats (`method-paper`); extended dependence/target safeguards (`synthesized`). Sources: [bibliography](../references/bibliography.md).

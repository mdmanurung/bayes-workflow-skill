# Sensitivity that can change a scientific conclusion

Basis: T01–T04 in [source map](source-map.md).

Identify assumptions whose plausible alternatives could materially change the estimand, prediction or decision. Prioritize weakly identified components, sparse-group SD/correlations, assay calibration, nonlinear mixtures, total-signal/regularization choices, observation tails/dispersion, baseline conditioning and target population weights. Missingness/transport assumptions may be important beyond the provided demonstrations; specify the scientific alternative rather than pretend these cases prescribe a generic solution.

## Procedure

1. Freeze the scientific target, data IDs and reported functions where possible. If an alternative changes target/conditioning, label it as a different analysis.
2. Name the assumption and its source of uncertainty. Choose a small set of scientifically defensible alternatives, not arbitrary tiny and huge prior multipliers.
3. Simulate each alternative's implications. Eliminate unsupported alternatives for a documented reason; do not exclude them merely for producing an inconvenient answer.
4. Fit/reliably approximate each alternative, repeat diagnostics and relevant PPC, and compare the same draw-level quantities/decision criteria.
5. Report changes in location, uncertainty and the scientific decision, including effects of computational or approximation uncertainty.

## Local and global checks

Power-scaling methods perturb prior or likelihood contributions and can diagnose where a quantity is sensitive. Interpret prior sensitivity versus likelihood sensitivity in context: weak information, conflict or misspecification may explain the result. Reliability/importance-sampling limitations also apply to reweighted approximations. Use direct refits for material shifts, large changes or unreliable reweighting; a local derivative is not a complete robustness guarantee.

The coronavirus example illustrates the effect of hierarchical assay priors on rare prevalence; sleep shows scale/tail prior effects; birthdays shows calendar-effect interpretation changing under prior choices; variable selection contrasts sparsity and total-R-squared knowledge. These are reasons to examine the weak direction, not to standardize one prior family across all models.

## Decision rules

**IF conclusions differ under plausible priors:** check identification, population relevance of external information and prior predictive plausibility. Report the dependence; consider a better-identified scientific function or new calibration data. Do not select the prior that yields preferred significance.

**IF prediction is stable but latent parameters differ:** report useful predictive stability and limited latent identification separately. A predictive tie does not establish mechanism.

**IF a supposedly harmless implementation change alters conclusions:** verify model equivalence, normalization/Jacobian, latent scaling, preprocessing, generated quantities and computational accuracy before treating it as scientific sensitivity.

**IF all tried alternatives agree:** describe the tested scope; do not claim robustness to unexamined missingness, selection, extrapolation or causal assumptions. Stop once task-relevant alternatives have been assessed adequately, rather than launching an indiscriminate grid.

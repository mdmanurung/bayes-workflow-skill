# Report supported scientific quantities and limitations

Basis: W02–W05, F04 and T01–T04 in [source map](source-map.md).

Lead with the scientific question and estimand, then the supported conclusion with posterior uncertainty. Interpret draw-level quantities on meaningful units. Distinguish posterior expected contrasts from future-observation variation, conditional group estimates from population/new-group quantities, and predictive association from causal or mechanistic claims.

## Minimum report

- Data/assignment/observation structure, independent units, exclusions/baseline transformations, missingness/censoring and target population.
- Likelihood/link, dependencies, important priors with units and rationale, identifying constraints and parameterization.
- Computational reliability: chains/draws, relevant R-hat/ESS/MCSE, divergences/energy/treedepth and any unresolved modes or numerical limitations.
- Targeted prior/posterior predictive checks and specific residual shortcomings; do not imply every conceivable aspect was checked.
- Validation/comparison task, observation IDs/measure, elpd differences and uncertainty, PSIS reliability/influential cases and repairs, if used.
- Sensitivity/calibration domain and failures, if used; explain assumptions that could still alter conclusions.
- Scope of interpretation, extrapolation/new-group limitations and what further data would resolve weak identification.

Report precision justified by posterior uncertainty and Monte Carlo accuracy. Quantiles and probabilities need their own MC error assessment; bulk ESS or rounded R-hat is not enough. Avoid excessive digits and source-specific universal digit rules. Scientific uncertainty is not the MCSE, and eliminating MC error cannot eliminate model uncertainty.

## Stop or qualify

When computation and task-relevant checks are adequate and plausible alternatives do not change the conclusion materially, stop with a transparent model limitation statement. If uncertainty remains due to design or identification, state it directly and narrow the claim. If important sampler/model failures remain, label output provisional and explain what inference is unsupported.

For a decision, state loss/utility, target uncertainty and the action implied under it. A maximum posterior classification probability may maximize expected correct classifications but not the probability of winning a threshold-based contest (timeseries). For a mechanistic claim, identify observable competing explanations; fitting a plausible mechanism is insufficient evidence that it generated the data (dogs).

Keep the report reproducible with model/data version, code and software provenance. Separate observed fitted evidence from checks merely recommended. Use [source map](source-map.md) when explaining workflow principles, without pretending synthesized guidance was directly stated by the authors.

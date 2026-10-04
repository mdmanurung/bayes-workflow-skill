# Three different simulation tasks

Basis: S01–S03, I01 and B01–B04 in [source map](source-map.md).

| Task | Draw parameters | Generate observations | Fit? | Question |
|---|---|---|---|---|
| Prior predictive | From the stated joint prior | Through likelihood and observation process at defined design | Usually unnecessary; prior-only fitting is an interface option | Are implied datasets plausible before seeing responses? |
| Fake data / recovery | At selected known values, spanning realistic easy/difficult regions | Independently implemented generator where feasible | Yes | Can code/inference learn relevant parameters/functions at this design? |
| SBC | From the exact joint prior defining the calibration target, repeatedly | From the same statistical model and observation process | For each simulated dataset | Is the full procedure calibrated averaged over this generative distribution? |

Prior plausibility is not parameter recovery. Recovery at one truth is not SBC. Passing SBC does not validate the scientific model against real observations. SBC can pass when a parameter is unlearned or unused, so track contraction and data-dependent quantities too.

## Prior prediction

Use direct simulation when simpler and exact. With brms, set proper priors for every sampled parameter and `sample_prior="only"`; predictors/design remain supplied data while responses are not used in the likelihood. `sample_prior="yes"` fits the posterior and saves some prior draws; it is a different task. Inspect draws in observable units and do not count every MCMC draw as independent if prior-only fitting uses MCMC.

## Recovery and debugging

Begin with a small model and a known easy case. Save truth, design, latent values when needed, observation mask and seed. Fit the same likelihood; distinguish uncertainty expected from finite data from bias or computational failure. Inspect interval coverage across repetitions, estimation error versus posterior uncertainty, fitted observable functions and numerical diagnostics.

Increase trial counts or change predictor contrast to distinguish weak information from a bug, as in dogs. Make exponential components widely separated and nearly equal to distinguish identification regimes. Test missing/zero exposure, boundary counts, singleton groups/tracks, transformations and censoring separately rather than adding every edge case to a single complex example.

Use a generator separate from the fitted likelihood when feasible: the same indexing mistake in both can create reassuring but meaningless recovery. Check selected likelihood values against a manual calculation. Validate generated quantities and derived scientific contrasts, not just parameters.

## Repeated calibration

Read [SBC](sbc.md) for exchangeability/ranks, autocorrelation, failures and restricted targets. Decompose a new model into testable submodels before launching expensive runs. Preserve result files and failure metadata; use reproducible independent RNG streams if parallelizing. Initial small experiments find obvious failures, while larger experiments need justified precision. Source repetition counts are demonstrations rather than minimum universal sample sizes.

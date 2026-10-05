# Build a minimal generative model

Basis: G01–G03, F03, I01 in [source map](source-map.md).

Write the simulation in scientific order: population/cohort → subject/group properties → latent process if necessary → measurements/outcomes → observation/censoring/selection. Conditional distributions must agree with the likelihood. State which predictors/exposures are held fixed and which are generated.

A minimal model retains dependencies essential to the question. Independent rows are not a useful baseline if they fundamentally misrepresent repeated subjects or grouped assignment. Conversely, a mechanistic latent state should not be added simply because it can be coded. Use a simple executable version to check dimensions, signs, support and observable behavior; add a component only when its scientific role or a discrepancy justifies it.

## Before fitting

1. Inspect schema, missing codes, units, timestamps, duplicates, group counts, response support, exposure and denominator.
2. Choose meaningful reference points for continuous predictors and baseline categories. Record centering/scaling constants; test forward/inverse transformations. For validation, estimate data-learned preprocessing using training data only.
3. Describe conditional expectation and variance on the observed scale, including how effects combine through the link.
4. Simulate prior predictions at representative predictor values and the actual design. Inspect joint behavior, not only each coefficient's prior.
5. For new implementation, simulate fixed known parameters and test likelihood/generated quantities against simple independent calculations.

## Reproduce the actual process

- Dogs: simulated responses must update subsequent shock/avoidance histories. Using the observed history produces a different, conditional check.
- Cats: event and censoring records both enter the observed dataset. A PPC that draws only uncensored event times cannot validate the censoring-aware observation likelihood.
- Roaches: exposure belongs in the rate-to-count map. Keep offset units fixed and compare fitted counts for the observed exposure distribution.
- Sharks: initialize a state process at each separate track, preserve measurement intervals and handle missing emission components.
- World Cup: transforms, rounding and bin masses are part of the observation model. A density evaluated at a discrete observation is not automatically its probability mass.

## Scale and support decisions

Use scaling to express priors and improve numerical geometry; do not convert it into an undocumented change of scientific quantity. Log outcomes change the interpretation of coefficients and intercepts. Positive parameter constraints encode scientific support; they cannot identify two indistinguishable exponential components. Standardizing a likelihood for comparison requires consistent transformation of scores/measure, not simply comparing reported numerical elpd.

## Minimum acceptance evidence

The generator returns supported values for typical and edge-case inputs; units and inverse transforms agree; prior observables are credible for the question; likelihood and simulation match; fake-data recovery is plausible for identifiable quantities. If parameter recovery fails but predictions succeed, investigate identification before declaring the fit buggy. Use [simulation](simulation.md) to distinguish these tests.

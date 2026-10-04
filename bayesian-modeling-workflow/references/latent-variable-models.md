# Develop latent models without losing the scientific target

Basis: V01–V05, H02 and B01–B04 in [source map](source-map.md).

Add a latent variable when the unobserved measurement/state/heterogeneity process is necessary, not because a flexible model can explain every observation. State what it represents, what data identify it and which observable prediction would distinguish the proposed structure. Separate predictive fit from latent interpretation; dogs demonstrates that apparently mechanistic coefficients can arise from a different data generator.

## Development sequence

1. Fit/test the observation component with latent values fixed or known from simulation.
2. Test the latent distribution or transition process independently.
3. Identify invariances: additive shifts, multiplicative scale/sign, label permutations, factor rotations or interchangeable components.
4. Choose justified anchors/constraints and priors; revise the simulator to the exact same support.
5. Assemble one component at a time, checking prior observable implications and fixed-truth recovery.
6. Inspect posterior geometry and both raw/standardized coordinates. Evaluate centering based on information per latent unit.
7. Validate posterior predictions conditional on observed units and for new units; integrate held-out latent effects when required.
8. Run staged SBC for new implementation and derived quantities; report failures and weak learning.

## Common structures

| Structure | What can go wrong | Discriminating check and response |
|---|---|---|
| Ability/item model | Ability–difficulty shift and discrimination–ability scale confounded | Inspect predictor/latent design and recovery; anchor location/scale; retain uncertainty in item discrimination |
| Observation-specific effect | Fits each datum almost exactly, weakly informs population scale, high k | Compare conditional PPC to integrated held-out prediction; prior sensitivity and marginal likelihood |
| Mixture | Label symmetry, near-overlap, tiny component and whole-dataset versus pointwise mixing bug | Verify each observation's mixture operation; order only if scientifically conventional; test overlap regimes and invariant summaries |
| Hidden Markov state | Underflow, wrong transition orientation, track boundary leak, missing emission treated as real data | Log-space forward recursion; independent tiny-track enumeration; track resets, missing/singleton tests; forward-backward probabilities |
| Factor/derived biological score | Sign/scale/rotation ambiguity, sparse indicators, plug-in uncertainty | Define scientifically relevant invariant/anchored score, test indicator recovery and uncertainty propagation; do not force positive latent values merely because measurements are positive |
| Nonlinear dynamics/ODE | Alias modes, solver error, excessive computation in plausible regions | Simplified slices, tolerance checks, trajectories by chain, prior predictive simulation and sensible initialization |

The factor/biological-score row is a transferable extension, not a fully worked official case. Choose a measurement model only after inspecting the actual scientific measurements.

## Marginalization and decoding

Stan does not sample discrete latent states directly. When feasible, sum over discrete states using stable log-sum-exp or the forward algorithm. Use log likelihood for the actual observable unit; a marginal sequence likelihood is not a sum of arbitrary filtered pseudo-observation scores.

Local state probabilities, sampled state sequences and a most-likely path are different summaries. Plot state uncertainty and check state-dependent observables/transition durations; do not report a decoded label as an observed biological state. Ordered components fix a permutation convention; they do not create separation where the data supply none.

For continuous latent effects, marginalization may improve geometry or held-out scoring but can introduce quadrature/nested simulation error. Verify integral accuracy at difficult posterior/prior values. Generated-quantity integration for CV need not change fitting. A non-centered reparameterization preserves a properly matched model; a stronger prior or identification constraint may change it and needs sensitivity/predictive validation.

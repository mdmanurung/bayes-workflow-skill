# Simulation-based calibration as implementation validation

Basis: B01–B04 in [source map](source-map.md); current SBC-package guidance supplements source examples.

SBC repeatedly draws parameters from a proper joint prior, simulates data from the model, fits the full inference procedure and compares truth to posterior draws. With exact independent posterior draws and suitable tie handling, the truth's rank is discrete uniform marginally over simulations. This checks calibration under the specified generative distribution; it does not prove model adequacy for real data or uniform coverage at every fixed parameter value.

## Run incrementally

Start while components are simple. Test logistic and mixture submodels separately, then their composition. Define important parameters and scientifically relevant/data-dependent functions before running. Save truth, simulated design/observation mask, seeds, fit diagnostics, failures and rank results. Use independent simulator code and manual tiny-case likelihood checks when feasible.

Begin with small experiments to identify gross mistakes; increase replications/draws based on desired power/resolution and cost. Histograms, empirical CDF/rank diagnostics and interval checks need finite-simulation reference uncertainty; do not demand perfectly flat bins or invent a universal SBC run count.

Ensure posterior autocorrelation does not invalidate rank reference assumptions. Use the supported SBC backend's sampling/ESS handling or retain sufficiently independent draws with a documented plan; thinning reduces dependence but does not fix biased exploration. Account for randomized ties for discrete or atom-containing quantities. Do not apply continuous ranks blindly at boundaries.

## Interpret failures through competing explanations

**IF rank shape suggests bias/underdispersion:** inspect simulator-versus-likelihood agreement, transformations, double priors, indexing, support, Monte Carlo dependence, diagnostics and difficult prior regions. Test a simple conjugate or analytically tractable component; localize the failure before revising priors to make SBC pass.

**IF marginal ranks pass but learning is absent:** check whether each parameter enters likelihood, truth-versus-estimate scatter, prior/posterior contraction and data-dependent joint functions. The official unused-intercept example can pass marginal ranks because posterior equals prior. Passing ranks alone is not proof of correct conditioning or useful information.

**IF mixture calibration fails:** verify pointwise mixture likelihood. `log_mix(theta, sum(logp1), sum(logp2))` describes one component for the whole dataset; `sum_n log_mix(theta_n, logp1_n, logp2_n)` describes independently allocated observations. Match label ordering between generator and fitted support. Near-overlapping components can remain difficult after symmetry is removed.

**IF only hard datasets fail:** retain those failures and investigate identification/geometry. A predeclared data-only restriction changes the generative calibration target and must be reported, with rejection rate and applicability. Removing fits because they diverged or failed is selection on inference behavior; a histogram of the survivors cannot justify unrestricted calibration. Fix computation or qualify the unresolved domain.

## Source-specific corrections and restrictions

The mixture example repairs accidental whole-dataset mixing, unused parameters and an intercept prior counted twice after moving the intercept into the design matrix. The Fano-factor restriction is corrected by official errata: reject variance below 1.8 times the mean in that illustrative experiment. This is a source-specific demonstrative restriction, not a general mixture acceptance criterion or a recommended automatic filter.

## Acceptance statement

State prior/design domain, tested quantities, simulation/draw counts, handling of ties/dependence, failed/rejected counts and reference uncertainty. Report whether observed deviations are unresolved. Re-run after implementation changes and validate prior plausibility/PPC separately. Use [simulation patterns](../examples/simulation-patterns.md) for an executable conjugate baseline and [debugging](debugging.md) for component tests.

## Qualification on diagnostic-defined restrictions

Current SBC documentation permits fitting-diagnostic restrictions interpreted as acceptance based on observed data, and limits guarantees to datasets meeting that same restriction. Do not claim such exclusions are universally prohibited. This skill additionally asks whether acceptance depends on inference randomness/shared posterior draws, whether the restriction was defined before inspecting ranks, and whether all failures and the excluded domain were disclosed. These are conservative qualifications, not a purported correction from the authors. Post hoc survivor plots cannot establish calibration over the original unrestricted domain.

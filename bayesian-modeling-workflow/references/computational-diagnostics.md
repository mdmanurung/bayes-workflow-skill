# Diagnose computation before interpreting a fit

Basis: C01–C09, H02, M01 in [source map](source-map.md). Current official Stan/posterior guidance supplements the case demonstrations. None of these diagnostics proves that an unexplored mode does not exist or that the statistical model is appropriate.

## Establish the diagnostic object

Use post-warmup chains with chain identity retained. Inspect all model parameters and consequential transformed/derived quantities. Keep generated replicated observations out of an indiscriminate enormous parameter table; diagnose the generating parameters and selected scientific functions. Separate failed evaluations during initialization, warmup and sampling. Record seeds, chain starts and warning counts by chain.

For a final HMC fit, use multiple chains (normally at least four) from sufficiently varied plausible starts. Inspect rank-normalized split/folded R-hat, bulk ESS, tail ESS, MCSE, trace/rank plots, divergences, maximum treedepth and energy/BFMI. The common R-hat target below 1.01 and bulk ESS around at least 100 per chain are diagnostic guidance, not accuracy guarantees. Early exploratory fits may be deliberately shorter and must be labeled provisional. Tail ESS concerns common tail quantiles and does not certify an extreme rare-event probability; diagnose that specific quantity.

## Troubleshooting trees

### High R-hat or chain disagreement

**Symptom → hypotheses:** persistent between-chain differences suggest nonstationarity, separate modes, heavy tails, redundant/unidentified directions, bad scaling or insufficient adaptation/sampling. R-hat near one cannot detect a mode that every chain misses.

**Discriminate:** plot traces/ranks by chain, inspect pairs and chain-specific predictions; check design rank, unused parameters, priors/support, heavy-tail functions and varied starts. Compare a simplified model and a known-data fit. Distinguish a proper heavy-tailed posterior from an improper posterior under flat priors (problems).

**Statistical remedies:** remove accidental redundancy, supply scientifically defensible proper priors or revise weakly identified structure. Do not impose a desired scientific answer simply to align chains.

**Parameterization remedies:** center/scale predictors; use an appropriate centered/non-centered form or isolate identifiable functions.

**Sampler remedies:** after excluding structural problems, improve adaptation or increase sampling if stationary exploration remains too imprecise. Longer chains can help a proper unimodal example; they cannot make an improper posterior valid.

**Verify:** repeat all diagnostics, varied starts, target predictions and relevant sensitivities; quantify MCSE rather than assuming warning disappearance is sufficient.

### Low bulk ESS / large MCSE

**Hypotheses:** autocorrelation from correlated geometry, poor adaptation, weak identification, rare mode switching, heavy tails or simply too few draws.

**Discriminate:** check R-hat/traces, divergences/energy, ESS by chain/quantity, pairs and posterior scale. MCSE is uncertainty of a numerical summary, not posterior scientific uncertainty. A mean may not exist for a heavy-tailed quantity even if empirical estimates can be printed.

**Remedies:** correct model/priors if needed; reparameterize geometry; then increase iterations or chains for remaining accuracy. Under stable regular mixing, four times sampling roughly halves MCSE. Define an absolute accuracy relevant to the decision or reported digits; do not require a fixed percentage of posterior SD for every quantity.

**Verify:** estimate MCSE of actual means, quantiles, tail probabilities and derived contrasts; confirm results across runs and no unresolved exploration failures.

### Low tail ESS

**Hypotheses:** tail trapping, funnel/boundary behavior, heavy tails, mode separation or insufficient rare-event draws.

**Discriminate:** inspect tail-specific traces/pairs, rank plots, divergences and `ess_quantile`/`mcse_quantile` at reported probabilities. Bulk ESS cannot substitute.

**Remedies:** address the identified structure/parameterization, then allocate more simulation where an estimable tail summary requires it. For undefined means use scientifically meaningful existing quantiles/functions; do not silently redefine the estimand.

**Verify:** direct accuracy diagnostics for reported endpoints/probabilities and adequate exploration across chains.

### Divergent transitions

**Hypotheses:** sharply varying curvature (funnel), scale near zero, separation, prior-permitted extreme nonlinear regions, redundant parameters or numerical instability. Divergences identify inaccurate numerical trajectories and possible sampling bias; they are not ordinary autocorrelation.

**Discriminate:** mark divergent draws in pairs and transformed/raw coordinates, locate scale/boundary regions, compare centered/non-centered versions, examine prior predictions and log-density evaluation. A broad raw-parameter plot can hide geometry visible in standardized coordinates. No divergence does not imply an absence of geometry problems (park rule).

**Statistical remedies:** remove redundancy; improve identification/priors or observation formulation if scientifically justified. Document that a prior change changes the statistical model.

**Parameterization remedies:** non-center a weakly informed hierarchy; consider centering strongly informed groups; use identifiable nonlinear functions or stable support-respecting transforms.

**Sampler remedies:** only after diagnosis, a higher adapt_delta/smaller step size may resolve mild integration error in an otherwise defensible model. Source problems shows that very high adapt_delta can conceal divergences while mixing/bias remains bad.

**Verify:** aim for no unexplained post-warmup divergences, inspect their locations if any remain, check R-hat/ESS/energy/MCSE and compare substantive quantities under validated alternatives. There is no universally harmless percentage of divergences.

### Maximum treedepth

**Hypotheses:** trajectories need more steps because of correlated/weakly identified geometry, overly small step size, challenging tails or expensive computation.

**Discriminate:** check divergences and other diagnostics first; inspect leapfrog counts, ESS per time, parameter correlations and warmup behavior. Treedepth saturation alone is primarily an efficiency warning; it is not equivalent to divergence bias.

**Remedies:** solve structural/parameterization problems; if exploration otherwise reliable and extra trajectory length is useful, increase maximum depth with a measured cost/benefit. Each increment can substantially increase cost. It can be reasonable to retain an otherwise accurate fit with an explained efficiency limitation.

**Verify:** warning frequency, accuracy and ESS/time; do not keep increasing depth while ignoring the underlying ridge.

### Low BFMI / energy mismatch

**Hypotheses:** momentum resampling poorly traverses the marginal energy distribution, often associated with heavy tails or hierarchical scales.

**Discriminate:** compare marginal energy and energy-transition distributions by chain, BFMI, traces, scale parameters and tails. The common BFMI warning around .3 is a heuristic; examine context rather than declare a universal theorem.

**Remedies:** improve scale priors where justified, transform/reparameterize or revise unstable tails; assess adaptation. More sampling without better exploration may repeat the same limitation.

**Verify:** energy plots/BFMI by chain and the full diagnostic bundle; an adequate energy diagnostic alone says nothing about predictive fit.

### Numerical rejection, overflow or invalid density

**Hypotheses:** wrong support, data sentinel passed as an observation, exponent overflow, near-boundary arithmetic, inconsistent derivatives, solver tolerances or a code bug.

**Discriminate:** reproduce at offending inputs, distinguish transient initialization rejection from recurrent post-warmup evaluation, inspect units and stable functions. For ODEs compare predictions/log density across reasonable solver tolerances and plausible parameter regions.

**Remedies:** declare support correctly, scale predictors, use stable log functions, repair indexing/likelihood; use justified plausible initialization as an aid. Restrict scientific parameter support only when the restriction is defensible.

**Verify:** edge cases, independent likelihood calculations, varied starts, solver stability and recovery. Do not simply hide warnings.

## Avoid false cures

Treat thinning mainly as a storage/diagnostic decision, not a way to manufacture additional information. Never merge chains before chain-sensitive diagnostics. Pathfinder/optimization can help initialize HMC but do not automatically provide reliable final uncertainty or prove all modes found. Distinguish a compile/pedantic pass from successful sampling and a successful sampler from a validated model.

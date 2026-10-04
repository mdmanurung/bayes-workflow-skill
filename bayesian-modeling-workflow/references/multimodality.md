# Investigate modes and initialization

Basis: M01–M03 in [source map](source-map.md).

**Observe:** chains occupy separate regions, chain-specific predictions disagree, apparent parameter jumps occur, or some starts run far slower. Good aggregate R-hat from identical starts cannot exclude a missed mode.

**Possible explanations:** scientific alternative explanations; label symmetry; weak identification/aliasing; an improper tail mistaken for a mode; numerical solver artifacts; tiny local modes or initialization far outside plausible prior mass.

**Discriminate:** inspect traces including warmup separately, joint plots and predictions by chain. Simplify by fixing components to understand low-dimensional slices; evaluate an independent density grid where feasible. In planetary motion, an orbit-strength slice exposes aliases and explains parameter-dependent ODE cost. Check log density/trajectories across solver tolerances. A high-density point or one-dimensional conditional slice does not establish a region's integrated posterior mass.

**Statistical intervention:** remove scientifically irrelevant symmetry with a documented convention, revise invalid support/priors, add credible external information or retain genuinely different explanations. Do not set a hard bound solely to erase unwanted chains or discard valid observations.

**Computational intervention:** use varied plausible initial values, multiple optimization/Pathfinder paths as initialization aids, simpler parameterizations or a more suitable exploration method when true separated modes remain important. Nearby starts may speed computation while also concealing modes; check both risks. Resampled Pathfinder draws can collapse to duplicates and need their own approximation diagnostics; do not treat them as final MCMC uncertainty.

**Validate:** check exploration and predictions across independent runs/starts, compare scientific functions across modes, assess evidence about mode importance and numerical robustness. If the method cannot traverse or weight material modes, report the resulting limitation rather than pool chain lengths as posterior weights. Chain stacking optimizes prediction under conditions; it is not a universal calculation of posterior mode probabilities.

Use [computational diagnostics](computational-diagnostics.md) and [weak-identification playbook](../playbooks/weak-identification.md) when ridges/tails are competing explanations. Genuine modes may be scientifically consequential even if their predictions are similar on the observed design; test target extrapolations separately.

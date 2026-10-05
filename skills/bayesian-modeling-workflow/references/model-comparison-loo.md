# Predictive comparison, PSIS and influence

Basis: L01–L07 in [source map](source-map.md). Model comparison is not a substitute for model checking.

## Define what is being predicted

Specify future measurement in known subject, new subject, new cohort, future time segment, full sequence or censored record. Match splits and likelihood factorization to that task. Ordinary row-wise LOO is not automatically valid for correlated data, outcome-derived histories or held-out latent variables. Training-fold preprocessing, baseline construction and selection must avoid held-out information.

Compute pointwise log predictive densities on the same observations/IDs, probability measure, outcome scale and held-out unit. Continuous density and discrete mass differ. World Cup illustrates integrating probability over rounded bins; nabiximols illustrates changes of outcome scale and response aggregation. Compare exact bin mass or consistently defined densities/transformations, not unmatched reported elpd values. Changing from 4-week to 12-week totals changes the prediction target.

## Interpret elpd and its uncertainty

Expected log predictive density rewards predictions for the chosen task; higher is better on the same target. Examine paired pointwise differences, their distribution and aggregate uncertainty, rather than two marginal scores independently. The usual standard error relies on assumptions about units and the distribution of differences; small samples, skew, heavy tails and influential units can make normal summaries unreliable. Do not turn a multiples-of-SE heuristic into an automatic winner rule.

A near tie means limited evidence of a predictive distinction at that target. It need not mean a scientific effect is absent: observation noise may dominate a small but estimable average effect (nabiximols/roaches). `p_loo` measures predictive effective complexity, not a literal fitted parameter count; unusually high values motivate inspecting flexibility, weak identification or misspecification in context.

## Compute PSIS with sampling uncertainty respected

Use an iterations × chains × units log-likelihood array; preserve chain IDs for `relative_eff`. The required likelihood excludes priors and matches the intended observed unit. Supply `r_eff` rather than assuming independent MCMC draws. Ensure finite/stable evaluations; column-wise likelihood rescaling avoids exponent underflow without altering relative efficiency.

The package's recommended Pareto-k threshold depends on nominal draws: approximately `min(1 - 1/log10(S), .7)` in current loo. This is not a universal fixed .7 law, and nominal draw-based thresholds can be optimistic with low effective sampling. Use supported diagnostics and record the package version; inspect ESS/MCSE as well.

High k indicates heavy importance-weight tails/unstable approximation and often an influential unit or weakly predictive model. It is not automatically a heavy-tailed posterior, bad data or an improper model. Very high k (including k≥1) has serious consequences for the weight distribution, not a license to declare that the posterior mean of every parameter is undefined.

## High-k decision process

**Observe:** identify flagged units, reliability diagnostics, sample size/ESS and MCMC warnings.

**Diagnose:** separate unreliable posterior draws, incorrect factorization/leakage, influential valid observations, model misspecification and observation-specific latent conditioning.

**Discriminate:** inspect raw data/context and targeted PPC, leverage/conditional residuals, pointwise differences, prior sensitivity and alternative observation model. For observation-specific random effects, compare conditional and integrated held-out likelihoods. Validate the most influential case by exact refit where feasible.

**Intervene on approximation:** supported moment matching (requiring appropriate saved parameters), exact leave-one-out refits, suitable K-fold/group/future validation, or marginalization of held-out latent effects. More draws sometimes help a moderate draw-limited problem; they do not generally resolve severe importance tails. Do not switch to WAIC to avoid PSIS warnings.

**Intervene on model:** if evidence supports dispersion, tails, zero structure or prior/measurement revision, fit that scientifically justified alternative and repeat computation/PPC. Moment matching may fix the numerical approximation while leaving the substantive misfit unchanged.

**Validate:** recompute reliability diagnostics, exact/refitted agreement where needed, pointwise predictive changes and relevant PPC. Preserve the identity/influence of originally flagged units: the k used to assess influence can differ from the repaired reliability k.

## Latent integration

For a new held-out observation with its own latent effect, the desired prediction integrates that effect's conditional population distribution. A naive posterior average using the effect learned from the same observation is an in-sample calculation. However, a correctly factorized conditional local-effect likelihood can define exact augmented-space LOO in theory: importance weighting removes that observation's updating of the local effect. The practical problem in roaches is unstable PSIS weights; marginalizing the effect removes that difficult reweighting dimension. Do not label every conditional local-effect LOO intrinsically wrong. Use analytic marginalization, stable quadrature or adequate nested simulation. The roaches example places integration in generated quantities, preserving the fitted posterior while computing the correct predictive quantity. Integrating in the model block also changes computational expense each gradient; distinguish the two purposes.

For an unseen whole group, the joint group likelihood may require integrating a shared effect; merely summing row-wise conditional log likelihoods does not perform that integration. For future sequences use information available at forecast time and the correct sequential distribution. If no safe shortcut is clear, use matching refits.

## Selection and averaging

Check candidate adequacy before interpreting a winner. Early comparisons may screen obviously inferior candidates, but an information criterion cannot establish model truth, causal validity or correct mechanism. Use stacking when combining meaningfully different predictive distributions is useful and diagnostics/held-out task are valid; its weights optimize a predictive objective and are not posterior model probabilities or general mode probabilities. Projection selection uses a checked reference model and validated search path; inspect instability among correlated predictors. Do not select causal adjustment variables solely by predictive score.

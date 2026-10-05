# Validate computation before interpretation

Contents: [prerequisites](#prerequisites-for-all-checks), [R-hat](#r-hat), [ESS](#effective-sample-size), [MCSE](#monte-carlo-standard-error), [chain plots](#trace-and-rank-plots), [divergences](#divergences), [energy](#energy-and-bfmi), [geometry](#geometry-and-reparameterization).

## Prerequisites for all checks

Keep independent chains, post-warmup draws and sampler statistics aligned. Inspect missing/nonfinite draws and constants. Include scientifically relevant transformations/contrasts, hyperparameters and latent quantities implicated by the model. Do not flatten chains until chain-based diagnostics have been computed. Multiple warnings can describe the same geometry failure; interpret them jointly.

R-hat/ESS do not validate a wrong model or a biased variational approximation. For a non-MCMC method, compare to an analytic benchmark or well-diagnosed MCMC on representative cases, use importance diagnostics where appropriate and consider SBC. Confirm which numerical moments actually exist.

Use the [threshold registry](../references/thresholds.md) throughout. Python code below uses ArviZ 1.x; R parameter-level functions take an iteration-by-chain matrix. Detailed object conversion and plotting are in the language guides.

## R-hat

**Question:** Have independent chains explored compatible stationary distributions, including location and scale?

**Prerequisites:** Multiple independently initialized chains; valid post-warmup draws. Rank-normalized split/folded R-hat, not an older unranked statistic. A constant quantity has no informative variance diagnostic.

**Computation:** Python: `az.rhat(dt, method="rank")`; `az.summary(dt, kind="diagnostics")`. R: `posterior::rhat(parameter_matrix)` or `posterior::summarise_draws(draws)`.

**Interpretation:** Values near the registry target support between-chain agreement. Elevated values flag disagreement/nonstationarity, not a unique cause. A low value is compatible with all chains missing the same mode or with geometry problems that other diagnostics detect.

**Likely causes:** Short transient runs; slowly mixing dependent parameters; poor scaling; insufficient adaptation; weak identification/funnels; multimodality or labels; numerical/implementation bugs.

**Do NOT:** Answer “fine” from one R-hat, discard a disagreeing chain, or add iterations as the automatic first remedy.

**Actions:** Inspect warnings and affected chain/rank/trace plots; examine parameter pairs and initialization. If traces are stationary, modes agree, geometry is benign and ESS grows, longer runs can help. If chains drift or stick, rescale/reparameterize or revisit identification/priors/model. Handle genuine multimodality explicitly rather than forcing agreement with a convenient initialization.

**Follow-up:** Refit and repeat R-hat, bulk/tail ESS, estimand MCSE, chain plots and sampler diagnostics; compare scientifically invariant quantities across parameterizations.

**Evidence:** E04 (`direct-eabm`, `eabm-code`); M-RHAT (`method-paper`); R implementation (`translated`); ordered remedies (`synthesized`).

## Effective sample size

**Question:** Is exploration adequate in the posterior regions and quantities used for inference?

**Prerequisites:** Reasonably stationary compatible chains; meaningful target functional. Reliable ESS estimates themselves need sufficient simulation.

**Computation:** Python: `az.ess(dt, method="bulk")`, `az.ess(dt, method="tail")`; use `method="quantile", prob=q` for a specified quantile and `az.plot_ess_evolution(dt)` to inspect growth. R: `ess_bulk`, `ess_tail`, `ess_quantile` through `posterior`, retaining iteration/chain axes.

**Interpretation:** Bulk and tail ESS describe different aspects of exploration. Tail ESS screens interval-endpoint reliability; it is not enough to validate an arbitrarily extreme quantile. The registry floor is a screen, not a universal precision guarantee. Negative autocorrelation can produce ESS exceeding nominal draws.

**Likely causes:** Short runs with ordinary autocorrelation; long-range sticking/drift; posterior dependence or extreme curvature; badly explored tails; nearly redundant parameters.

**Do NOT:** Substitute nominal draws for ESS, use only bulk ESS for interval claims, or thin the stored sample to pretend exploration improved.

**Actions:** Inspect local/quantile ESS and evolution for the relevant quantities. With stationary linear ESS growth and no geometry warning, increase draws to the required MCSE. With flat/poor growth, fix the cause rather than extrapolating a huge run. Compare efficiency per time only after validity.

**Follow-up:** Repeat full computational checks; verify numerical stability of reported intervals, contrasts and probabilities.

**Evidence:** E04 (`direct-eabm`, `eabm-code`); M-RHAT (`method-paper`); R route (`translated`).

## Monte Carlo standard error

**Question:** Is simulation error small enough for the scientific estimate, decision and displayed precision?

**Prerequisites:** Adequate sampling and an estimand with suitable moments. A heavy-tailed posterior may not have the mean/variance being reported. Numerical stability of a sample mean alone cannot establish finite population moments.

**Computation:** Python: `az.mcse(dt, method="mean")`; for endpoints use `method="quantile", prob=q`. R: `posterior::mcse_mean(parameter_matrix)` and `mcse_quantile(parameter_matrix, probs=...)`. Create draws of a derived estimand first, then diagnose that estimand.

**Interpretation:** MCSE is numerical uncertainty, not posterior uncertainty. Set an estimand-specific tolerance in its scientific units. Interval precision requires endpoint MCSE; the MCSE of a coefficient mean does not validate a rare tail probability or nonlinear contrast.

**Likely causes:** Too few effective draws; tail instability; an invalid moment estimand; unstable derived calculations.

**Do NOT:** Use a universal MCSE percentage, report excessive digits, or describe changes smaller than numerical uncertainty as sensitivity evidence. For independent refits compare the difference to the combined MCSE; shared importance draws require attention to their covariance.

**Actions:** Choose a valid quantity/tolerance; calculate its MCSE. Increase draws only when geometry and stationarity are adequate. If moments are inappropriate, report valid quantiles/robust estimands or revise the intended model/estimand transparently.

**Follow-up:** Recompute the reported quantity and its numerical uncertainty; repeat other diagnostics after any refit.

**Evidence:** E04 (`direct-eabm`); M-RHAT (`method-paper`); tolerance/difference handling (`synthesized`); R route (`translated`).

## Trace and rank plots

**Question:** Is there drift, sticking, unequal exploration or hidden chain disagreement that numerical summaries obscure?

**Prerequisites:** Preserve chains and iteration order. Rank histograms/ECDFs use pooled ranks assigned back to chains; they are not SBC ranks. Envelopes require their implementation's autocorrelation handling.

**Computation:** Python: `az.plot_trace_dist(dt)` and `az.plot_rank(dt)`; R: `bayesplot::mcmc_trace(draws)`, `mcmc_rank_overlay(draws)` or `mcmc_rank_ecdf(draws, plot_diff=TRUE)`.

**Interpretation:** Compatible chain rank distributions and stationary traces support exploration. Trends, separated levels, long sticky stretches or uneven rank occupation identify a problem. Ordinary MCMC autocorrelation is expected; “looks noisy” is not a proof of independent samples.

**Likely causes:** Initialization/adaptation issues; slow mixing; modes/funnels; chain-specific numerical failures. Histograms can depend on binning; KDE overlap may hide time-ordered sticking.

**Do NOT:** Require completely uncorrelated traces, remove inconvenient segments after looking, or treat an envelope crossing as an independently calibrated scientific hypothesis test.

**Actions:** Inspect problematic variables and their transformations alongside ESS evolution and divergence-marked geometry. Use diagnostic thinning only when its reference distribution warrants it, while retaining full draws for estimation. Prefer interpretable small plot subsets over unreadable arrays of every parameter.

**Follow-up:** After intervention repeat numerical summaries and inspect the previously problematic traces/ranks.

**Evidence:** E04 (`direct-eabm`, `eabm-code`); M-RHAT, M-ECDF (`method-paper`); R route (`translated`); exact envelope parity is partial.

## Divergences

**Question:** Does HMC fail to resolve posterior neighborhoods accurately?

**Prerequisites:** HMC/NUTS, post-adaptation sampler flags aligned with the parameter draws. Locate failures by chain and affected neighborhoods; counts do not quantify bias.

**Computation:** Python: count `dt.sample_stats["diverging"]` by chain; `az.plot_pair(dt, var_names=..., visuals={"divergence": True})`. R: `fit$diagnostic_summary()`; `bayesplot::mcmc_pairs(draws, np=nuts_params)` with aligned sampler statistics.

**Interpretation:** Divergences warn of potential biased exploration. Even a small number can concentrate in an important region. No divergences does not establish good mixing. Nondivergent draws alone are not a valid “cleaned” posterior.

**Likely causes:** Funnels, scale near a boundary, poorly scaled covariates/parameters, nonlinear curvature, strong dependence, heavy tails, redundant parameter combinations or incorrect constraints.

**Do NOT:** Assume more draws solve the problem, discard divergent draws, or prescribe an extreme `adapt_delta`/`target_accept` from the count alone.

**Actions:** Inspect marked pairs (including log scales) and model structure; verify units and support. Rescale while preserving the induced model, then consider a scientifically equivalent noncentered/centered/partial parameterization. A bounded acceptance-target increase and adequate warmup may resolve mild numerical discretization after this inspection. Persistent or localized problems require structural/identification review and justified priors; lowering efficiency indefinitely is not a remedy.

**Follow-up:** Refit; repeat all computational diagnostics, compare target estimands across equivalent parameterizations, and repeat prior/PPC checks if priors or likelihood changed. If failures persist, do not make definitive posterior claims.

**Evidence:** E04 (`direct-eabm`, with source-prose correction recorded); M-ENERGY and D-STAN-REPARAM; action order (`synthesized`).

## Energy and BFMI

**Question:** Can HMC momentum updates traverse the marginal energy distribution effectively?

**Prerequisites:** Post-warmup Hamiltonian energy by chain. These diagnostics do not apply to Metropolis, SMC or variational draws without an HMC energy process.

**Computation:** Python: `az.plot_energy(dt)` and `az.bfmi(dt)`. R: `bayesplot::mcmc_nuts_energy(nuts_params, merge_chains=FALSE)` and CmdStanR's per-chain `fit$diagnostic_summary()`; use the direct BFMI formula if needed in the R recipe.

**Interpretation:** Compare centered marginal energy with successive energy differences. Strong mismatch or registry-low BFMI suggests poor energy exploration. An aggregate across chains can hide a bad chain. BFMI is a screening heuristic, not an exact pass/fail theorem.

**Likely causes:** Heavy-tailed targets, hierarchical funnels, poorly scaled/weakly identified parameters, adaptation that cannot accommodate local curvature.

**Do NOT:** Confuse BFMI with ESS/R-hat, increase iterations without examining geometry, or average away a problematic chain.

**Actions:** Inspect energy by chain and divergence-marked pairs; identify heavy tails/hierarchical scales. Consider equivalent parameterization and justified scale priors; inspect sampler adaptation. Fix meaningful model problems rather than truncating tails just to improve the metric.

**Follow-up:** Repeat energy/BFMI, divergences, chain diagnostics and estimand MCSE after refitting.

**Evidence:** E04 energy plots (`eabm-code`); M-ENERGY (`method-paper`); D-AZ-PLOTS/D-STAN (official documentation; registry threshold type `package-warning`); R (`translated`).

## Geometry and reparameterization

**Question:** Is a posterior ridge/funnel a computational coordinate issue or a lack of scientific information?

**Prerequisites:** Understand the generative hierarchy, constraints, priors and information per group. Pair plots identify hypotheses, not proofs of identification.

**Computation:** Python/R: compare parameter pairs, scale transformations, prior versus posterior, and fits to simulated data. For a normal hierarchy compare `theta = mu + tau*z`, `z ~ normal(0,1)`, with the equivalent centered specification. Preserve the same prior on theta/tau.

**Interpretation:** Noncentering often helps weakly informed group effects/funnels; centering can work better when effects are strongly informed. Equivalent parameterizations may have different numerical efficiency but should agree on valid scientific posterior quantities. Weak identification can remain even after a fast fit.

**Likely causes:** Redundant intercepts, confounded random effects/slopes, sparse groups, broad scale priors, mixture symmetries, outcome/predictor scaling.

**Do NOT:** Interpret a convenient coordinate change as new scientific evidence, treat all hierarchical models as requiring noncentering, or identify a parameter solely by stronger priors chosen from its desired posterior result.

**Actions:** Check algebra and Jacobians; simplify a small simulated model; rescale/reparameterize; separate estimable combinations from weakly identified components. If the question itself cannot be identified by the design, report that or revise the estimand. Use justified regularization and SBC when implementation accuracy is uncertain.

**Follow-up:** Computational checks plus prior predictions/sensitivity of scientifically meaningful quantities; SBC or analytic benchmarks for changed custom code.

**Evidence:** E04/E15 (`direct-eabm`); D-STAN-REPARAM (`official documentation`); combined diagnosis (`synthesized`). Source definitions: [bibliography](../references/bibliography.md).

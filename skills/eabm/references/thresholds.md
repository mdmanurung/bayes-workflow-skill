# Threshold registry

Use [thresholds.json](thresholds.json) for executable values. These are screening aids, not sufficient conditions for correctness. Values in examples for draws, seeds and interval probabilities are demonstration settings, not diagnostic cutoffs.

| Diagnostic | Threshold | Meaning | Source | Type | Context | Exceptions |
|---|---|---|---|---|---|---|
| Rank-normalized split/folded R-hat | Below 1.01 | Chains show no detected location/scale discrepancy | E04; M-RHAT | empirical-guideline | Final inference; inspect all relevant parameters and derived estimands | Constant/deterministic values can produce undefined diagnostics; explain rather than substituting a pass. EABM tolerates rough early fits; this is not permission to report them. |
| Independent chains | At least 4 recommended | Enables useful between-chain checks | M-RHAT | empirical-guideline | MCMC; dispersed valid initializations | Fewer may be constrained by cost; report limits. Approximate methods do not become validated through artificial chains. |
| Bulk/tail ESS | Total screening floor = 100 × chains | Basic diagnostic reliability and central/tail exploration | E04; M-RHAT | empirical-guideline | Total pooled ESS, not a claim that each chain meets an individual ESS bound | Not enough for every mean, rare event or extreme quantile; use actual estimand MCSE. Antithetic draws can have ESS above nominal draws. |
| MCSE | No universal percentage | Numerical error must be negligible for the scientific decision/reporting precision | E04; M-RHAT | rule-of-thumb | Compare mean/quantile MCSE with an explicitly stated tolerance and posterior uncertainty | Infinite/unstable moments make a mean/SD/MCSE target inappropriate; use valid quantiles or revise the intended estimand. |
| Post-warmup divergences | 0 | Avoid detected HMC trajectory failures | D-STAN; E04 | empirical-guideline | Count and locate by chain/geometry | Absence does not prove mixing; even a few can matter. A count alone does not quantify posterior bias. |
| BFMI | Below 0.3, by chain | Energy transitions explore marginal energy poorly | D-AZ-PLOTS; D-STAN; M-ENERGY | package-warning | HMC energy available; align post-warmup draws | Empirical indicator; inspect plots/geometry even above the warning boundary. Not a mixing diagnostic for arbitrary algorithms. |
| Pareto-k | min(1 − 1/log10(S), 0.7) | Reliability of PSIS approximation | M-PSIS; D-LOO-K | empirical-guideline | Use nominal S as package does; poor ESS makes this optimistic | An estimated k above the moment boundary indicates no finite mean of raw importance ratios under the fitted tail model. Larger S is useful near a boundary; not a reliable cure for very high k. |
| Power-scaling sensitivity | CJS gradient > 0.05; local α = 0.99, 1.01 | Prior-sensitive + likelihood-sensitive → potential conflict; prior-sensitive + low likelihood sensitivity → strong prior/weak likelihood | E06; M-SENSE; D-AZ-SENSE; D-PRIORSENSE | empirical-guideline | Depends on selected component, parameterization, estimand and validated PSIS weights | Intended informative priors may correctly influence inference. Low scores do not establish global robustness; constant uniform densities are insensitive to powering. |
| Power-scaling plot alphas | α = 0.8, 1, 1.25 | Visualize broader perturbations and MCSE | E06 | rule-of-thumb | Check PSIS reliability for every alpha, not just the local gradient pair | Broad changes can leave posterior support; refit. Never assume local validity ensures wide-range validity. |
| Small ELPD difference | Total absolute ELPD difference < 4 | Descriptive warning against overinterpreting tiny score differences | E07 | rule-of-thumb | Total natural-log ELPD on a stated common target | Not invariant to N, score scale or utility. No universal ELPD/SE cutoff proves scientific superiority. |
| Large-data starting subsample | 100 units as an illustrative pilot | Start cheap, then increase by comparison precision | E08; M-LARGE | rule-of-thumb | Common random units across models; valid cheap surrogate | Rare influential groups/dependence require a justified design; separate subsampling SE from sampling uncertainty. |

## Formula and uncertainty cautions

For PSIS use the package's threshold/diagnostic functions, not a handwritten replacement whenever possible. If evaluating the registry formula, require S > 1 and use base-10 logarithms. Model-comparison standard errors describe uncertainty in predictive accuracy across evaluation units; MCSE describes numerical approximation. Subsampling adds a third uncertainty component. Do not interchange them.

No numerical threshold authorizes ignoring model adequacy or scientific target mismatch. Sample-size-dependent warnings and printed columns can change with package versions; inspect the installed contract and record it. Source URLs are in [bibliography.md](bibliography.md).

## Package-specific comparison/repair controls

| Diagnostic | Threshold | Meaning | Source | Type | Context / exceptions |
|---|---|---|---|---|---|
| Comparison small N | N < 100 | Current package flag for normal-approximation caution | D-AZ; D-LOO-COMPARE | package-warning | Does not prohibit comparison; inspect difference shape/dependence and practical utility |
| priorsense MM trigger | default k=0.5 | Sensitivity algorithm repair trigger | D-PRIORSENSE | package-warning | Not a general IS trust cutoff; adapter/version defaults may differ |
| Pareto raw-weight moment | k ≥ 1 | Tail model lacks a finite first raw-weight moment | M-PSIS | theoretical | Estimated k is uncertain; concerns importance ratios, not posterior parameter moments. Do not trust this PSIS approximation. |

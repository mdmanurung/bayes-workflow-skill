# Assess sensitivity of scientific conclusions

Contents: [refitting](#refitting-under-alternative-priors-or-likelihoods), [power scaling](#power-scaling), [interpretation](#interpret-results-jointly), [validity](#approximation-and-density-validity), [record](#report-the-sensitivity-result).

## Refitting under alternative priors or likelihoods

**Question:** Would defensible alternative assumptions change the relevant estimates, uncertainty or decisions?

**Prerequisites:** Adequately fitted base model; stated scientific estimands and plausible alternatives. Distinguish changing a prior from changing likelihood tails, dispersion, link, dependence or observation process. Compare the same scientific quantity even when model parameters differ.

**Computation:** Python: rebuild/refit PyMC/Bambi models with explicit alternatives, then extract the same contrasts/predictions. R: `update` a brms fit with explicit priors/family, or refit a CmdStan model. Plot matched quantiles/intervals and report numerical differences with MCSE.

**Interpretation:** The conclusion can be robust while nuisance parameters change, or fragile despite similar generic PPCs. A practically important change matters more than arbitrary threshold crossing. If a difference is comparable to simulation error, it is unresolved rather than demonstrated robustness/sensitivity.

**Likely causes:** Weak likelihood information; unintended default-prior strength/units; genuine prior-data conflict; influential tails; nonidentification; different models addressing different quantities.

**Do NOT:** Repeatedly edit priors to remove warnings, pick an alternative because it gives a preferred answer, or call a power-scaled likelihood a validated alternative likelihood family.

**Actions:** Check alternative prior predictions; validate every fit; compare scientific estimands and failed PPC features. Use a stronger prior only when its information/regularization and induced predictions are justified. If likelihood information is weak, report the dependence on prior knowledge rather than implying computation produced additional data information.

**Follow-up:** Computational checks, original PPC failures, scientific contrasts and relevant comparison target for every refit. Record the alternatives and rationale.

**Evidence:** E06 (`direct-eabm`); M-SENSE (`method-paper`); R (`translated`); MCSE/refit ordering (`synthesized`).

## Power scaling

**Question:** How sensitive is the posterior to local changes in the relative strength of a specified prior or likelihood component?

**Prerequisites:** Adequate base draws; correctly evaluated selected log-prior/log-likelihood at the same draws; target components/measure defined; importance overlap and precision validated.

**Computation:** For selected component C(theta), the perturbed posterior uses C(theta)^alpha and log importance ratios `(alpha - 1) * log C(theta)`. Python: `az.psense_summary(dt, prior_var_names=..., likelihood_var_names=...)`; `az.plot_psense_dist` and `az.plot_psense_quantities`. R: `priorsense::powerscale_sensitivity`, `powerscale`, `powerscale_sequence` and plots, with explicit selections. Check PSIS Pareto diagnostics for every used alpha; the language guides provide this gate.

**Interpretation:** The numerical screen is a CJS-based local sensitivity derivative near alpha=1, **not raw CJS distance**. Interpret prior and likelihood scores together and inspect direction/size of changes for the scientific quantity. A local derivative does not demonstrate robustness to a different prior family, support or likelihood.

**Likely causes:** Intended informative prior; overly restrictive/diffuse priors relative to data; weakly informative likelihood; unit/scaling differences; hierarchical component choices; importance-sampling failure.

**Do NOT:** Treat diagnostic labels as proven conflict, assume importance weights are reliable because the summary ran, or read a low prior score as evidence that every possible prior is innocuous.

**Actions:** Select the intended component; validate density decomposition and importance sampling. Inspect distribution/quantity curves against MCSE. Localize sensitivity; corroborate important findings with justified refits, especially outside the local perturbation range. Use moment matching only if supported and diagnostically successful; otherwise refit.

**Follow-up:** Repeat approximation diagnostics for new alpha/components and computational/PPC checks for any actual model revision.

**Evidence:** E06 (`direct-eabm`, `eabm-code`); M-SENSE/M-PSIS (`method-paper`); R (`translated`); explicit approximation gate (`synthesized` from methods).

## Interpret results jointly

| Prior sensitivity | Likelihood sensitivity | Interpretation to investigate | Next check |
|---|---|---|---|
| Above registry screen | Above registry screen | Potential prior-data conflict; both components influence the quantity | Inspect direction of shifts and substantive prior predictive mismatch; refit defensible alternatives |
| Above | Below | Strong prior and/or weak/noninformative likelihood | Compare prior/posterior; inspect identification and intended prior information |
| Below | Above | Data-responsive posterior for this quantity/component | Assess practical likelihood alternatives; this is not a likelihood-family adequacy test |
| Below | Below | Locally insensitive quantity or uninformative powering direction | Confirm densities, selected component, uniform priors and numerical precision; assess broader alternatives if relevant |

An intended informative prior can legitimately produce the first two patterns. “Potential conflict” does not mean automatically weakening the prior. Two models can yield similar conclusions but different sensitive nuisance marginals.

## Approximation and density validity

1. Match log densities to draws and transformations. Do not use sampler `lp__` as log prior: it contains likelihood, priors and possibly Jacobians. Use the prior factor being perturbed on a specified parameter scale; a change of coordinates can change what powering means. For importance-sampling densities/callbacks involving unconstrained coordinates, handle Jacobians consistently.
2. Confirm finite/proper perturbed targets for the chosen alpha range. A uniform/constant prior factor does not respond to exponentiation; powering cannot explore alternative support. Local importance sampling cannot discover regions absent from the base posterior.
3. Check smoothed weight tails, effective importance sample size and numerical precision. Use the PSIS diagnostic for the alpha-specific weights; sensitivity summary tables may not expose this gate automatically. Highly concentrated weights make curves/gradients unreliable even when the base MCMC is good.
4. For hierarchical models, state whether the question changes hyperpriors, population/group distributions, or all components. EABM's bacteria example powers **top-level priors** and excludes the conditional group-effect prior. Follow that example for hyperprior sensitivity; other perturbations are legitimate different questions and must be labeled.
5. Power scaling changes relative strength, not the generative model family. A Student-t versus Normal comparison requires actual refits and matched scientific quantities, PPCs and scoring scale.

## Report the sensitivity result

Record the base model, selected factors/parameter measure, alternative assumptions or alpha range, importance diagnostics, quantities/MCSE, practical changes, corroborating refits and decision. Report meaningful sensitivity that remains; document why an informative prior was retained when warnings were expected.

Sources: [bibliography](../references/bibliography.md). The source-ledger corrections prevent attributing synthesized approximation safeguards or R APIs to EABM prose.

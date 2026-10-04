# EABM forward diagnostic validation transcript

Date: 2026-10-04. Skill used: `/root/.codex/skills/remote-skills/eabm/SKILL.md`. The skill was read and left unchanged. These are reasoning responses to the supplied questions, not diagnoses of an inspected fitted model. Unprovided artifacts remain unknown. R is the provisional implementation branch because the questions use `adapt_delta`; no R or Python calculation is needed for these answers.

Supporting resources read: the diagnostics, failure-taxonomy, anti-patterns, model-comparison, predictive-checking, sensitivity and prior-elicitation guides; the corresponding four R implementation guides; the threshold registry in Markdown and JSON; the bibliography, evidence matrix and decision-tree overview. The linked EABM chapters and official Stan/loo documentation were also checked. Numerical thresholds below are screening guidance from the registry, not sufficient conditions for correctness. The order of checks and conditional actions is a **synthesized** workflow; the book reasoning is **direct-eabm**, method results are **method-paper**, and the R recipes are **translated**. No package API or sampler was executed.

## 1. “My R-hat is 1.005. Is the model fine?”

**Answer:** It passes one convergence screen if this is modern rank-normalized split/folded R-hat, but it does not establish that the model is fine.

**Current gate and reasoning:** Computation remains incompletely assessed. A value of 1.005 is below the recommended 1.01 bound and supports agreement among chains for the quantity diagnosed. We do not know whether this is one parameter or the maximum across relevant parameters and derived estimands, whether independent chains were retained, or whether ESS, MCSE and sampler warnings are satisfactory. All chains can miss the same mode; good chain agreement also cannot establish likelihood adequacy or scientific identification.

**Next check and why:** Inspect the complete post-warmup summary and sampler warnings, with bulk/tail ESS and MCSE for the actual scientific estimates and interval endpoints. Inspect rank/trace plots for relevant parameters and transformations. This distinguishes an adequately explored fit from stationary but imprecise sampling, chain sticking or geometry problems concealed by a single number. A screening ESS floor is 100 times the number of chains in total, not a universal precision guarantee or an individual-chain assertion.

**Conditional action:** If chains are stationary, warnings are absent and ESS grows with computation, add draws only if the estimand MCSE is too large for the decision. If chains drift or stick, or HMC warnings appear, investigate geometry, scaling, initialization and identification before extending the run. If computation is adequate, proceed to targeted PPCs, sensitivity and the scientific question.

**Follow-up:** After any refit, repeat R-hat, bulk/tail and relevant quantile ESS, estimand-specific MCSE, chain plots and sampler diagnostics. A single R-hat cannot authorize substantive conclusions.

**Sources/provenance:** E04, [EABM MCMC diagnostics](https://arviz-devs.github.io/EABM/Chapters/MCMC_diagnostics.html) (**direct-eabm**); M-RHAT, [Vehtari et al. (2021)](https://doi.org/10.1214/20-BA1221) (**method-paper**); [Stan diagnostic guidance](https://mc-stan.org/learn-stan/diagnostics-warnings.html) (official diagnostic guidance). Check ordering is **synthesized**.

## 2. “I have 14 divergences. Can I set adapt_delta to 0.999?”

**Answer:** That setting is possible, but the count alone does not justify it. First determine whether the divergences occur after warmup and where they occur.

**Current gate and reasoning:** If these are post-warmup HMC divergences, computational validity is unresolved. Fourteen failures can be concentrated in an important posterior neighborhood; neither the count nor the percentage quantifies the resulting bias. Increasing acceptance shrinks step sizes and may help a mild discretization problem, but an extreme setting can consume time and hit treedepth limits while leaving the underlying geometry unresolved.

**Next check and why:** Locate divergences by chain in parameter pairs, including log scales for positive parameters, and inspect energy/BFMI, treedepth and model structure. Verify support, units and scaling. Look for funnels, boundary scales, nonlinear curvature, strong dependence or weakly identified combinations. These checks distinguish a coordinate problem from a substantive information or model problem.

**Conditional action:** Correct implementation or scaling errors first. For a funnel or dependence problem, try a scientifically equivalent centered, noncentered or partial parameterization that preserves the intended prior; noncentering is not universally preferable. If the inspected model is otherwise sound and the remaining failure appears numerical, a bounded increase in acceptance and adequate warmup is a justified experiment. Do not jump automatically to 0.999. Persistent localized failures require an identification/model review and scientifically justified regularization, not indefinite tuning. Do not remove divergent draws.

**Follow-up:** Refit and recheck divergences, per-chain energy/BFMI, R-hat, ESS, MCSE and previously problematic plots. Compare scientific quantities across equivalent parameterizations. If priors or likelihood changed, repeat prior predictions, PPCs and sensitivity. With unresolved failures, avoid definitive posterior claims.

**Sources/provenance:** E04 (**direct-eabm**, subject to the skill's recorded source correction); [Stan warnings](https://mc-stan.org/learn-stan/diagnostics-warnings.html) and [efficiency/reparameterization guidance](https://mc-stan.org/docs/stan-users-guide/efficiency-tuning.html) (official guidance); M-ENERGY, [Betancourt (2016)](https://arxiv.org/abs/1604.00695) (**method-paper**). Ordered remedies are **synthesized**.

## 3. “Which model should I choose from this LOO table? A elpd=-510, B elpd=-507, paired SE difference=4.8. The table contains no other diagnostics.”

**Answer:** The table does not support a definitive choice. B has the larger point estimate by 3 ELPD units, but the paired SE is 4.8 and reliability is unreported.

**Current gate and reasoning:** The comparison target, computational validity and PSIS reliability are unknown. Arithmetic gives `ELPD_B − ELPD_A = 3`; this is only 0.625 times the stated paired SE. Even if the estimates are reliable, that is weak evidence for a useful predictive preference. The SE is uncertainty in the paired predictive difference, not the Monte Carlo error of its computation or a posterior model probability. Do not invent a calibrated normal interval/probability without checking evaluation size, dependence and the shape of the unitwise differences.

**Next check and why:** First establish that both models score the same observed responses, scale, held-out units and available training information using complete likelihood contributions. Obtain sampling diagnostics, candidate PPCs and pointwise LOO/Pareto-k diagnostics for both models. Then inspect which units produce the difference and whether grouping/time dependence requires different folds. A missing warning column is missing evidence, not a pass.

**Conditional action:** Repair unreliable LOO estimates or use target-matched explicit CV before choosing. If reliable scores still leave this difference practically unresolved and both candidates are adequate, prefer the simpler or more scientifically suitable candidate; the table does not tell us whether that is A or B. Prefer B only if its reliable predictive gains and practical benefits justify the choice. Consider stacking only if a predictive mixture serves the goal and pointwise inputs establish useful complementarity; these totals cannot determine its weights.

**Follow-up:** Recompute the paired difference and its uncertainty after repair, inspect influential units and check adequacy for the chosen model or mixture. Document the target and the unresolved selection uncertainty.

**Sources/provenance:** E07, [EABM model comparison](https://arviz-devs.github.io/EABM/Chapters/Model_comparison.html) (**direct-eabm**); [loo_compare documentation](https://mc-stan.org/loo/reference/loo_compare.html) (official paired-SE contract); M-LOO, [Vehtari et al. (2017)](https://doi.org/10.1007/s11222-016-9696-4) (**method-paper**). Decision routing is **synthesized**.

## 4. “Pareto-k is 1.2 for two observations. Can I ignore them?”

**Answer:** No. Keep valid observations and repair their unreliable LOO estimates.

**Current gate and reasoning:** PSIS-LOO reliability fails for those units. An estimated k of 1.2 exceeds the k=1 moment boundary: the fitted importance-ratio tail indicates failure of the usual finite-mean behavior. This concerns the importance ratios, not a claim that the scientific parameter's posterior mean is infinite. The two observations can materially affect the total ELPD or its difference even if most units have good k. High k alone does not prove outliers, bad data or model misspecification.

**Next check and why:** Identify those observations and inspect data validity, likelihood normalization/alignment, posterior computation, sparse-group structure and their scientific context. Use targeted PPCs and influence checks. This distinguishes a coding/data error, an inappropriate holdout target, model misspecification and an otherwise valid but difficult importance approximation.

**Conditional action:** Correct verified errors. For valid units and an appropriate target, use supported moment matching if the fitted model has the required saved parameters/density support, and recheck k. If it remains unreliable, explicitly refit the two leave-out posteriors or use appropriate K-fold/group/time CV. More draws alone is not a reliable remedy at k=1.2. A more robust likelihood is a separate model change requiring substantive justification. Exact LOO temporarily omits the scored unit for evaluation; it does not justify removing valid data from the final model.

**Follow-up:** Validate each refit or repaired approximation, recompute pointwise contributions and aggregate uncertainty, and rerun influential-unit PPCs. Moment matching repairs an estimator; it does not repair the model. Disclose any approximation still unresolved.

**Sources/provenance:** E07/E09 (**direct-eabm**); [loo Pareto-k diagnostics](https://mc-stan.org/loo/reference/pareto-k-diagnostic.html) (official guidance); M-PSIS, [Vehtari et al. (2024)](https://jmlr.org/papers/v25/19-556.html), and M-MM, [Paananen et al. (2021)](https://doi.org/10.1007/s11222-020-09982-2) (**method-paper**). Action ordering is **synthesized**.

## 5. “My PPC looks good. Are we done?”

**Answer:** A good PPC supports the checked feature at the replicated design. Completion also depends on computation, targeted criticism, sensitivity and the intended scientific use.

**Current gate and reasoning:** The scope and power of the PPC are unknown. A pooled density or mean check can look reassuring while missing tail behavior, variance, subgroup failures or dependence; some fitted statistics agree almost automatically. A PPC also cannot validate sampling accuracy or causal identification.

**Next check and why:** State the estimand or decision and the plausible failures that would undermine it. Confirm that the PPC uses replicated observations including outcome noise and the actual observation process, rather than expected responses. Then choose checks for the relevant tails, spread, groups, time/dependence or censoring, using conditional existing-group or fresh-group replication as appropriate. Review computational diagnostics and sensitivity of the reported scientific quantity to defensible assumptions.

**Conditional action:** If a targeted discrepancy appears, check alignment/data and distinguish its possible mechanisms, then revise the smallest justified component. If computation, purpose-matched PPCs and meaningful sensitivity are satisfactory and the design supports the claim, the analysis may be adequate for that use. Perform predictive comparison only if it helps the decision; it is not an obligatory completion ritual.

**Follow-up:** After revision, validate the fit and repeat the failed check plus features the revision could harm. Report estimands, uncertainty, remaining limitations and reproducible materials. Adequacy for a stated purpose remains a limited claim, not proof of correctness.

**Sources/provenance:** E05, [EABM predictive checks](https://arviz-devs.github.io/EABM/Chapters/Prior_posterior_predictive_checks.html), and E15, [Bayesian workflow](https://arviz-devs.github.io/EABM/Chapters/Bayesian_workflow.html) (**direct-eabm**); M-VIS, [Gabry et al. (2019)](https://doi.org/10.1111/rssa.12378) (**method-paper**). Extended dependence checks and completion routing are **synthesized**.

## 6. “Can I compare Gaussian and Student-t likelihoods with LOO?”

**Answer:** Yes, when they address the same continuous observed outcome and the same prediction task.

**Current gate and reasoning:** Different likelihood families do not prevent comparison. Their complete predictive densities are comparable when evaluated relative to the same outcome measure. We have not established a common response scale, holdout scheme or reliability for these particular fits. The Student-t scale parameter is not generally its standard deviation, so scientific quantities and prior implications should also be matched deliberately.

**Next check and why:** Audit a few normalized pointwise log-density evaluations against the observed data, preserving aligned observation IDs. Include all family-specific normalization terms and exclude priors. If a model was fitted to a transformed outcome such as log(y), include its Jacobian when scoring on y. Specify whether the target is a new observation in an existing group, a new group or a future time point; use the corresponding held-out unit and information set.

**Conditional action:** If targets or scales differ, reconstruct matched observed-scale scores or evaluate the tasks separately. If the targets match and computation is adequate, obtain pointwise LOO and Pareto-k diagnostics for each fit, repair failures, inspect paired ELPD uncertainty and perform tail/influential-unit PPCs. Select or average only after adequacy and practical predictive consequences are assessed. Heavy-tail flexibility alone does not establish superiority.

**Follow-up:** Recheck sampling, scoring reliability, targeted PPCs and the sensitivity of the same scientific estimands. If new-group/time prediction is the goal, verify the explicit folds avoid learning from held-out group effects or future information.

**Sources/provenance:** E07, especially its Normal-versus-Student-t example and likelihood-comparability section, [EABM model comparison](https://arviz-devs.github.io/EABM/Chapters/Model_comparison.html) (**direct-eabm/eabm-code**); M-LOO (**method-paper**). Target preflight is **synthesized**; R implementation is **translated**.

## 7. “Should I use a stronger prior?”

**Answer:** Possibly, if the additional information or regularization is defensible on the scientific scale. There is no universal recommendation to tighten a prior.

**Current gate and reasoning:** The current prior, intended estimand and reason for changing it are unknown. A stronger prior can regularize weak information or exclude scientifically implausible predictions, but it changes the model and may aggravate prior-data conflict. Computational geometry, weak identification, likelihood misspecification and unintended prior implications require different remedies. Informative priors can appropriately affect inference; a sensitivity label is not proof of error.

**Next check and why:** Inspect prior predictions and prior/posterior distributions for the actual scientific quantity, verifying outcome/predictor units and joint hierarchical implications. Identify a defensible source of effect sizes, quantiles, group variation or outcome risks. Compare conclusions under a few justified alternatives. If local power scaling helps locate sensitivity, specify the perturbed prior/likelihood components and validate importance diagnostics at every alpha; its local derivative cannot assess a different prior family or support.

**Conditional action:** For implausibly diffuse induced predictions and justified domain information, revise the relevant prior component and resimulate. For a geometry issue, first consider an equivalent parameterization. For suspected conflict or misspecification, investigate which assumption fails before tightening. With weak likelihood information, use defensible priors and report how conclusions depend on them; a tighter prior does not make the data more informative. Do not select a prior merely because it removes a warning or produces a preferred answer.

**Follow-up:** Refit each substantive alternative, validate its computation and repeat prior predictions, PPCs and matched scientific summaries. Compare changes with their numerical uncertainty and corroborate consequential importance-based sensitivity by refitting. Record the prior's information source, induced predictions, rationale and remaining sensitivity.

**Sources/provenance:** E05/E06/E12, [EABM sensitivity checks](https://arviz-devs.github.io/EABM/Chapters/Sensitivity_checks.html) and [prior elicitation](https://arviz-devs.github.io/EABM/Chapters/Prior_elicitation.html) (**direct-eabm**); M-SENSE, [Kallioinen et al. (2024)](https://doi.org/10.1007/s11222-023-10366-5) (**method-paper**). Stronger-prior routing and the explicit approximation gate are **synthesized**.

## Validation limits

This transcript checks reasoning against the supplied evidence. It does not establish that a particular fit has passed any missing diagnostic, compute model-specific likelihoods, run moment matching/refits, or verify an installed R backend. No fitted object, posterior draw array, sampler-statistics array, pointwise likelihood or substantive design information was supplied. No skill files were modified.

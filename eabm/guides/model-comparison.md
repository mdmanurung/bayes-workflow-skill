# Compare predictions for a defined task

Read this guide before interpreting a LOO table. **Model criticism** asks how a model fails; **model comparison** estimates relative predictive performance for a specified task. The best candidate may still be inadequate.

## Define the predictive target and pointwise likelihood

**Question:** What will be predicted, using what training information, and for which population or time horizon?

**Prerequisites:** Candidates address the same outcome, held-out units, information set and scoring measure; their computation is adequate. Establish unit IDs, dependence, observation process and any transformations before constructing log likelihoods.

**Computation:** Python: labeled `log_likelihood` DataTree datasets; specify `var_name` in ArviZ. R: an iteration × chain × held-out-unit array for `loo`, or a verified brms adapter. For conditionally independent observations, evaluate the complete normalized likelihood at every posterior draw. For joint units, sum the appropriate conditional log factors before PSIS. Preserve IDs and chain axes.

**Interpretation:** ELPD is expected log predictive density for held-out units under this training scheme. In-sample log predictive density is optimistic and is not LOO ELPD. Densities and probabilities depend on the outcome's measure; absolute scores are not directly comparable across different responses or incompatible transformations.

**Likely causes:** Missing normalization constants/Jacobians; likelihood arrays containing priors; reordered observations; different responses; conditioning on held-out group effects; separate multi-outcome factors confused with joint prediction; temporal leakage.

**Do NOT:** Assume that matching array lengths makes two scores comparable, compare a discrete mass to a continuous density, or use `lp__` as pointwise likelihood.

**Actions:** Write a one-sentence target; identify the omitted information; construct matched contributions on a common observed scale. Use explicit folds/integrated predictions if ordinary pointwise PSIS does not implement the task. Audit a few likelihood values against direct evaluation.

**Follow-up:** Computational validation, candidate PPCs, unit alignment, and PSIS/fold diagnostics after any likelihood or target revision.

**Evidence:** E02/E07/E10 (`direct-eabm`, `eabm-code`); M-LOO (`method-paper`); R array/adapter (`translated`); target preflight (`synthesized`).

### Hierarchies, dependence and multiple likelihoods

| Scientific prediction | Held-out unit / treatment | What to verify |
|---|---|---|
| Another measurement in an existing group | One measurement; remaining group data available | Group effect can be learned from remaining measurements; one-observation PSIS may be unstable for sparse groups |
| A wholly new group | Entire group; integrate over its effect under the population model or simulate a fresh effect | Do not condition on the full-data group effect; use leave-group-out folds or validated integrated IS |
| Future observations / forecasting | Time blocks or leave-future-out, with training restricted to the past | Ordinary iid LOO answers an interpolation task and can leak future information |
| Both home and away scores for a new match | Joint match contribution `log p(home|theta) + log p(away|theta)` if conditionally independent | Align match IDs; sum factors, rather than treating two outcomes as independent held-out games |
| One match score when the other is known | Omit only the target score; other score remains information | State the conditional task; it differs from holding out the match jointly |
| Multiple unrelated outcome datasets | Separate target-specific scores, or a scientifically specified joint utility | Concatenation weights tasks by their unit counts; do not add unlike units without explaining the aggregate target |
| Censored/truncated/missing outcomes | Unit includes its observation mechanism | Correct survival/censoring probability, truncation normalizer and observed-data likelihood; no invented scores for missing outcomes |

Normal and Student-t likelihoods **can** be compared on the same continuous outcome with complete densities and identical held-out units. A model fitted to `log(y)` must include the transformation Jacobian when scored on `y`. Predicting latent noise-free outcomes differs from predicting measured outcomes.

## PSIS-LOO and Pareto-k

**Question:** Can full-posterior draws reliably approximate each leave-one-unit-out posterior and predictive density?

**Prerequisites:** Valid matched pointwise contributions; adequate posterior draws and MCMC relative efficiency; well-defined LOO target. PSIS assumes sufficient overlap between the full and leave-out posterior.

**Computation:** Python: `az.loo(dt, var_name="y", pointwise=True)`. R: `r_eff <- loo::relative_eff(exp(ll)); loo::loo(ll, r_eff=r_eff, save_psis=TRUE)`. Inspect pointwise ELPD and Pareto-k, not just the aggregate. Use the draw-count-dependent warning threshold in the [registry](../references/thresholds.md), not a universal fixed cutoff.

**Interpretation:** Pareto-k diagnoses the tail/overlap of the importance ratios, not model adequacy. High k often marks influential units, weakly identified local parameters or a likelihood poorly matched to an observation. k at or above the registry moment boundary means the estimated raw importance-ratio mean lacks the usual finite-mean behavior; the approximation must not be trusted. Increasing draws may improve a borderline approximation, but does not remove structural poor overlap.

**Likely causes:** Outliers; sparse groups; highly influential responses; weak regularization; overly narrow tails; observation/model errors; poor posterior computation; target factorization inappropriate for group prediction.

**Do NOT:** Ignore high k, silently remove the offending units, treat a repaired score as a repaired model, or assume low k implies good predictions.

**Actions:** (1) Check data/likelihood alignment and computation. (2) Identify affected units and their scientific context; use targeted PPCs and influence analysis. (3) For an otherwise sound model and valid task, apply supported moment matching and recheck k. (4) Refit leave-out posteriors for unresolved units, or use explicit K-fold/group/time CV. (5) Revise the model only when substantive/misfit evidence motivates it; then redo computation, PPC and comparison. More draws alone is an option for marginal MC precision, not a remedy for k=1.2.

**Follow-up:** New pointwise diagnostics, MCSE, exact-refit consistency where useful, influential-unit PPCs and uncertainty of the final difference. Disclose unrepaired approximations.

**Evidence:** E07/E09 (`direct-eabm`, `eabm-code`); M-PSIS/M-LOO/M-MM (`method-paper`); D-LOO-K/D-AZ-LOO (official API); action ordering (`synthesized`); R (`translated`).

## Moment matching and exact refits

**Question:** Can the LOO estimator be repaired without changing the generative model?

**Prerequisites:** Unconstrained posterior draws plus correct joint log-density and unit log-likelihood callbacks, or an official model adapter. Retain transformation Jacobians consistently. The model must permit reevaluation at transformed draws.

**Computation:** Python: ArviZ 1.x `az.loo(..., moment_match=True, model=model)` where the adapter supports the fitted model; otherwise supply the documented callbacks to `loo_moment_match`. R: `loo(fit, moment_match=TRUE)` for a supported brms fit saved with `save_pars(all=TRUE)`; `loo_moment_match` callbacks for other models. `brms::loo(fit, reloo=TRUE)` or explicit refits for unresolved cases. See implementation guides for adapter restrictions.

**Interpretation:** Moment matching moves importance samples toward the leave-out posterior by matching moments and reweights them. Improved k establishes a more reliable estimator, not improved fit. Exact leave-out refitting still needs valid sampling and the correct prediction integration.

**Likely causes of failure:** Missing saved parameters; incomplete densities/Jacobians; incompatible transformations; multimodal leave-out posterior; extreme lack of overlap; callback errors; high-dimensional covariance instability.

**Do NOT:** Invent callbacks from unverified constrained-parameter arrays, report an unsupported option as executed, or combine predictions with inconsistent integration over group effects.

**Actions:** Verify adapter/callback contract; rerun pointwise diagnostics; refit failures; use appropriate folds if many failures or the target changes. Keep the original and repaired diagnostic records.

**Follow-up:** Validate every refit; compare repaired/exact contributions and recompute aggregate uncertainty.

**Evidence:** E09 (`direct-eabm`, `eabm-code`); M-MM (`method-paper`); official ArviZ/loo/brms docs; R (`translated`).

## ELPD differences and stacking

**Question:** Does the predictive difference matter for this use, and would a mixture predict better?

**Prerequisites:** Comparable, reliable pointwise estimates; candidate criticism completed; evaluation data not used in an uncontrolled search. Assess difference uncertainty using **paired unitwise differences**, not independent aggregate SEs.

**Computation:** Python: `az.compare({"A": dt_A, "B": dt_B}, method="stacking", var_name="y")`. R: `loo_compare(list(A=loo_A, B=loo_B)); loo_model_weights(list(A=loo_A, B=loo_B), method="stacking")`. Current ArviZ 1.3 and loo report nonpositive differences relative to the best model by default. Legacy ArviZ 0.x used positive losses and different column names. Inspect the installed result schema before translating signs. Plot pointwise differences against covariates/group IDs.

**Interpretation:** A tiny uncertain difference rarely supports a strong preference. SE is an approximation and can be unreliable with few units, skewed differences, dependence or many searched models. Stacking estimates weights to maximize cross-validated mixture log predictive density. Weights are not posterior model probabilities or a test of which model is true; a small weight is not proof a component is useless in all contexts.

**Likely causes:** Redundant candidates; complementary predictions; influential units; selection-induced optimism; group/time dependence; misdefined utility.

**Do NOT:** Select the highest number mechanically, interpret ELPD±SE as a universal hypothesis test, pool parameter draws from models with different meanings, or multiply model predictions instead of mixing them.

**Actions:** Evaluate practical consequences, uncertainty and adequacy. Prefer a simpler adequate candidate when differences do not resolve the decision; use stacking if predictive complementarity is useful. Generate predictive mixtures by selecting a model using its weight, then drawing from that model's predictive distribution. Evaluate the resulting mixture with its own targeted PPCs/calibration; use outer validation for material searched decisions.

**Follow-up:** Reassess differences on reliable estimates; validate mixture predictions; document candidate/search history and selection uncertainty.

**Evidence:** E07/E11 (`direct-eabm`); M-STACK/M-PROJ (`method-paper`); loo/ArviZ documentation; R (`translated`); decision utility/outer validation (`synthesized`).

## Large-data/subsampled LOO

**Question:** Can the predictive comparison be estimated accurately without full draws × observations storage and computation?

**Prerequisites:** Same target, valid posterior/approximation, evaluable per-unit likelihood and a documented probability sampling design. Storage constraints, number of draws and posterior fitting cost are different problems.

**Computation:** Python: current `az.loo_subsample(..., observations=n_sub, method="lpd"|"plpd", model=model)` and `update_subsample`; verify the installed method and model/callback support. R: `loo_subsample(f, data=data, draws=draws, observations=n_sub, loo_approximation="plpd", estimator="diff_srs")`; update with the documented updater. Use the same sampled units for paired model comparisons when the implementation supports it. A cheap all-unit predictor plus corrected sampled-unit LOO estimates is different from simply running LOO on a tiny dataset.

**Interpretation:** Subsampling adds sampling-design uncertainty; posterior approximations add another error source. Ten million observations do not automatically require full LOO, but they do require a target and precision budget. A small illustrative subsample is not a guaranteed accurate estimate. PLPD computed at a posterior mean can be poor for nonlinear or multimodal posteriors.

**Likely causes:** Nonrepresentative sample; rare influential groups; poor cheap approximation; insufficient subsample; incompatible unit sampling; biased variational/Laplace posterior used without correction.

**Do NOT:** Use a convenient first block of data as a random subsample, omit subsampling uncertainty, ignore high k in sampled units, or imply unsampled units have been individually diagnosed.

**Actions:** Pilot; inspect influence/strata and posterior approximation; increase or appropriately stratify the probability sample under a supported estimator; track stability and subsampling error of the paired difference. Use chunks/on-demand likelihoods to avoid huge arrays. Use group/time folds instead when they answer the actual task. Repair/refit influential sampled units as required.

**Follow-up:** Repeat with a larger documented sample, assess precision/stability and total computational budget; disclose what was not examined.

**Evidence:** E08 (`direct-eabm`, `eabm-code`); M-LARGE (`method-paper`); current ArviZ/loo docs; R (`translated`); scalable triage (`synthesized`).

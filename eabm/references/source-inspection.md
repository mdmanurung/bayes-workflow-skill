# Executable-source inspection record

Snapshot: 2026-10-04. The source ledger was created before guides. EABM chapters are executable **Quarto `.qmd`** files, so inspection covered their Python chunks alongside rendered text, figures/captions and analytical comments; it did not assume all executable content was `.ipynb`. Source hashes and cell/block counts are in `source-manifest.json`. All substantive chapters and linked model/source examples were surveyed; the methodological extraction focused on decision-making passages and model/helper code. Upstream notebooks/models were not all rerun.

| Source | Source structure | Extracted reasoning |
|---|---|---|
| Chapters/Bayesian_workflow.qmd | 0 Python chunks | Iterative scientific purpose and model revision |
| Chapters/Case_study_model_comparison.qmd | 13 Python chunks | Football joint/conditional scoring and aligned outcomes |
| Chapters/DataTree.qmd | 33 Python chunks | Chain/draw/event alignment and derived quantities |
| Chapters/Distributions.qmd | 27 Python chunks | Support, CDF/quantile/interval choices and plotting artifacts |
| Chapters/Elements_of_visualization.qmd | 6 Python chunks | Encoding, units, accessible color and misleading summaries |
| Chapters/MCMC_diagnostics.qmd | 25 Python chunks | Synthetic chains, tail precision, divergent geometry and energy |
| Chapters/Model_comparison.qmd | 17 Python chunks | Likelihood comparability, ELPD/PSIS/influence, uncertainty and predictive mixtures |
| Chapters/Model_comparison_large_data.qmd | 26 Python chunks | Cheap approximations, corrected subsample scores, callbacks and approximation limits |
| Chapters/Moment_Matching.qmd | 12 Python chunks | Roaches Poisson influence, density reevaluation and estimator repair |
| Chapters/Presenting_results.qmd | 0 Python chunks | Audience and reliability evidence |
| Chapters/Prior_elicitation.qmd | 18 Python chunks | Quantile/mass constraints and observable-scale elicitation |
| Chapters/Prior_posterior_predictive_checks.qmd | 25 Python chunks | Height scales, count zeros/tails, targeted statistics, calibration, group/observation checks |
| Chapters/References.qmd | 0 Python chunks | References and method provenance |
| Chapters/Sensitivity_checks.qmd | 21 Python chunks | Body-fat predictor scaling, bacteria hyperprior selection, local powering and corroboration |
| Chapters/Simulation_based_calibration.qmd | 4 Python chunks | Simulation/ranks, test quantities and conditional SBC boundaries |
| Chapters/Variable_selection.qmd | 17 Python chunks | Reference-model projection and search/size decision |

## Models, helpers and comments

| Executable material | What was inspected | Decision extracted |
|---|---|---|
| crabs notebook | Count families, hurdle/dispersion modeling, zero/count predictive plots | Separate zero and positive-count failures; do not let a generic mean check hide them |
| categorical/ordinal notebook | Outcome/category definitions, model families and probability predictions | Conditional/category calibration and support matter; label encoding is not numeric distance |
| football base/budget/no-field notebooks and cleanup | Exponential rate link, home/away variable names, team effects, covariates and observation cleanup/alignment | Joint match versus single response and new-team targets; trust executable definitions over a prose swap |
| roaches moment_matching.py | Bambi Poisson model, exposure offset, saved fitted data/parameters | High influence can require an IS repair and separately a dispersion/model revision |
| wells model_comparison_large_data.py | Logistic/approximate posterior setup and pointwise/PLPD helper shapes | Validate cheap approximations and likelihood callback contracts before scaling computation |
| max_ent / beta_bounds helpers | Constraint geometry and mass/mode behavior | Elicitation is family/support-specific; interval mass is not hard support |
| prior_vagueness / prior_posterior / bayes_theorem / beta_binomial_ani helpers | Induced prior scales and illustrative updates | Marginally vague priors can create implausible observables; illustrations are not SBC validation |
| img/coodinates.ipynb | Coordinate illustrations | Axis units/aspect ratio and encodings; no posterior diagnostic code |

## Representative rendered plots inspected visually

- Centered/noncentered energy panels: one chain is registry-low in the centered fit; noncentered energy transitions overlap better. Plot/model flags resolve the inconsistent divergence prose.
- Crabs Poisson rootogram: zero excess and middle/tail discrepancies motivate specific count checks; count means alone are insufficient.
- Body-fat power-quantity panel: opposing prior/likelihood shifts and displayed MCSE support quantity-specific interpretation, rather than relying only on sensitivity labels.
- Maximum-entropy panels: changing a mean or interval-mass constraint changes the distribution within the chosen family; no universal uninformative prior follows.

Rendered plot URLs are in `validation/plot-inspection.json`. Additional figures were surveyed in rendered chapter context; the record does not claim every upstream graphic was separately downloaded or every model refitted. Source defects, historical API differences and their resolution are in the [ledger](source-ledger.md#source-defects-and-boundaries). This explicit scope prevents equating systematic inspection with a runtime validation of the entire book.

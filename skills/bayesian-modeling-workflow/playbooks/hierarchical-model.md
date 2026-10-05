# Hierarchical model

Read [hierarchical workflow](../references/hierarchical-models.md), [priors](../references/prior-workflow.md) and [validation unit](../references/model-comparison-loo.md).

Map subject/group/cohort/crossed structure, group sizes, within-group predictor variation and target (known or new group). Defend exchangeability conditional on predictors. Use pooling comparators where they answer a question.

Add varying intercepts and then slopes/correlation only for justified heterogeneity and available information. Explain which new SDs/correlations are weak; simulate new groups from hyperpriors. For sparse groups inspect shrinkage and prior sensitivity rather than report noisy independent rankings.

Evaluate centered/non-centered implementations based on information and observed geometry. Sum-to-zero constraints and effect centering require a documented intercept/prior interpretation. Check all diagnostics and both within-/between-group predictions. For population contrasts under nonlinear links integrate group effects; `re_formula=NA` provides zero deviations, not automatic marginalization.

Return the expansion record, parameter meaning, prior implications, parameterization evidence, group PPC and validation split. Stop at the hierarchy needed for the estimand; do not add correlations because syntax allows them.

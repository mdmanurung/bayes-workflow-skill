# Posterior predictive mismatch

Read [predictive checks](../references/posterior-predictive-checking.md) and [expansion](../references/model-expansion.md).

Describe the discrepancy on original units and why it matters for the estimand. Confirm reliable computation and correct preprocessing/generated quantities. Separate location, dispersion, tails/zeros, conditional shape, group variation and dependence hypotheses. Choose a second statistic/plot that distinguishes them.

Propose one responsible change: repair code; revise observation support/variance/censoring; add justified mean/group/dependence structure; or document immaterial residual mismatch. Simulate priors for new parameters and refit. Repeat the original failing check plus a new check for risks introduced by the change.

Use held-out predictive checks when flexible latent fitting makes in-sample checks optimistic. Comparison may quantify useful improvement on a matched task but cannot repair inadequate candidates. Return observed inadequacy → cause evidence → modification → predicted improvement → actual validation. Stop expanding when no material task-relevant failure remains.

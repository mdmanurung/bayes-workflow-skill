# Meaningful model comparison

Read [comparison and LOO](../references/model-comparison-loo.md) and [sensitivity](../references/sensitivity-analysis.md).

State the competing scientific/predictive question and held-out unit. Verify same observation IDs, outcome/measure, preprocessing and conditioning; refit for group/future targets where required. Establish relevant candidate checks, or explicitly use comparison only for provisional screening.

Compute matched predictive scores with diagnostics. Examine pointwise differences, uncertainty/skew/influence, and whether improvement matters for the task. Repair PSIS when needed and distinguish numerical reliability from substantive model adequacy.

For near ties prefer scientifically appropriate structure and practical simplicity; do not delete causal adjustment merely for predictive parsimony. For averaging/stacking state its predictive objective; for projection validate reference and search, with correlated-variable instability. Report comparison limitations, residual model inadequacy and sensitivity rather than a single winning rank.

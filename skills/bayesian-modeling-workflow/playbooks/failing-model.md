# Diagnose a failing model from its symptom

Read [computational diagnostics](../references/computational-diagnostics.md) and [debugging](../references/debugging.md).

1. Capture the exact warning/exception, stage (compile/init/warmup/post-warmup), chain and affected scientific quantity. Preserve the current model/data/seed.
2. Classify scientific, statistical, prior/identification and computational explanations; allow more than one.
3. Select the smallest discriminating check: data support/unit inspection, manual likelihood, design rank, trace/pairs, prior simulation, fixed-truth recovery, chain predictions or solver-tolerance comparison.
4. Change one component for a stated hypothesis. Apply statistical remedies when evidence identifies a model/prior problem; evaluate parameterization before sampler tuning.
5. Refit/retest, repeat original diagnostics and add a targeted validation for the intervention. Compare QOI estimates/uncertainty and exploration; warning disappearance alone is not acceptance.

Return the chain: symptom → competing explanations → evidence → intervention → observed validation → remaining limitation. Route to [divergences](divergent-transitions.md), [bad PPC](bad-ppc.md), [high k](high-pareto-k.md), [weak identification](weak-identification.md) or [multimodality](../references/multimodality.md) as appropriate. Do not randomly increase iterations, adapt_delta and treedepth together.

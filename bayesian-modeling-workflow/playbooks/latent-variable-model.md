# Latent-variable model

Read [latent modeling](../references/latent-variable-models.md), [debugging](../references/debugging.md) and [SBC](../references/sbc.md).

State the latent variable's scientific meaning and observable evidence. Audit sign/scale/location/label/rotation invariances; choose explicit conventions and proper priors. Test measurement and latent components independently on known data before assembling.

Marginalize discrete states where feasible. Verify pointwise mixture versus whole-dataset mixing, transition orientation, missing emission and track boundaries using tiny examples. Select CP/NCP for continuous latent effects using information/geometry, not habit.

Validate recovery of identifiable functions, conditional/new-unit predictions, latent uncertainty and integrated held-out likelihood. Run SBC early for new code, tracking contraction/data-dependent quantities and all failed fits. Do not turn decoded states or signed factor conventions into observed scientific truth, and do not impose positivity on an arbitrary signed score.

Return staged code, identification/priors, component tests, computational and predictive checks, validation target and unresolved interpretation limits.

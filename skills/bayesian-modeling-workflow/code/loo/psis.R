# Template fragment: fit is a checked posterior MCMC fit with pointwise log_lik.
# Units must be the intended held-out observations, not inappropriately conditioned latents.
log_lik <- fit$draws("log_lik", format = "draws_array")
stopifnot(length(dim(log_lik)) == 3L, all(is.finite(log_lik)))
# Rescale each unit before exp to avoid underflow; multiplicative scaling leaves r_eff unchanged.
centered <- sweep(log_lik, 3L, apply(log_lik, 3L, max), "-")
r_eff <- loo::relative_eff(exp(centered))
loo_fit <- loo::loo(log_lik, r_eff = r_eff)
loo::pareto_k_table(loo_fit)
flagged <- loo::pareto_k_ids(loo_fit)
# Only compare after both score targets and observation IDs match:
# loo::loo_compare(model_a = loo_a, model_b = loo_b)

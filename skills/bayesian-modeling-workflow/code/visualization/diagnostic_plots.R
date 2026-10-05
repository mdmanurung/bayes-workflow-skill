# Template fragment: variables is a small scientifically chosen set.
draws <- fit$draws(variables = variables, format = "draws_array")
np <- bayesplot::nuts_params(fit)
bayesplot::mcmc_trace(draws)
bayesplot::mcmc_rank_overlay(draws)
bayesplot::mcmc_pairs(draws, np = np)
bayesplot::mcmc_nuts_energy(np)
# Distinguish these exploration checks from observed-versus-replicated PPCs.

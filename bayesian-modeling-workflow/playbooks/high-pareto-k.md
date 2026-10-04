# High Pareto-k

Read [LOO reasoning](../references/model-comparison-loo.md), particularly held-out targets and latent integration.

1. Identify flagged observations/groups, k reliability, draw count/ESS and MCMC warnings. Verify observation IDs and likelihood dimensions, constants/measure and fold preprocessing.
2. Inspect each flagged unit's scientific context, exposure/support, conditional prediction and contribution to paired model differences. Do not call an influential valid observation erroneous without evidence.
3. Distinguish unstable posterior sampling, misspecification/leverage, held-out latent conditioning and incorrect temporal/group target. Integrate new held-out latent effects or use group/future refits where required.
4. Repair the approximation through supported moment matching, exact re-LOO or suitable K-fold/group/future validation. Independently consider model/priors if PPC/context identifies inadequacy.
5. Recheck reliability and exact/refit agreement; preserve substantive influence information and repeat model checks. Report unresolved approximation uncertainty.

Do not switch to WAIC to bypass warnings, erase influential observations or treat repaired k as evidence that the model is adequate. Return approximation intervention and statistical intervention separately.

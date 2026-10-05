# Executable triage, with explicit unknowns

Run the standard-library Python runner from the skill directory:

```bash
python scripts/route_checks.py --tree mcmc --facts '{"is_mcmc":true,"hmc":true,"hmc_warnings":true}'
python scripts/route_checks.py --tree psis-loo --facts-file inspected-facts.json
```

It returns inspected gate answers, a next action, its guide and trees to rerun. Inputs are **evidence-backed booleans**, not numerical shortcuts: use the [threshold registry](../references/thresholds.md) and quantity-specific precision when deciding a fact. An omitted/null fact requests the missing check. Invalid values/unknown keys error rather than silently pass. The runner diagnoses which question comes next; it does not execute a sampler or certify a model.

| Tree | Use |
|---|---|
| [mcmc](mcmc.md) | Method → sampler/geometry → stationarity → R-hat/ESS/MCSE |
| [divergences](divergences.md) | Support/scaling → geometry/identification → parameterization → justified tuning |
| [prior-predictive](prior-predictive.md) | Domain targets → simulator validity → induced predictions → prior/model revision |
| [ppc](ppc.md) | Computation → targeted features → observation replication → criticism/revision |
| [sensitivity](sensitivity.md) | Valid base/components → IS/refit reliability → MCSE → substantive mechanism |
| [psis-loo](psis-loo.md) | Target → computation/criticism → Pareto → influence/repair → paired uncertainty |
| [end-to-end](end-to-end.md) | Scientific purpose → prior → computation → PPC → sensitivity → optional comparison → report |

After any revision, invalidate prior “passed” facts for the changed fit/predictions/target and rerun the appropriate trees. Preserve history in the model-development record. JSON is the authoritative graph; Markdown diagrams abbreviate long labels and omit unknown branches for readability.

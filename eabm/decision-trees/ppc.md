# Choose and respond to targeted PPC

Executable specification: [`trees.json`](trees.json), tree `ppc`. Supply boolean facts only after inspecting evidence. Omitted facts follow **unknown** and request a check. A terminal action is a next step, not an automatic declaration of adequacy; after an intervention rerun the named trees.

| Fact | Required evidence / question |
|---|---|
| `computation_adequate` | Is computation adequate for the quantities used in predictions? |
| `targeted_quantities` | Do checks expose specific plausible failures, including relevant dependence/groups? |
| `observation_replication_correct` | Does replication reproduce design, measurement/censoring and prediction conditioning? |
| `ppc_features_adequate` | Are the checked features adequate for the scientific task? |

## Routes

```mermaid
flowchart TD
  computation_adequate["Is computation adequate for the quantities used in predictions?"]
  targeted_quantities["Do checks expose specific plausible failures, including relevant dependence/groups?"]
  observation_replication_correct["Does replication reproduce design, measurement/censoring and prediction conditioning?"]
  ppc_features_adequate["Are the checked features adequate for the scientific task?"]
  repair_computation["Resolve computation before substantive interpretation of PPC discrepancies."]
  choose_quantities["Choose location/spread/tails/zeros/groups/dependence or scientific contrasts that rev…"]
  fix_replication["Correct the predictive simulation before revising the likelihood."]
  model_revision["Localize systematic failure and revise justified likelihood/link/dependence/hierarchy…"]
  next_sensitivity["These features show no identified failure; check sensitivity and unresolved scientifi…"]
  computation_adequate -->|yes| targeted_quantities
  computation_adequate -->|no| repair_computation
  targeted_quantities -->|yes| observation_replication_correct
  targeted_quantities -->|no| choose_quantities
  observation_replication_correct -->|yes| ppc_features_adequate
  observation_replication_correct -->|no| fix_replication
  ppc_features_adequate -->|yes| next_sensitivity
  ppc_features_adequate -->|no| model_revision
```

Unknown branches and full action text are intentionally in the executable specification. Conditional recommendations in action text still require the named evidence; the runner does not fit models or infer boolean facts from incomplete summaries.

Evidence: statistical guides linked by each action; graph/action ordering `synthesized` from E15 and diagnostic modules.

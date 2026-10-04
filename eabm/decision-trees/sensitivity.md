# Validate and interpret sensitivity

Executable specification: [`trees.json`](trees.json), tree `sensitivity`. Supply boolean facts only after inspecting evidence. Omitted facts follow **unknown** and request a check. A terminal action is a next step, not an automatic declaration of adequacy; after an intervention rerun the named trees.

| Fact | Required evidence / question |
|---|---|
| `computation_adequate` | Is base computation adequate? |
| `using_power_scaling` | Is sensitivity being approximated by power-scaling importance sampling? |
| `density_components_valid` | Are selected density components, transformations and alpha targets valid? |
| `importance_reliable` | Are alpha-specific Pareto/weight/precision diagnostics reliable? |
| `refits_valid` | Have all alternative refits passed computation and matched estimand checks? |
| `change_exceeds_mcse` | Is the observed change distinguishable from Monte Carlo error? |
| `practically_material` | Does sensitivity materially affect the scientific conclusion? |

## Routes

```mermaid
flowchart TD
  computation_adequate["Is base computation adequate?"]
  using_power_scaling["Is sensitivity being approximated by power-scaling importance sampling?"]
  density_components_valid["Are selected density components, transformations and alpha targets valid?"]
  importance_reliable["Are alpha-specific Pareto/weight/precision diagnostics reliable?"]
  refits_valid["Have all alternative refits passed computation and matched estimand checks?"]
  change_exceeds_mcse["Is the observed change distinguishable from Monte Carlo error?"]
  practically_material["Does sensitivity materially affect the scientific conclusion?"]
  repair_base["Repair base computation first."]
  fix_densities["Correct the selected density/parameter measure and confirm proper targets."]
  refit["Use explicit justified refits when importance overlap is unreliable; validate every fit."]
  validate_refits["Check each refit computation, PPC and the same scientific quantities."]
  improve_precision["The change is unresolved at current numerical precision; improve useful computation o…"]
  investigate_mechanism["Distinguish intended prior information, weak likelihood, potential conflict and model…"]
  report_local_robustness["Report tested alternatives/components/range and precision; local insensitivity is not…"]
  computation_adequate -->|yes| using_power_scaling
  computation_adequate -->|no| repair_base
  using_power_scaling -->|yes| density_components_valid
  using_power_scaling -->|no| refits_valid
  density_components_valid -->|yes| importance_reliable
  density_components_valid -->|no| fix_densities
  importance_reliable -->|yes| change_exceeds_mcse
  importance_reliable -->|no| refit
  refits_valid -->|yes| change_exceeds_mcse
  refits_valid -->|no| validate_refits
  change_exceeds_mcse -->|yes| practically_material
  change_exceeds_mcse -->|no| improve_precision
  practically_material -->|yes| investigate_mechanism
  practically_material -->|no| report_local_robustness
```

Unknown branches and full action text are intentionally in the executable specification. Conditional recommendations in action text still require the named evidence; the runner does not fit models or infer boolean facts from incomplete summaries.

Evidence: statistical guides linked by each action; graph/action ordering `synthesized` from E15 and diagnostic modules.

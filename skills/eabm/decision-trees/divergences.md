# Diagnose divergent HMC trajectories

Executable specification: [`trees.json`](trees.json), tree `divergences`. Supply boolean facts only after inspecting evidence. Omitted facts follow **unknown** and request a check. A terminal action is a next step, not an automatic declaration of adequacy; after an intervention rerun the named trees.

| Fact | Required evidence / question |
|---|---|
| `post_warmup_divergences` | Are there post-warmup divergences? |
| `data_support_valid` | Have likelihood support, transforms, indexing and data errors been checked? |
| `scales_reasonable` | Are units/scales numerically reasonable? |
| `geometry_localized` | Have divergence-marked pairs and hierarchical/dependence geometry been inspected? |
| `identification_sound` | Is identification adequate for the intended quantities? |
| `reparameterization_reviewed` | Has a probability-preserving parameterization appropriate to the data information been considered? |
| `tuning_plausible` | After geometry review, is smaller integration error a plausible remaining mechanism? |

## Routes

```mermaid
flowchart TD
  post_warmup_divergences["Are there post-warmup divergences?"]
  data_support_valid["Have likelihood support, transforms, indexing and data errors been checked?"]
  scales_reasonable["Are units/scales numerically reasonable?"]
  geometry_localized["Have divergence-marked pairs and hierarchical/dependence geometry been inspected?"]
  identification_sound["Is identification adequate for the intended quantities?"]
  reparameterization_reviewed["Has a probability-preserving parameterization appropriate to the data information bee…"]
  tuning_plausible["After geometry review, is smaller integration error a plausible remaining mechanism?"]
  other_checks["Zero observed divergences passes this screen only; inspect R-hat/ESS/MCSE, BFMI and PPC."]
  fix_implementation["Correct justified data/model implementation errors, then refit."]
  rescale["Rescale inputs/parameters with correctly transformed priors and predictions; refit."]
  inspect_geometry["Mark divergent transitions in pairs/parallel plots and inspect funnels, curvature, de…"]
  reformulate["Revise unidentified structure or justified priors; explain induced predictions and li…"]
  reparameterize["Consider centered/noncentered or other probability-preserving transforms based on inf…"]
  tune_then_check["Try bounded sampler tuning; record efficiency/treedepth and rerun all computational c…"]
  structural_review["Reassess geometry/identification, prior scales, likelihood structure or alternative i…"]
  post_warmup_divergences -->|yes| data_support_valid
  post_warmup_divergences -->|no| other_checks
  data_support_valid -->|yes| scales_reasonable
  data_support_valid -->|no| fix_implementation
  scales_reasonable -->|yes| geometry_localized
  scales_reasonable -->|no| rescale
  geometry_localized -->|yes| identification_sound
  geometry_localized -->|no| inspect_geometry
  identification_sound -->|yes| reparameterization_reviewed
  identification_sound -->|no| reformulate
  reparameterization_reviewed -->|yes| tuning_plausible
  reparameterization_reviewed -->|no| reparameterize
  tuning_plausible -->|yes| tune_then_check
  tuning_plausible -->|no| structural_review
```

Unknown branches and full action text are intentionally in the executable specification. Conditional recommendations in action text still require the named evidence; the runner does not fit models or infer boolean facts from incomplete summaries.

Evidence: statistical guides linked by each action; graph/action ordering `synthesized` from E15 and diagnostic modules.

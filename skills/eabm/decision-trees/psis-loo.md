# Validate predictive comparison and PSIS

Executable specification: [`trees.json`](trees.json), tree `psis-loo`. Supply boolean facts only after inspecting evidence. Omitted facts follow **unknown** and request a check. A terminal action is a next step, not an automatic declaration of adequacy; after an intervention rerun the named trees.

| Fact | Required evidence / question |
|---|---|
| `target_compatible` | Are predictive target, held-out unit, information and likelihood measure compatible? |
| `computation_adequate` | Is posterior computation adequate? |
| `candidate_criticism_done` | Have candidate models received targeted criticism and relevant inadequacies been acknowledged? |
| `pareto_reliable` | Do pointwise Pareto/precision diagnostics support PSIS for this target? |
| `influence_examined` | Have high-k units been checked for data errors, model misfit and target issues? |
| `moment_matching_supported` | Is valid moment matching supported by the model adapter/callbacks? |
| `difference_uncertainty_examined` | Are paired ELPD uncertainty, unit influence and search/dependence limits assessed? |

## Routes

```mermaid
flowchart TD
  target_compatible["Are predictive target, held-out unit, information and likelihood measure compatible?"]
  computation_adequate["Is posterior computation adequate?"]
  candidate_criticism_done["Have candidate models received targeted criticism and relevant inadequacies been ackn…"]
  pareto_reliable["Do pointwise Pareto/precision diagnostics support PSIS for this target?"]
  influence_examined["Have high-k units been checked for data errors, model misfit and target issues?"]
  moment_matching_supported["Is valid moment matching supported by the model adapter/callbacks?"]
  difference_uncertainty_examined["Are paired ELPD uncertainty, unit influence and search/dependence limits assessed?"]
  define_target["Define target and align normalized unit contributions; use group/time/explicit folds …"]
  repair_computation["Repair computation before using predictive scores."]
  criticize_candidates["Run targeted PPC/sensitivity and acknowledge remaining failures; relative performance…"]
  inspect_influence["Inspect valid influential units and likelihood/model/target mechanisms; do not silent…"]
  repair_and_recheck["Try moment matching; rerun k/precision. Refit unresolved units or use folds; model ch…"]
  exact_refit_or_folds["Refit leave-out posteriors or use scientifically appropriate folds, with computationa…"]
  inspect_differences["Inspect paired pointwise differences, SE and practical utility; account for dependenc…"]
  make_predictive_decision["Choose an adequate useful prediction strategy or stacking mixture using uncertainty a…"]
  target_compatible -->|yes| computation_adequate
  target_compatible -->|no| define_target
  computation_adequate -->|yes| candidate_criticism_done
  computation_adequate -->|no| repair_computation
  candidate_criticism_done -->|yes| pareto_reliable
  candidate_criticism_done -->|no| criticize_candidates
  pareto_reliable -->|yes| difference_uncertainty_examined
  pareto_reliable -->|no| influence_examined
  influence_examined -->|yes| moment_matching_supported
  influence_examined -->|no| inspect_influence
  moment_matching_supported -->|yes| repair_and_recheck
  moment_matching_supported -->|no| exact_refit_or_folds
  difference_uncertainty_examined -->|yes| make_predictive_decision
  difference_uncertainty_examined -->|no| inspect_differences
```

Unknown branches and full action text are intentionally in the executable specification. Conditional recommendations in action text still require the named evidence; the runner does not fit models or infer boolean facts from incomplete summaries.

Evidence: statistical guides linked by each action; graph/action ordering `synthesized` from E15 and diagnostic modules.

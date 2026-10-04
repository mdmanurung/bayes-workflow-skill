# Route the next analysis step

Executable specification: [`trees.json`](trees.json), tree `end-to-end`. Supply boolean facts only after inspecting evidence. Omitted facts follow **unknown** and request a check. A terminal action is a next step, not an automatic declaration of adequacy; after an intervention rerun the named trees.

| Fact | Required evidence / question |
|---|---|
| `scientific_target_defined` | Are the scientific question, estimand and design/observation process defined? |
| `prior_checked` | Have induced prior predictions passed scientifically targeted checks? |
| `computation_adequate` | Has computation been validated for relevant quantities? |
| `ppc_done` | Have targeted PPCs been assessed and failures addressed/acknowledged? |
| `sensitivity_done` | Has relevant prior/likelihood sensitivity been checked with reliable estimators? |
| `comparison_useful` | Would predictive comparison inform the scientific decision? |
| `comparison_valid` | Have target, reliability, uncertainty and candidate criticism gates been completed? |

## Routes

```mermaid
flowchart TD
  scientific_target_defined["Are the scientific question, estimand and design/observation process defined?"]
  prior_checked["Have induced prior predictions passed scientifically targeted checks?"]
  computation_adequate["Has computation been validated for relevant quantities?"]
  ppc_done["Have targeted PPCs been assessed and failures addressed/acknowledged?"]
  sensitivity_done["Has relevant prior/likelihood sensitivity been checked with reliable estimators?"]
  comparison_useful["Would predictive comparison inform the scientific decision?"]
  comparison_valid["Have target, reliability, uncertainty and candidate criticism gates been completed?"]
  define_science["Inspect model/code/data and define estimands, units, information and identification l…"]
  prior_route["Run prior plausibility/elicitation; simulation/implementation changes return here."]
  mcmc_route["Run method-appropriate computation checks; failures return to geometry/model/implemen…"]
  ppc_route["Choose targeted predictive failures and replicate the actual observation process."]
  sensitivity_route["Compare scientifically relevant alternatives/components with precision and reliabilit…"]
  comparison_route["Define target/units, inspect pointwise PSIS or folds and paired uncertainty, then mak…"]
  report["Report claims, assumptions, uncertainty and limitations; keep the model-development r…"]
  scientific_target_defined -->|yes| prior_checked
  scientific_target_defined -->|no| define_science
  prior_checked -->|yes| computation_adequate
  prior_checked -->|no| prior_route
  computation_adequate -->|yes| ppc_done
  computation_adequate -->|no| mcmc_route
  ppc_done -->|yes| sensitivity_done
  ppc_done -->|no| ppc_route
  sensitivity_done -->|yes| comparison_useful
  sensitivity_done -->|no| sensitivity_route
  comparison_useful -->|yes| comparison_valid
  comparison_useful -->|no| report
  comparison_valid -->|yes| report
  comparison_valid -->|no| comparison_route
```

Unknown branches and full action text are intentionally in the executable specification. Conditional recommendations in action text still require the named evidence; the runner does not fit models or infer boolean facts from incomplete summaries.

Evidence: statistical guides linked by each action; graph/action ordering `synthesized` from E15 and diagnostic modules.

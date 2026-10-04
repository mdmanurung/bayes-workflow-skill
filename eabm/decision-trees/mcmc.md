# Validate computation

Executable specification: [`trees.json`](trees.json), tree `mcmc`. Supply boolean facts only after inspecting evidence. Omitted facts follow **unknown** and request a check. A terminal action is a next step, not an automatic declaration of adequacy; after an intervention rerun the named trees.

| Fact | Required evidence / question |
|---|---|
| `is_mcmc` | Are these draws from a genuine MCMC fit? |
| `hmc` | Is the fit HMC/NUTS? |
| `hmc_warnings` | Are there post-warmup divergences, low BFMI or other unresolved HMC warnings? |
| `stationary` | Do independently initialized chains plausibly explore the same stationary distribution? |
| `rhat_pass` | Do all relevant rank-normalized/folded R-hat values pass the registry screen? |
| `ess_pass` | Are bulk and tail ESS sufficient for relevant quantities? |
| `mcse_pass` | Is estimand-specific MCSE below the scientific precision budget? |

## Routes

```mermaid
flowchart TD
  is_mcmc["Are these draws from a genuine MCMC fit?"]
  hmc["Is the fit HMC/NUTS?"]
  hmc_warnings["Are there post-warmup divergences, low BFMI or other unresolved HMC warnings?"]
  stationary["Do independently initialized chains plausibly explore the same stationary distribution?"]
  rhat_pass["Do all relevant rank-normalized/folded R-hat values pass the registry screen?"]
  ess_pass["Are bulk and tail ESS sufficient for relevant quantities?"]
  mcse_pass["Is estimand-specific MCSE below the scientific precision budget?"]
  other_inference["Use inference-method-specific accuracy checks; fake chains do not validate VI/Laplace…"]
  geometry["Localize warnings in parameter space; check scaling, identification and parameterizat…"]
  inspect_chains["Distinguish transients/slow mixing from separated modes, scaling, weak identification…"]
  precision_or_geometry["If stationarity/geometry are sound and ESS grows with draws, add independent useful c…"]
  next_ppc["Computational screens passed for the supplied quantities; proceed to targeted PPC and…"]
  is_mcmc -->|yes| hmc
  is_mcmc -->|no| other_inference
  hmc -->|yes| hmc_warnings
  hmc -->|no| stationary
  hmc_warnings -->|yes| geometry
  hmc_warnings -->|no| stationary
  stationary -->|yes| rhat_pass
  stationary -->|no| inspect_chains
  rhat_pass -->|yes| ess_pass
  rhat_pass -->|no| inspect_chains
  ess_pass -->|yes| mcse_pass
  ess_pass -->|no| precision_or_geometry
  mcse_pass -->|yes| next_ppc
  mcse_pass -->|no| precision_or_geometry
```

Unknown branches and full action text are intentionally in the executable specification. Conditional recommendations in action text still require the named evidence; the runner does not fit models or infer boolean facts from incomplete summaries.

Evidence: statistical guides linked by each action; graph/action ordering `synthesized` from E15 and diagnostic modules.

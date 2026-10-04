# Classify the failure before choosing a remedy

| Class | Evidence to look for | Mechanisms to distinguish | First useful action | Recheck |
|---|---|---|---|---|
| Computational failure | R-hat, ESS, MCSE, chain plots, sampler warnings | Short but stationary runs versus stuck/drifting chains, modes, invalid density evaluations | Inspect per-chain draws, warnings and affected estimands | All computational checks; do not interpret unreliable draws |
| Identification/geometry problem | Divergent neighborhoods, funnels, ridges, extreme correlations; weak data information | Equivalent parameter combinations, weak hierarchical scales, nonlinear curvature, label switching | Check parameterization and induced priors; simulate a simpler identified model | Sampler diagnostics, scientific quantities, prior predictions; SBC when implementation is uncertain |
| Prior problem | Implausible prior predictions; unintended sensitivity/conflict | Unit mismatch, overly concentrated/diffuse scales, support restrictions; justified informative knowledge | Validate observable implications and selected prior components | Prior predictive checks; refitted computation; PPC; scientific sensitivity |
| Likelihood/model misspecification | Systematic targeted PPC/residual failure | Missing nonlinear/group/dependence structure, wrong tails, dispersion, zeros or observation process | Trace the failed feature to a mechanism and revise one component | Computation and the original failed check plus checks that could be harmed |
| Predictive instability | High Pareto-k, influential units, unstable differences, poor fold transport | Poor importance proposal, highly informative units, sparse groups, scoring target mismatch | Inspect units and repair the approximation or use explicit target-matched folds | Post-repair diagnostics, uncertainty and independent criticism |
| Scientific inadequacy | Model estimates/predicts a different question | Wrong estimand, population or intervention; causal assumptions absent; leakage | Restate target, information available at prediction and design constraints | Every downstream check for the revised target |

These classes overlap. A funnel is a geometry problem that can produce computational failure; an intentionally informative prior can produce sensitivity without being a prior problem; misspecification can generate high k, but high k alone does not identify misspecification.

Separate data/model implementation errors (units, array alignment, coding, censored contributions) from substantive assumptions before changing the model. A bug fix preserves the intended model; an altered prior/likelihood may change the scientific answer.

Evidence: E04–E07, E10, E15 (`direct-eabm` for distinctions illustrated in the book); the six-class taxonomy and ordered triage are `synthesized`. Geometry interpretation uses M-RHAT, M-ENERGY and D-STAN-REPARAM. See [bibliography](../references/bibliography.md).

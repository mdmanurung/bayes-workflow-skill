# New analysis

Read [formulation](../references/problem-formulation.md), [generative modeling](../references/generative-modeling.md), [priors](../references/prior-workflow.md) and [workflow states](../references/workflow-principles.md).

1. Inspect dataset/schema and scientific request. Establish estimand, target population/time, experimental and observational units, cluster/repeated structure, selection/missingness and outcome support/exposure. Ask consequential questions if these cannot be inferred.
2. Propose the minimal meaningful likelihood/link and predictor/dependence structure. Explain parameter units and information limits. Distinguish causal/decision assumptions from predictive convenience.
3. State priors and identifying constraints. Scale/center with recorded constants; do not assume a signed continuous score is positive.
4. Design prior observable checks and fixed-truth tests for any new nonlinear/latent code. Instantiate the relevant [code patterns](../examples/simulation-patterns.md), adjusting units/support.
5. Fit provisionally, inspect the full [computational bundle](../references/computational-diagnostics.md), and plan quantity-specific accuracy for final inference.
6. Choose targeted [PPCs](../references/posterior-predictive-checking.md) that could falsify important assumptions. Use observation-level and group/temporal checks as needed.
7. Specify evidence that would motivate each next expansion; preserve the working version. Compare/validate only when the prediction task is explicit. Plan material sensitivity or staged SBC conditionally.

Return:

```
Question / estimand / target:
Data structure and assumptions:
Minimal model and rationale:
Parameter units, priors and identification:
Simulation and implementation code:
Computational diagnostics and required QOI precision:
Targeted predictive checks:
Conditional expansion triggers:
Validation/sensitivity plan:
Current evidence and unresolved limitations:
```

If data/fits are unavailable, label the model and checks proposed rather than completed. Execute available authorized implementation/checks; do not end at a generic recommendation when code/data can be inspected.

# Elicit and validate priors iteratively

## Prior elicitation

**Question:** What prior information or regularization is defensible, and what observable behavior does it induce?

**Prerequisites:** Scientific units, outcome support, predictor scaling, sampling design and likelihood. Distinguish weak regularization from externally informed prior knowledge. Obtain reference values from domain knowledge/external evidence; do not present priors fitted to the analysis outcome as independent prior information.

**Computation:** Python: PreliZ distributions, `quartile` or `maxent` under explicit constraints; observable-scale simulation/`ppe` or `predictive_explorer` when supported. R: solve distribution parameters from quantiles/CDF constraints directly; SHELF offers structured expert elicitation, but is not a full PreliZ API counterpart. brms/CmdStan simulate prior predictions and derived quantities. See language branches.

**Interpretation:** Plausible marginal parameter priors can induce implausible joint observables, particularly across many predictors, nonlinear links and hierarchical levels. An interval constraint describes probability mass, not necessarily a hard support bound. Maximum entropy depends on the chosen family/support and constraints; it does not create a uniquely objective prior.

**Likely causes:** Unit mismatch; identical coefficient priors despite different predictor scales; variance/SD/rate confusion; overly broad positive scale priors; independent priors generating extreme combinations; hierarchical shrinkage inconsistent with group variation; inappropriate extrapolation.

**Do NOT:** Assume “vague” implies harmless, pick a default distribution solely because it is available, conflate a credible interval with support, or elicit only an unobservable coefficient while ignoring its joint predictions.

**Actions:**

1. State information source and scientific quantities: slopes per meaningful change, odds/risk differences at representative covariates, expected counts at exposure levels, between-group SD, prevalence and tail risks.
2. Translate quantiles/intervals or probabilities into a candidate distribution on a declared scale. For nonlinear links, check induced observable quantities at several covariate settings. Record constraints and discrepancies when they cannot all be satisfied.
3. Simulate the full generative model across plausible and extrapolative design points, including group effects and measurement/censoring processes. Examine extreme/impossible outcomes and derived quantities.
4. Revise the family, scale, correlations or model structure for an explicit reason; simulate again. Fit after the prior predictive checks are useful, then inspect sensitivity to defensible alternatives.

**Follow-up:** Prior predictive revalidation after every prior/scaling/likelihood change; computation, PPC and sensitivity after fitting. Keep the elicitation source, constraints, selected prior and induced-prior plots.

**Evidence:** E05/E06/E12 (`direct-eabm`, `eabm-code`); PreliZ/SHELF official documentation (API/workflow); R quantile solution (`translated`); external-information safeguard (`synthesized`).

## Choosing the scale

| Quantity | Useful elicitation | Induced check |
|---|---|---|
| Location | Plausible median and central interval in outcome units | Outcomes, not just location parameter |
| Positive scale | Quantiles for SD/dispersion/rate on the correct parameterization | Tail probability and maxima; weakly informed scales can dominate predictions |
| Regression effect | Change per scientifically meaningful predictor increment | Predictions at typical/extreme covariates; interactions jointly |
| Probability/proportion | Quantiles/probabilities on probability or logit scale | Baseline risk plus effect jointly; boundary behavior |
| Hierarchy | Plausible group variation and correlations | Distribution of groups, new-group predictions and small-group extremes |
| Robust likelihood | Tail/outlier probabilities, not just degrees of freedom | Predictive tails; finite variance only if the chosen degrees of freedom support it |

If no one-dimensional family satisfies elicited constraints, investigate inconsistent judgments, use an appropriate richer family/mixture, or keep uncertainty about the prior itself. Do not manufacture precision by choosing a least-squares fit without reporting its mismatch.

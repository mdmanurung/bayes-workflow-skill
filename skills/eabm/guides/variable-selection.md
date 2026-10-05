# Select variables only after defining the purpose

## Predictive selection and projective inference

**Question:** Is the goal prediction with fewer measurements, regularization, a scientific effect, or causal adjustment?

**Prerequisites:** A scientifically valid candidate/reference model with adequate computation, predictive criticism and useful out-of-sample performance. A variable's causal role cannot be inferred from its LOO contribution. Define measurement costs, predictive target and candidate restrictions (e.g. interaction hierarchy).

**Computation:** Python: fit a regularized Bambi reference model and use `kulprit.ProjectionPredictive`, `project`, `compare` where its family/search supports the task. R: a supported reference model for `projpred::cv_varsel(..., validate_search=TRUE)`, `suggest_size` and `project`. Selection search needs its own validation, distinct from merely scoring an already chosen submodel. Shrinkage priors in PyMC/brms/Stan are alternatives to discrete selection, not identical operations.

**Interpretation:** Projection seeks smaller predictions close to the reference predictive distribution, transferring information from a regularized reference posterior. It is not refitting each subset under arbitrary new priors. A selected variable can be a proxy for correlated predictors; exclusion does not show no scientific effect. Coefficient magnitude, inclusion/search order, causal importance and predictive utility are different quantities.

**Likely causes:** Collinearity; weak information; overflexible reference; missing causal adjustment; too many models searched on the same CV results; an unsuitable projected family; unmeasured or costly variables required at prediction time.

**Do NOT:** Drop confounders because they lack predictive gain, interpret predictive selection as discovering causes, run exhaustive LOO searches without selection-bias control, or project from an inadequate reference model.

**Actions:**

1. For causal effects, establish adjustment using domain knowledge/design/causal assumptions before considering predictive parsimony. Keep required adjustment variables even when their standalone predictive score is small.
2. For prediction, improve and regularize the reference; verify its PPCs and held-out target. Use interpretable prior scales and shrinkage appropriate to the design.
3. Validate search with the package's supported procedure or outer folds/test data. Inspect variability of selected subsets and predictive loss versus size, rather than choosing the single minimum loss mechanically.
4. Choose a size reflecting unresolved predictive differences, measurement costs and stability; evaluate actual deployable predictions. Respect interaction/hierarchy constraints.

**Follow-up:** Computational and targeted predictive checks for reference/projected predictions; held-out performance and selection stability; report search procedure, reference specification and uncertainty. Parameter inference for a selected model needs careful interpretation after search.

**Evidence:** E11 (`direct-eabm`, `eabm-code`); M-PROJ (`method-paper`); kulprit/projpred official implementation (API); R (`translated`); causal-purpose routing (`synthesized`, outside EABM's predictive-selection example).

## Capability boundary

Python **does** have an EABM-demonstrated projection package, kulprit. Do not report “no Python projection equivalent.” Its supported models, clustering, search validation and diagnostics differ from projpred: feature parity is **partial**. Inspect the installed adapter/family support before promising validated CV search. If unavailable, use explicit outer validation or retain a regularized reference model rather than inventing a wrapper.

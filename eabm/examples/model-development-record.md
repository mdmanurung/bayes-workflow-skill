# Model-development record

Copy this record for each substantive change; retain failed fits and earlier diagnostic evidence.

```yaml
M0:
  purpose: scientific estimand and predictive task
  assumptions: support, design, hierarchy, dependence, observation process
  priors: distribution, parameterization, units, source and induced predictions
  inference: backend/version, chains/warmup/draws, parameterization
  diagnostics: warnings, R-hat, bulk/tail ESS, estimand MCSE, geometry
  PPC: targeted features, population/conditioning, discrepancies
  sensitivity: alternatives/components, alpha, approximation diagnostics, MCSE
  decision: retain/revise/unresolved, with evidence and limitations
M1:
  change_from_M0: explicit probability-model or parameterization change
  reason: scientific hypothesis and evidence motivating it
  improvement_sought: computation / adequacy / prediction / interpretation
  prior_predictive: induced prior revalidation
  diagnostics: full recheck and remaining issues
  PPC: original failure plus new plausible failures
  sensitivity: conclusions and precision under justified alternatives
  comparison: task, unit, compatible likelihoods, PSIS/folds, paired uncertainty
  decision: what improved, what remains unresolved, next action
```

## Worked change: Normal → Student-t likelihood

- **M0 purpose:** Estimate location and predict new standardized continuous observations. Proper location/scale priors are simulated and checked against a toy scale.
- **Evidence:** Tail-contaminated simulated data; inspect maxima/tail frequency and dispersion alongside the mean. Run computation before reading the PPC.
- **M1 change:** Fixed nu=5 Student-t likelihood with the same location prior and an explicitly recorded scale prior. This changes the probability model, not just the sampler.
- **Reason:** Test a scientifically plausible heavy-tail mechanism. Student-t scale and Normal SD differ; interpret derived SD/predictive quantiles consistently.
- **Verification:** Fresh prior prediction, computation, the same targeted PPC features, matched response/unit LOO with Pareto diagnostics and paired uncertainty, then sensitivity of the scientific location.
- **Decision:** Use the actual files from `python-workflow.py`; no score automatically selects M1. State tail adequacy, numerical precision, high-k repairs and remaining target/assumption limits separately.

For a noncentered hierarchy, the model-development entry should instead show that the transformation preserves the intended prior and likelihood. Its primary improvement is computational geometry; PPC/prediction changes should be within numerical uncertainty when the probability model is unchanged.

Evidence: E15 iteration (`direct-eabm`); record/template/action accounting `synthesized`.

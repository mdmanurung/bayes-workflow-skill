# Python sensitivity recipes

See [sensitivity reasoning](../guides/sensitivity.md). ArviZ's current implementation supplies local power sensitivity; do not infer an automatic full priorsense adapter from similar names.

## Local power scaling with an explicit approximation gate

**Purpose:** Diagnose sensitivity of named posterior quantities to selected prior/likelihood strengths.

**Inputs:** DataTree with `posterior`, `log_prior`, `log_likelihood` evaluated at matching draws. Use `pm.stats.compute_log_prior` / `pm.compute_log_likelihood` within the correct model (or the still-supported log-prior idata option). The log-likelihood idata option is deprecated in PyMC 6.3; prefer the explicit compute call.

**Assumptions:** Valid selected factors and parameter measure; finite/proper powered targets; adequate base MCMC. For a hierarchy, select the intended hyperprior terms explicitly.

**Code:**

```python
import json
from pathlib import Path
import numpy as np
import arviz as az
from arviz_stats.base import array_stats

# `skill_dir` is the discovered installed skill directory, not the user's cwd.
registry = json.loads((Path(skill_dir) / "references/thresholds.json").read_text())
alphas = registry["power_sensitivity"]["alphas"]
prior_terms, likelihood_terms = ["mu", "sigma"], ["y"]
table = az.psense_summary(dt, var_names=["mu"],
                         prior_var_names=prior_terms,
                         likelihood_var_names=likelihood_terms,
                         alphas=tuple(alphas))

# Each selected variable can have non-sampling dimensions; sum those factors.
weight_diagnostics = []
for group, terms in [("log_prior", prior_terms), ("log_likelihood", likelihood_terms)]:
    total = None
    for name in terms:
        factor = dt[group][name]
        event_dims = [d for d in factor.dims if d not in ("chain", "draw")]
        factor = factor.sum(event_dims) if event_dims else factor
        total = factor if total is None else total + factor
    log_component = total.transpose("chain", "draw").values.reshape(-1)
    # Conservative MCMC efficiency for selected factors; investigate unstable ESS.
    n = log_component.size
    reff = min(1.0, float(np.asarray(az.ess(total, method="mean"))) / n)
    for alpha in alphas:
        log_ratios = (alpha - 1) * log_component
        # arviz-stats 1.3 negates its input internally (LOO convention):
        lw, k = array_stats.psislw(-log_ratios, r_eff=reff)
        weights = np.exp(lw)  # PSIS returns normalized log weights
        weight_diagnostics.append({"component": group, "alpha": alpha,
                                   "pareto_k": float(k),
                                   "weight_ess": float(1 / np.sum(weights**2))})
print(table, weight_diagnostics)
# After validating every alpha used by the plot as well:
az.plot_psense_quantities(dt, var_names=["mu"], prior_var_names=prior_terms,
                         likelihood_var_names=likelihood_terms, alphas=alphas, mcse=True)
```

**Expected output:** CJS-based local derivative table and alpha-specific PSIS k/weight ESS; quantity plot with MCSE. Weight ESS is an IS concentration diagnostic, not interchangeable with MCMC ESS or a complete MCSE estimate.

**Interpretation:** Use prior/likelihood patterns jointly and inspect practical quantity changes. A local perturbation cannot reveal unsupported regions or alternative likelihood families. The plotted alpha range needs its own diagnostics, even if wider than the local derivative range.

**Failure modes:** Densities summed over chain/draw by mistake; `lp` used as prior; wrong hierarchy component; poor overlap; raw PSIS low-level API changes; rounding hides a borderline score.

**Next action:** Verify weights/precision; refit defensible alternatives for consequential findings or bad overlap; validate every new fit and targeted PPC.

**Source:** E06/M-SENSE/M-PSIS; public current `arviz_stats.base.array_stats.psislw` signature and internal sign convention checked; pass **negative log ratios** in 1.3. This differs from legacy `az.psislw` and R `loo::psis`, which accept log ratios directly. Explicit alpha gate `synthesized` from methods. Verify this lower-level API again on upgrades.

## Refit alternatives

**Purpose:** Check broader prior-family or likelihood changes for the same scientific quantity.

**Inputs:** Separate valid fits; matched estimand definitions and scientifically justified priors/likelihoods.

**Assumptions:** Both computationally adequate; a Normal SD and Student-t scale are not the same population SD.

**Code:**

```python
means = {name: az.summary(fit, var_names=["mu"], round_to=5)
         for name, fit in {"base": dt_base, "alternative": dt_alternative}.items()}
# Compare mean/quantiles and their MCSE, then the same targeted PPC quantities.
```

**Expected output:** Matched estimand summaries; the model-fitting call is model-specific, not hidden in an abstraction.

**Interpretation:** Compare practical changes and numerical error; preserve intended changes in information and tail behavior.

**Failure modes:** Different scientific estimands, unchecked alternative fit, choosing a prior for a preferred result.

**Next action:** Report robustness/sensitivity and retain rationale; repeat comparison only if the predictive decision benefits.

**Source:** E06 (`direct-eabm`); recipe `synthesized`.

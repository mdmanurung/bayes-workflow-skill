# Python projection and inference validation

## Projection from a reference model

**Purpose:** Find smaller predictive models while retaining information from a validated reference posterior.

**Inputs:** Supported Bambi `reference_model`, its adequate `dt_ref`, candidate terms, measurement-cost/size objective.

**Assumptions:** Reference predictive adequacy and target established; installed kulprit family/search supports the model. Predictive selection is separate from causal adjustment.

**Code:**

```python
import kulprit as kpt
projection = kpt.ProjectionPredictive(reference_model, dt_ref, rng=23)
projection.project(method="forward", num_samples=200,
                   require_lower_terms=True)
table = projection.compare(stats="elpd")
print(table)
```

**Expected output:** Projected candidate/search results and predictive-loss table; does not by itself establish that the entire search has independent validation.

**Interpretation:** Search order/retained variables reflect predictive utility relative to the reference and correlations. Retain required causal adjustment separately.

**Failure modes:** Inadequate reference; unsupported family/adapter; interpreting repeated score search as unbiased evaluation; ignoring cluster weights in projected draws.

**Next action:** Validate search using a supported procedure or outer validation, inspect size/stability/cost and critique the chosen predictions. Do not assume projpred's `validate_search` has a Python keyword counterpart.

**Source:** E11 (`eabm-code`), M-PROJ, D-KULPRIT; capability limits `synthesized`.

## Manual SBC with an analytic reference

**Purpose:** Demonstrate valid ranks and test the SBC mechanics against known inference before applying them to a custom sampler.

**Inputs:** Proper Normal prior, Normal likelihood with known SD, independent posterior draws, many independently seeded simulated datasets.

**Assumptions:** Continuous ranks (ties probability zero here); generative and fitting models agree. This checks an analytic example, not a custom Stan implementation.

**Code:**

```python
import numpy as np
from scipy.stats import norm
rng = np.random.default_rng(41)
n, prior_sd, noise_sd, rank_draws = 12, 2.0, 1.0, 100
ranks = []
for _ in range(200):  # illustrative smoke count, not a calibration guarantee
    truth = rng.normal(0, prior_sd)
    y = rng.normal(truth, noise_sd, n)
    variance = 1 / (1 / prior_sd**2 + n / noise_sd**2)
    mean = variance * y.sum() / noise_sd**2
    draws = rng.normal(mean, np.sqrt(variance), rank_draws)
    ll_truth = norm.logpdf(y, truth, noise_sd).sum()
    ll_draws = norm.logpdf(y[None, :], draws[:, None], noise_sd).sum(axis=1)
    ranks.append((np.sum(draws < truth), np.sum(ll_draws < ll_truth)))
```

**Expected output:** Two discrete rank arrays (parameter and data-dependent joint likelihood) for rank histograms/ECDF comparisons with simulation uncertainty. For discrete quantities, randomize among the ranks occupied by ties; do not apply continuous code unchanged.

**Interpretation:** Uniform patterns are consistent with calibration at the simulation design's resolution; they do not prove correctness. A deliberately biased posterior should produce a detectable departure as a positive control. Real MCMC rank draws require correlation safeguards and fit-failure tracking.

**Failure modes:** Too few simulations; using dependent rank draws; inconsistent likelihood test quantities; shared generator/fitter bug; silently discarding failures.

**Next action:** Replace only the inference step with the actual fitting implementation; preserve truth/generator and test quantities, validate each fit and rerun the simulation ensemble.

**Source:** E13/M-SBC-PRIOR/M-SBC (`method-paper`); analytic code `synthesized`. Runnable version: [example](../examples/analytic-sbc.py).

## simuk adapter route

**Purpose:** Use supported PyMC/Bambi simulation and fitting machinery without assuming generic Stan backend support.

**Inputs:** Model and correctly configured simulator/data updater; version-checked simuk.

**Assumptions:** Inspect the adapter's parameter/data generation and return contracts. Retain fit failures and choose derived/data-dependent test quantities.

**Code:**

```python
import simuk
sbc = simuk.SBC(model, method="prior", num_simulations=200, seed=41,
                sample_kwargs={"draws": 1000, "tune": 1000, "chains": 4},
                keep_fits=True)
sbc.run_simulations()
rank_data = sbc.simulations
if len(sbc.posteriors) != sbc.num_simulations:
    raise RuntimeError("Incomplete SBC fits: inspect errors; do not drop failures")
print(rank_data)
# Keep fits/diagnostics; inspect rank dimensions before plotting.
# Use a simulator/updater for nonstandard or mutable observation structures.
```

**Expected output:** SBC object, retained fits and rank DataTree stored in `sbc.simulations`; inspect failures and rank dependence. Constructor alone does not validate SBC. `run_simulations()` returns None in 0.3. Model adapters and execution methods are package-version dependent.

**Interpretation:** For `method="posterior"`, use the verified original-plus-synthetic data construction and package inputs; it is a separate conditional method.

**Failure modes:** Book's `import simuk as sim` / `simuk.SBC` alias typo; unsupported model; wrong updated observation shape; confusing constructor with an executed test.

**Next action:** Inspect official execution API, run a small independently checked pilot, then a powered calibration study. If adapter semantics are unavailable, use the transparent manual workflow, not guessed methods.

**Source:** E13 (`direct-eabm`), D-SIMUK installed source; adapter setup official implementation extension.

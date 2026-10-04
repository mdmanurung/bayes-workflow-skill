# R projection and inference calibration

## Validated projection search

**Purpose:** Find a useful small predictive model relative to a regularized reference.

**Inputs:** Supported reference model (e.g. brms/rstanarm adapter), adequate fit/PPC, target and size/cost objective.

**Assumptions:** Installed projpred supports reference/family; search validation enabled and interpreted correctly; scientific adjustment requirements retained.

**Code:**

```r
selection <- projpred::cv_varsel(
  reference_fit, method = "forward", cv_method = "LOO", validate_search = TRUE
)
size <- projpred::suggest_size(selection)
projection <- projpred::project(selection, nv = size)
plot(selection)
```

**Expected output:** Validated search/size-performance summary and projected posterior, conditional on the reference and package settings.

**Interpretation:** Size suggestion is a decision aid; inspect its criterion, uncertainty, costs and subset stability. Projection predictions need cluster weights where clustering is used; do not treat all projected draws as equally weighted without checking.

**Failure modes:** Unsupported reference/model family; inadequate reference; unvalidated search; selected variables mistaken for causes; required interaction hierarchy lost.

**Next action:** Critique selected predictions and validate deployable performance; report reference/search uncertainty and adjustment rationale.

**Source:** E11/M-PROJ reasoning; D-PROJPRED (`translated`).

## Custom Stan prior SBC

**Purpose:** Validate a fitted Stan implementation across generative experiments.

**Inputs:** `SBC` and `cmdstanr`, compiled model with parameter `mu`, independently checked generator; [toy Stan file](../examples/normal-known-scale.stan) for the workflow contract.

**Assumptions:** Proper priors; generator and model agree; independently checked likelihood; correlation/tie handling and fit-failure recording. Replace toy model with the actual custom model before claiming it is validated.

**Code:**

```r
library(SBC)
generator <- SBC_generator_function(function(N) {
  mu <- stats::rnorm(1, 0, 2)
  list(variables = list(mu = mu),
       generated = list(N = N, y = stats::rnorm(N, mu, 1)))
}, N = 12)
datasets <- generate_datasets(generator, n_sims = 200)
model <- cmdstanr::cmdstan_model("normal-known-scale.stan")
backend <- SBC_backend_cmdstan_sample(
  model, chains = 4, iter_warmup = 1000, iter_sampling = 1000
)
result <- compute_SBC(datasets, backend, cores_per_fit = 4)
plot_rank_hist(result)
plot_ecdf_diff(result)
```

`data` and `parallel_chains` are managed by SBC's backend; do not pass competing values. Inspect result diagnostics and failures before interpreting ranks. Add scientific and **data-dependent** test quantities using the documented `dquants` callback contract; for joint likelihood, evaluate the same simulated dataset at truth and posterior parameter draws. Do not assume every derived-quantity callback receives the same object in both roles; check the actual SBC version. The [analytic R example](../examples/analytic-sbc.R) demonstrates this quantity transparently without a backend abstraction.

**Expected output:** Simulated datasets, fits/calibration metrics, rank histograms/ECDF difference bands and fit diagnostics. Draw/simulation counts are illustrative, not a power guarantee.

**Interpretation:** Rank departures are evidence of a calibration/inference/generator issue; ordinary diagnostic passes do not exclude coding bugs. Calibration under toy prior simulations does not establish real-data model adequacy.

**Failure modes:** Incorrect backend arguments; wrong generator return fields; autocorrelated rank draws; tied discrete ranks; common generator/model error; deleted failures; parameter-only checks missing ignored-data bugs.

**Next action:** Inspect failure contexts/quantities, compare against analytic or independent implementation, fix mechanism, rerun calibration and separately perform prior predictive/PPC/scientific checks.

**Source:** E13/M-SBC-PRIOR/M-SBC; D-SBC/D-SBC-ECDF (`translated`). CmdStan compilation/full SBC ensembles are documentation-verified, not executed in the skill audit.

## Analytic/manual route

**Purpose:** Verify the calibration mechanics and shared R/Python statistical logic with a known posterior.

**Inputs:** Normal prior/known-scale Normal likelihood, independent posterior draws.

**Assumptions:** Continuous quantities here; randomized ties required for discrete ranks; sufficient simulations for a chosen diagnostic resolution.

**Code:** Run `Rscript examples/analytic-sbc.R output-directory`. It computes parameter and joint-likelihood ranks and a deliberately biased positive control.

**Expected output:** CSV rank records, histograms and diagnostic summary, with all simulations retained.

**Interpretation:** This validates the example's mechanics; it is not a runtime test of the user's custom sampler.

**Failure modes:** Mistaking a small smoke test for proof; replacing likelihood/priors in the fitter without updating generator; independent seeds missing.

**Next action:** Replace the analytic inference step with the actual implementation and preserve all checks/records.

**Source:** M-SBC and E13; analytic workflow (`translated`, example `synthesized`).

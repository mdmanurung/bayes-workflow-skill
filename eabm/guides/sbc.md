# Validate inference with simulation-based calibration

## SBC

**Question:** Does the implementation/inference algorithm yield calibrated posterior inference under the stated generative model?

**Prerequisites:** A valid prior/data generator, posterior-fitting implementation, quantities with correctly handled ties, a replication plan and recorded computation failures. The generator should be independently checked; two implementations sharing the same bug can agree. Proper generative priors are required for prior SBC.

**Computation:** Repeat **draw parameters → simulate data → fit → validate each fit → rank the generating truth among posterior draws**. Include scientific derived quantities and data-dependent quantities such as joint log likelihood. Python: tested manual loop; simuk's official model/simulator API where supported. R: `SBC_generator_function` → `generate_datasets` → `SBC_backend_cmdstan_sample` → `compute_SBC` → `plot_rank_hist`/`plot_ecdf_diff`. Use the actual backend contract, not an invented R↔Python wrapper.

**Interpretation:** With exact posterior draws and suitable random tie handling, truth and posterior draws are conditionally exchangeable; ranks are discrete uniform across replications. A single posterior need not equal the prior. Systematic rank patterns can indicate bias or dispersion failure, but correlations, ties, too few simulations and poor fits can also distort them. Histogram shape alone does not uniquely identify a bug.

**Likely causes:** Incorrect likelihood or prior; parameter transforms/Jacobians; data indexing; inference bias; autocorrelated rank draws; nonconvergence; inconsistent generator and fit; wrong test quantity; reused seeds; deterministic/discrete ties.

**Do NOT:** Call SBC a real-data adequacy test, discard failed fits, assume ordinary convergence diagnostics establish correctness, or conclude parameter ranks validate the use of all data. An algorithm returning prior draws can pass marginal parameter ranks; add informative data-dependent quantities.

**Actions:** Verify a small generator and analytically tractable case; run enough simulations for the deviation of interest; record all fit failures separately. Use package rank-thinning/ESS safeguards or defensibly near-independent rank draws while keeping the full fit for estimation. Handle discrete ranks with randomized ties. Investigate systematic deviations by parameter, simulation context and test quantity; cross-check another implementation/analytic result and repair the mechanism.

**Follow-up:** Rerun affected SBC quantities and computation after implementation changes; broaden simulations when a local repair passes. Proceed to prior predictive/PPC checks for scientific adequacy separately. Report simulation count, posterior rank sample count, uncertainty bands, failures and power limitations.

**Evidence:** E13 (`direct-eabm`, `eabm-code`); M-SBC-PRIOR/M-SBC (`method-paper`); SBC/simuk official API; R (`translated`); analytic-example smoke test (`synthesized`).

## Distinguish the checks

| Check | What it asks | What it does not establish |
|---|---|---|
| Prior predictive | Are model-generated outcomes plausible before data? | Posterior algorithm correctness |
| PPC on real data | Which observed features the fitted model fails to reproduce | Valid inference or model truth |
| Fixed-parameter recovery | Behavior at selected truth/data configurations | Calibration across the prior; exact point recovery is not required |
| MCMC diagnostics | Evidence of adequate exploration/numerical precision for a fit | Correct probability program or plausible likelihood |
| Prior SBC | Calibration across prior-generative experiments | Real-data adequacy or power to detect every bug |
| Posterior SBC | Calibration conditional on an original dataset, using the method's augmented-data construction | Global calibration over all prior-supported data |

## Posterior SBC is a separate conditional method

The conditional method uses draws from the original posterior to simulate additional data and fits the posterior conditional on **original plus simulated** information (or its mathematically equivalent conditional construction). Simply simulating from the posterior and refitting synthetic data using the original prior is not the method. Use M-SBC-POST and supported simuk `method="posterior"` semantics; inspect `trace`, `augment_observed`, `update_data` and simulator behavior. EABM discusses the idea but its snapshot marks implementation as forthcoming; current package support is an extension. The method paper is a preprint at this source snapshot. Do not improvise an R adapter without validating the conditional likelihood/data augmentation.

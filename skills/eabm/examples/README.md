# Worked examples

| Example | Demonstrates | Runtime scope |
|---|---|---|
| [python-workflow.py](python-workflow.py) | Normal/t criticism, diagnostics, targeted tails, power sensitivity, pointwise LOO, MM and subsampling | Actual PyMC/ArviZ integration; see final QC for results |
| [analytic-sbc.py](analytic-sbc.py) / [analytic-sbc.R](analytic-sbc.R) | Exact posterior parameter and log-likelihood ranks with biased positive control | Both executed; calibration smoke test, not full inference certification |
| [analytic-workflow.py](analytic-workflow.py) / [analytic-workflow.R](analytic-workflow.R) | Shared arrays/likelihoods, diagnostics, sensitivity and exact analytic LOO cross-language validation | See runtime report |
| [normal-known-scale.stan](normal-known-scale.stan) | Minimal custom-model/SBC generator contract | Source/API checked; compilation not claimed |
| [hierarchical-targets.md](hierarchical-targets.md) | Existing/new groups, time, joint/conditional likelihoods, Normal/t comparability | Statistical worked decisions |
| [model-development-record.md](model-development-record.md) | Explicit model evolution and evidence | Reusable template plus worked decision |

Run examples with an explicit scratch/output directory; they do not write into the installed skill or silently modify a user's fitted model. Examples use toy generative assumptions and illustrative draw counts. Source provenance, numerical thresholds and version differences are in `references/`; interpretation remains in `guides/`.

Read the [worked interpretation](worked-results.md) for observed checks, model-development decisions and limitations. Saved results/figures describe the recorded run; reruns can vary with numerical/platform defaults despite explicit seeds.

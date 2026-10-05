# Simulation-based calibration

Source: [sbc/sbc.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/sbc/sbc.R), Ch./Sec. 31. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Validate a Poisson mixture with logistic mixing weights |
| Initial model | Implement logistic and mixture parts separately |
| Why start there? | Separate logistic and mixture submodels make calibration failures attributable before the components are composed. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Build independent logistic/mixture generators and test subcomponents; synchronize ordered support and proper priors. |
| Computation | Track diagnostics/failures within repeated fits; changing support/priors requires consistent generator. |
| Statistical/model checks | Rank checks, contraction and data-dependent quantities expose whole-dataset mixing, unused parameter and double prior |
| Failure and competing diagnosis | Uniform marginal ranks can coexist with an unused parameter; mixture vectorization and double priors create separate errors. Use contraction, data-dependent functions and component SBC to localize rather than tune sampling blindly. |
| Intervention | Pointwise log_mix; consistent ordered simulator; repair redundant priors; staged SBC |
| Check after intervention | Rerun ranks, contraction/data-dependent checks and failure counts with exact matched simulator after each fix. |
| Comparison | Compare calibration before/after bugs and staged complexity; not real-data model adequacy. |
| Local implementation | SBC generator/backend; derived ranks; failure ledger |
| Transferable rule | Calibration and learning are distinct; a procedure returning its prior can pass marginal ranks |

Source caveat: Errata reverses Fano rejection inequality; conditional calibration must report restricted domain and failed fits.

## Reasoning to reuse

Observed behavior (rank checks, contraction and data-dependent quantities expose whole-dataset mixing, unused parameter and double prior) → distinguish implementation, information and model explanations → intervene (pointwise log_mix; consistent ordered simulator; repair redundant priors; staged sbc) → validate (rerun ranks, contraction/data-dependent checks and failure counts with exact matched simulator after each fix.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [latent-variable-model playbook](../playbooks/latent-variable-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

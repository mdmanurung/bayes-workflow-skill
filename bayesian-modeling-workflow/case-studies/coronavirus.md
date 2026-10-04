# Building toward hierarchical models

Source: [coronavirus/coronavirus.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/coronavirus/coronavirus.R), Ch./Sec. 19. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Prevalence with imperfect sensitivity and specificity |
| Initial model | Pooled binomial prevalence/test-calibration model |
| Why start there? | Pooled calibration is a tractable starting point for separating rare prevalence from false-positive/negative test rates. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Specify test calibration counts and prevalence observation map; inspect hyperprior implications/sensitivity. |
| Computation | Hierarchical scale geometry/priors and initialization considered; prevalence sensitivity is substantive. |
| Statistical/model checks | Between-study test heterogeneity and prevalence sensitivity to hyperpriors |
| Failure and competing diagnosis | At low prevalence, false positives and calibration uncertainty can dominate apparent positives. Between-study sensitivity/specificity variation and hyperprior sensitivity reveal weakly identified prevalence. |
| Intervention | Hierarchical sensitivity/specificity, calibrated hyperpriors, MRP scaffold |
| Check after intervention | Assess posterior prevalence under defensible hyperpriors/calibration and properly matched target weights. |
| Comparison | Pooling/heterogeneity/calibration sensitivity; MRP uses simulated inputs, not verified empirical comparison. |
| Local implementation | Non-centered calibration hierarchy; poststratified weights |
| Transferable rule | Partial pooling is a scientific exchangeability assumption; sparse low-prevalence data need external calibration |

Source caveat: Individual demographics and population cell data used for MRP are simulated.

## Reasoning to reuse

Observed behavior (between-study test heterogeneity and prevalence sensitivity to hyperpriors) → distinguish implementation, information and model explanations → intervene (hierarchical sensitivity/specificity, calibrated hyperpriors, mrp scaffold) → validate (assess posterior prevalence under defensible hyperpriors/calibration and properly matched target weights.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [hierarchical-model playbook](../playbooks/hierarchical-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

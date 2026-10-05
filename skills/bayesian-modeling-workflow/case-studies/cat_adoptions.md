# Incremental model development and testing

Source: [cat_adoptions/cat_adoptions.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/cat_adoptions/cat_adoptions.R), Ch./Sec. 22. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Adoption times with right censoring |
| Initial model | Geometric daily adoption hazard for adopted cats |
| Why start there? | A constant daily adoption probability gives a small executable duration model before adding censoring and heterogeneity. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Simulate adoption and administrative censoring; verify event versus survival likelihood on known data. |
| Computation | Compiled fit/summary checks and fake-data recovery localize implementation problems. |
| Statistical/model checks | Full observed data include censored records; fake-data fit and Kaplan-Meier curves |
| Failure and competing diagnosis | Ignoring unadopted cats conditions on adoption and biases duration inference. Include survival contributions and test simulated censored records to distinguish observation-process omission from sampler error. |
| Intervention | Add correct censored likelihood, compare imputation/alternative formulations, consider individual variation |
| Check after intervention | Refit simulated observed/censored records and compare empirical/replicated survival curves. |
| Comparison | Compare censored versus imputed/alternative observation formulations; no LOO result invented. |
| Local implementation | Event mass versus survival; known-data tests |
| Transferable rule | Implement the observation process before inferring duration or heterogeneity |

Source caveat: Continuous imputation demonstration should not be transplanted blindly to discrete event times.

## Reasoning to reuse

Observed behavior (full observed data include censored records; fake-data fit and kaplan-meier curves) → distinguish implementation, information and model explanations → intervene (add correct censored likelihood, compare imputation/alternative formulations, consider individual variation) → validate (refit simulated observed/censored records and compare empirical/replicated survival curves.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [model-expansion playbook](../playbooks/model-expansion.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

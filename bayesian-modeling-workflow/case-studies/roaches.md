# Leave-one-out cross-validation

Source: [roaches/roaches.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/roaches/roaches.R), Ch./Sec. 24. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Overdispersed apartment counts with exposure |
| Initial model | Poisson regression with log exposure offset |
| Why start there? | Poisson regression maps count rates/exposure directly; its variance assumption gives a specific falsifiable starting point. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Inspect counts, exposure and predictors; verify offset and response support. Comprehensive prior PPC is not the main demonstration. |
| Computation | Fit reliability first; high-k conditional latent likelihood and integrated scoring are major concerns. |
| Statistical/model checks | PPC dispersion, zero reliability, high k, and overly optimistic observation-specific latent fits |
| Failure and competing diagnosis | Wrong dispersion produces misfit/high influence; an observation-level latent effect can instead hide in-sample misfit while giving unreliable conditional LOO. Compare targeted zero/spread checks and integrated held-out likelihood to separate the causes. |
| Intervention | Negative binomial, zero inflation when supported, moment matching, K-fold, integrate held-out latent effect |
| Check after intervention | Recheck spread/zeros/conditional reliability, PSIS and effects; compare integrated scores to matching refits. |
| Comparison | Moment matching, exact/refit or K-fold, paired elpd, integrated latent likelihood and LOO checks. |
| Local implementation | Chain-aware PSIS; marginal latent log likelihood |
| Transferable rule | High k can expose both unstable importance sampling and substantive misspecification |

Source caveat: Errata corrects zero fraction to 36%; repaired PSIS is not a repaired model.

## Reasoning to reuse

Observed behavior (ppc dispersion, zero reliability, high k, and overly optimistic observation-specific latent fits) → distinguish implementation, information and model explanations → intervene (negative binomial, zero inflation when supported, moment matching, k-fold, integrate held-out latent effect) → validate (recheck spread/zeros/conditional reliability, psis and effects; compare integrated scores to matching refits.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [high-pareto-k playbook](../playbooks/high-pareto-k.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

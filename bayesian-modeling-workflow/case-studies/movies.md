# Iterative coding of model sequences

Source: [movies/movies.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/movies/movies.R), Ch./Sec. 16. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Quality ratings with unequal evidence and rater severity |
| Initial model | Normal rating model for two movies, then many movies |
| Why start there? | Two equal average ratings with unequal sample sizes expose uncertainty; additional raters then motivate crossed effects. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Simulate rating designs with differing numbers of ratings and rater severity before crossed-effect expansion. |
| Computation | Summary/parameterization checks along successive models; inference on rating means/scales is propagated. |
| Statistical/model checks | Compare simulated balanced and unbalanced rater designs; inspect posterior uncertainty |
| Failure and competing diagnosis | Unequal rater severity and who rates which movie can distort naive averages. Known balanced/unbalanced simulations identify the confounding and justify crossed partial pooling. |
| Intervention | Crossed movie/rater effects, anchored means and non-centered implementation |
| Check after intervention | Reproduce naive-versus-adjusted patterns on known balanced/unbalanced designs and inspect posterior uncertainty. |
| Comparison | Compare naive averages, uncertainty and simulated rater effects; not a LOO demonstration. |
| Local implementation | Successive Stan programs; crossed indices |
| Transferable rule | Build dimensions and grouping one executable change at a time; account for who supplied ratings |

Source caveat: Normal bounded ratings are an illustrative approximation rather than a universal ordinal model.

## Reasoning to reuse

Observed behavior (compare simulated balanced and unbalanced rater designs; inspect posterior uncertainty) → distinguish implementation, information and model explanations → intervene (crossed movie/rater effects, anchored means and non-centered implementation) → validate (reproduce naive-versus-adjusted patterns on known balanced/unbalanced designs and inspect posterior uncertainty.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [hierarchical-model playbook](../playbooks/hierarchical-model.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

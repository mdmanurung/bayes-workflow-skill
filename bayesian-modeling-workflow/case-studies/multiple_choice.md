# Introductory end-to-end workflow

Source: [multiple_choice/multiple_choice.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/multiple_choice/multiple_choice.R), Ch./Sec. 4. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Item difficulty and discrimination |
| Initial model | Binary logistic response versus student score |
| Why start there? | A simple response-versus-score model reveals observable item behavior before introducing unobserved ability. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Stress-test raw/scaled scores and coefficient scales with simulation; inspect answers and keys. |
| Computation | Fit summaries, slow/problematic raw-scale fits and parameter behavior motivate scaling/prior revisions. |
| Statistical/model checks | Stress simulations, answer-key discrepancies, implausible decreasing item response |
| Failure and competing diagnosis | Wrong-key items can resemble unexpected response curves. Inspect keys before treating the anomaly as discrimination; broad/raw-scale priors then explain implausible simulated responses. |
| Intervention | Correct keys, add guessing floor, item variation and then latent ability/discrimination |
| Check after intervention | Recheck item curves, scaled fits and latent parameter behavior after data/model changes. |
| Comparison | Successive fit/observable assessment; do not invent a final universal selection criterion. |
| Local implementation | Progressive Stan files; latent scale anchors |
| Transferable rule | Verify the data and prediction process before explaining anomalies with extra parameters |

Source caveat: Guessing probability 1/4 depends on four possible answers.

## Reasoning to reuse

Observed behavior (stress simulations, answer-key discrepancies, implausible decreasing item response) → distinguish implementation, information and model explanations → intervene (correct keys, add guessing floor, item variation and then latent ability/discrimination) → validate (recheck item curves, scaled fits and latent parameter behavior after data/model changes.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [model-expansion playbook](../playbooks/model-expansion.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

# Report the scientific claim with its reliability evidence

Before writing, identify the audience, estimands, numerical precision and model-development decisions. Describe uncertainty as uncertainty about a named quantity under explicit assumptions. A credible interval is not a statement that all assumptions are validated.

## Reporting checklist by destination

| Destination | Include |
|---|---|
| Main text | Scientific question, estimands/derived contrasts, practical magnitudes and uncertainty, the main predictive failures or successes relevant to the claim, sensitivity that changes conclusions, important limitations |
| Methods | Generative model/likelihood, links, units, grouping/dependence, missingness/censoring, every prior with parameterization and rationale, transformations/standardization, inference algorithm/backend, chains and retained/warmup draws where relevant, convergence/precision criteria |
| Supplement | Per-parameter and derived-quantity R-hat/bulk/tail ESS/MCSE where meaningful; divergences/treedepth/BFMI and remedies; trace/rank/geometry checks when needed; prior and targeted posterior predictive plots; sensitivity alternatives/importance diagnostics; comparison target, pointwise diagnostics, repaired high-k cases and uncertainty; model evolution/selection procedure; SBC results if used |
| Reproducibility materials | Data or access instructions, observation IDs, executable model/generator, version/seed/environment records, fitting and checking scripts, likelihood extraction/fold specification, model-development log and saved diagnostic objects; exact instructions to reproduce figures and scores |

Numerical reports must distinguish posterior SD/interval uncertainty from MCSE. Include MCSE for a consequential mean, tail probability or interval endpoint when it informs reliability; do not report meaningless moment MCSE for an infinite-moment target. Retain enough digits for decisions but avoid false precision. Summaries should show shape/multimodality where a single interval hides it; name interval type (ETI/HDI), mass, scale and conditioning population.

## Comparison reporting

State what is predicted, the held-out unit, available training information, scoring measure, likelihood normalization, CV/PSIS method, influential-unit diagnostics and repairs. Report paired ELPD differences with uncertainty, not just a ranked table. State large-data subsampling design/error or dependence-aware folds. Label stacking weights as predictive weights. Disclose the candidate/search process and selection validation.

## Caveats that must remain visible

Do not hide unresolved divergences, unreliable PSIS, prior-dependent conclusions, systematic PPC failures or scientific identification limits in a generic “all diagnostics satisfactory” sentence. If an inference limitation prevents a claim, state which claim remains unresolved and the next discriminating check. Explain whether a change improved computation, adequacy, prediction or interpretability; these are separate achievements.

Use [the model-development record](../examples/model-development-record.md) and keep validation artifacts. EABM's reporting chapter is short and emphasizes audience, substantive conclusions, assumptions and the workflow's evidence. The destination checklist is a **synthesized** application supplemented by M-REPORT, not a verbatim book checklist. R visualization with tidybayes/ggdist is **translated**; check the relevant draw/interval semantics.

Evidence: E01/E03/E14/E15 (`direct-eabm`), M-REPORT/M-VIS (`method-paper`), destination routing (`synthesized`).

# Adversarial validation results

Date: 2026-10-04. Two fresh agents were given task-local questions and the skill path, with **no expected answers, prior diagnosis or conversation history**. They read relevant resources and answered the tasks. No model fit was supplied for the reasoning prompts. Raw outputs: [diagnostics](forward-diagnostics.md), [translation/scaling](forward-translation.md).

The primary author reviewed each answer against these requirements: distinguish evidence from unknowns; classify the possible failure; reject the proposed shortcut when unsupported; choose a discriminating next check; provide conditional interventions and follow-up; preserve statistical targets and provenance. This is a small qualitative forward test, not a benchmark estimate of agent accuracy.

| Prompt | Observed response | Assessment |
|---|---|---|
| R-hat 1.005: model fine? | One screen passes; requests ESS/MCSE, chain/sampler diagnostics and model criticism | Pass; no premature adequacy claim |
| 14 divergences: adapt_delta 0.999? | Localizes failures/support/scaling/geometry before bounded tuning; retains divergent draws | Pass; no automatic acceptance escalation |
| Choose from LOO table | Uses paired difference 3 versus SE 4.8; requests target/computation/Pareto/PPC evidence before deciding | Pass; no mechanical winner |
| Two Pareto-k 1.2: ignore? | Retains valid units; diagnoses influence and repairs via supported MM/refits/folds | Pass; estimator/model distinction intact |
| PPC looks good: done? | Scope of checks unknown; targeted features, computation, sensitivity and scientific purpose still needed | Pass; comparison remains optional |
| Gaussian versus Student-t LOO? | Permits matched continuous observed-scale densities/task; normalization, Jacobian, scale semantics and reliability checked | Pass; no categorical ban |
| Stronger prior? | Diagnoses information/geometry/conflict/misspecification and validates induced predictions/refit sensitivity | Pass; no warning-driven tightening |
| Validate custom Stan | Separates implementation/analytic checks, fit diagnostics, prior SBC/data-dependent quantities and real-data criticism | Pass; no automatic Python-Stan adapter |
| ArviZ → R | Recovers legacy versions/defaults, preserves axes/units, maps summary/trace/PPC/LOO/weights with limitations | Pass; no function-name equivalence assumption |
| loo/bayesplot → Python | Current DataTree/results, unitwise efficiency workaround, exact sample-SD convention, MM prerequisites and partial projection parity | Pass after incorporating verified translation details into guides |
| Ten million observations | Separates fitting/storage/evaluation; probability subsampling, paired uncertainty, influence/approximation and target-specific folds | Pass; no mandatory full array/full refits |

## Weaknesses found and revisions

1. The translation agent found current `az.loo(reff=vector)` rejects R's unitwise efficiency vector. Its scalar-per-unit precomputed PSIS route ran; [unitwise recipe](../python/unitwise-psis.md) and parity/API records now explain the gap.
2. Exact R `sd` translation needs Python `ddof=1`. The verified observation-first t-stat callable and group statistics are now explicit.
3. The agent reported a missing QC link while the package was still being assembled. [The completed QC report](quality-control.md) resolves that packaging gap; the final resource audit checks it.
4. The fresh agent had no `Rscript` command and correctly did not claim R execution. The primary author used a separately provisioned local R 4.3.3 runtime to run the recorded R checks. Those are separate evidence streams.

Independent synthetic Python translation checks executed DataTree construction, axis transposition, likelihood-unit mean ESS, scalar-per-unit PSIS and precomputed-weight LOO, sample-SD PPC, rank plotting and comparison signs. These checks validate mechanics on small arrays, not a real scientific fit. Full transcripts preserve their exact scope and historical notes; later guide/API corrections are authoritative.

Primary-author runtime checks additionally exposed and fixed low-level PSIS input-sign conventions, simuk's stored-result/None-return behavior and additive versus total subsample updates. See [QC](quality-control.md) and [API verification](../references/api-verification.md). These were runtime-driven fixes, not leaked expected answers in the forward tests.

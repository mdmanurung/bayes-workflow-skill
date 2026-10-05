# Predictive model checking

Source: [nabiximols/nabiximols.R](https://github.com/avehtari/Bayesian-Workflow/blob/ceb65599292320fc7ddb565d73f8d6e41cfe7a64/nabiximols/nabiximols.R), Ch./Sec. 18. All model/helper/data paths are in [file inventory](../research/source-inventory.tsv); [evidence matrix](../research/evidence-matrix.md) records this case. Descriptions below are original analytical reconstruction; caveats identify absent demonstrations or additional inference.

| Workflow question | Evidence / action |
|---|---|
| Modeling problem | Treatment effect on bounded repeated counts of cannabis use |
| Initial model | Gaussian and binomial models for days used out of 28 |
| Why start there? | Simple Gaussian/binomial candidates expose whether the bounded use-count distribution and trial variance are adequate. Rationale reconstructed from prose/code, not a universal rule. |
| Before fitting | Plot bounded counts over time/groups; inspect the denominator, baseline conditioning and coefficient priors. |
| Computation | Fit diagnostics and high Pareto-k; PSIS repair differs from observation-model revision. |
| Statistical/model checks | Impossible values and excess dispersion/extreme 0/28 outcomes; predictive checks and high Pareto-k |
| Failure and competing diagnosis | Binomial sampling variability cannot reproduce the observed endpoint/dispersion patterns. Compare bounded replicated counts and reliability to support beta-binomial variation; inspect baseline to avoid treating pretreatment imbalance as treatment response. |
| Intervention | Beta-binomial; redefine baseline as pretreatment covariate; draw treatment contrasts |
| Check after intervention | Recheck 0/28 probabilities, reliability/PIT and draw-level treatment contrast at the same follow-up target. |
| Comparison | PPC, LOO/PIT and common-measure caveats; changed baseline/aggregate targets cannot be silently mixed. |
| Local implementation | Bounded count likelihood; posterior_epred contrasts |
| Transferable rule | Repair the observation process before interpreting effects; predictive ranking and treatment inference answer different questions |

Source caveat: re_formula=NA sets random effects to zero; population marginal means need integration.

## Reasoning to reuse

Observed behavior (impossible values and excess dispersion/extreme 0/28 outcomes; predictive checks and high pareto-k) → distinguish implementation, information and model explanations → intervene (beta-binomial; redefine baseline as pretreatment covariate; draw treatment contrasts) → validate (recheck 0/28 probabilities, reliability/pit and draw-level treatment contrast at the same follow-up target.). Where the source does not demonstrate a specific step, the table says so; the whole chain is a synthesis, not evidence of additional computations performed by the authors.

Start the [bad-ppc playbook](../playbooks/bad-ppc.md) and consult its canonical references. Do not copy local numeric priors, data restrictions or approximation assumptions into a different scientific analysis without re-deriving their implications.

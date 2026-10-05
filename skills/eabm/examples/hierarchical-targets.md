# Worked predictive-target decisions

## Existing patient versus new patient

Suppose repeated measurements follow `y_ij ~ Normal(alpha + u_j + beta*x_ij, sigma)`, `u_j ~ Normal(0,tau)`.

| Task | Retained information | Valid prediction/CV |
|---|---|---|
| Another measurement for a patient with history | Other measurements for that patient | Observation-level leave-out; learn `u_j` from the remaining history; inspect high k for short histories |
| First measurement for a new patient | Population training patients; no new-patient outcomes | Draw/integrate a fresh `u_new` from the population model; leave-patient-out validation |
| A future measurement at a later time | Only past measurements/covariates available at that horizon | Past-only training/time folds; include temporal structure rather than interpolation using future measurements |

**What to inspect:** explicit training information, unit IDs, conditional/group likelihood and held-out effect integration. **Why:** ordinary one-observation PSIS and a full-data fitted `u_j` may not represent a new-patient task. **Failure:** leakage or unstable local-effect IS. **Action:** explicit group/time folds or a validated integrated-likelihood approach. **Follow-up:** computation for every fold, group-specific PPC, calibration for fresh groups and uncertainty of paired group differences.

Reusing the same fitted group effect to generate a new-group prediction understates uncertainty. Merely setting a group effect to zero predicts at the population mean, rather than integrating its variation. Conditional PPC and new-group PPC answer different questions.

## Football: two likelihoods

The EABM case uses Poisson home/away scoring models, a log link and team attack/defence structure. Its notebook implementation, rather than a prose home/away mismatch, determines the actual model. For new-match joint prediction, sum **aligned** home/away log factors at each draw and create one match-level unit. This presumes their conditional independence given modeled effects. The same calculation holds in R arrays and Python labeled arrays.

Predicting home goals after seeing away goals is a different information set: omit only the home contribution and state that the away outcome remains observed. Concatenating two likelihood arrays defines separate response-level held-out units; it is not leave-match-out. Predicting an unseen team requires population/fresh-team effects and a new-team validation design, not just match sums.

**Follow-up:** inspect influential matches/teams, appropriate PSIS k for joint units, count/zero/tail/group PPCs and matched-unit ELPD uncertainty. Moment matching can improve IS without fixing a Poisson dispersion failure.

## Continuous likelihood alternatives

Gaussian and Student-t models can be compared on the same observed continuous response with complete normalized densities, the same held-out unit and information set. Compare meaningful location/prediction quantities, and remember Student-t `sigma` is a scale: its SD for nu>2 is `sigma*sqrt(nu/(nu-2))`. Tail robustness may improve specific PPCs even when a global score difference is uncertain.

If one model uses `z=log(y)`, score on the common `y` scale by including `-log(y)` in its log density. If one rounds/bins measurements while another models a latent continuous value, decide the observed measurement process first; raw density-versus-mass scores do not match.

## Multiple scientific tasks

For binary treatment adherence and continuous symptom response, first report task-specific scores/criticisms. A joint model can be scored for a stated joint omission with the joint observed-data density, but adding unrelated total scores without explaining the implied task weights obscures the decision. Do not fabricate a single summary merely because both packages return ELPD.

Evidence: E07/E10 (`direct-eabm`, `eabm-code`), M-LOO; repeated-measure/new-group/time decision examples and R branches `synthesized`/`translated`.

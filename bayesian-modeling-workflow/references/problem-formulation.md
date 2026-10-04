# Formulate the scientific and predictive task

Basis: F01–F04, H04 and L01 in [source map](source-map.md). Questions about missingness, transport and outcome families beyond the worked cases are explicitly transferable checks, not claimed author-supplied universal models.

## Write the target before the formula

Specify the quantity (mean difference, probability, rate ratio, latent trait, future outcome or decision utility), its units, time horizon and population. Distinguish a conditional coefficient from a contrast of predicted outcomes. For nonlinear links, averaging linear predictors then transforming generally differs from averaging transformed predictions. State conditioning variables and how target subjects/cohorts are weighted.

Map experimental unit, observational unit, repeated measures, clusters/cohorts, crossed membership and observation times. Record denominators, exposure windows, censoring, entry/selection, assay error and missing measurements. Establish whether baseline is an outcome to explain or a pretreatment predictor for a treatment comparison; nabiximols shows that this changes both estimand and scoring target.

Do not equate predictive improvement with a causal effect or a mechanistic explanation. Distinguish heterogeneity in observed trajectories or covariate-conditional treatment contrasts from variation in individual causal effects: a parallel-group trial does not observe both potential outcomes for any participant. A random-effect variance alone cannot identify their unobserved association without additional assumptions. This is supplemental scientific transfer supported by Ding, Feller and Miratrix, not a claim of a fully worked official case. Ask about randomization, confounding, post-treatment adjustment, informative dropout and transport assumptions when those affect the requested claim. These design questions cannot be settled by good MCMC or a low information criterion.

## Choose an observation model by process

| Observed outcome | Candidate starting process | Questions before accepting |
|---|---|---|
| Continuous signed measurement | Gaussian or robust location/scale | Are residual tails, heterogeneity or dependence relevant? Does the score legitimately take negative values? |
| Positive continuous | Lognormal/gamma or another positive mechanism | Is zero possible? Is error additive or multiplicative? What does mean versus median on the original scale mean? |
| Binary | Bernoulli with justified link | Is there separation, assay error, clustering or a selection process? |
| Successes out of known trials | Binomial; beta-binomial when extra variation is supported | Is the denominator correct? Are trials exchangeable/independent conditional on parameters? |
| Counts with exposure | Poisson offset; overdispersed alternatives when needed | Is exposure positive, proportional and correctly measured? Are excess zeros structurally plausible? |
| Ordinal categories | Ordered-category process when scientifically appropriate | Are thresholds identifiable and categories truly ordered? Do not import the movies Gaussian approximation unquestioningly. |
| Time to event | Event plus censoring/entry likelihood | Continuous or discrete time? Is censoring independent conditional on modeled variables? Competing events? |
| Latent/derived score | Explicit measurement model if uncertainty matters | Is the score signed, bounded or scale-arbitrary? Does plugging in an estimated score conceal uncertainty or leakage? |

These are candidate formulations, not a domain-free model prescription. Consider mixture/zero inflation only after checking exposure, heterogeneity and coding. For multi-cohort analyses distinguish cohort-level variation from individual repeated-measure variation; sparse cohorts do not identify elaborate cohort correlation matrices automatically.

## Four classes of failure

**Scientific/design:** no observable/design information identifies the requested effect, selection changes population, or conditioning changes the question. Check the DAG/assignment description where useful, exposure timing and target definition. Remedy is reframing, stronger explicitly defended assumptions or better data.

**Statistical:** the implemented and reliably sampled generator produces wrong observable behavior. Check targeted replicated data conditional on predictors/groups/time; compare competing mechanisms. Remedy is revising the responsible assumption.

**Prior/identification:** different parameter combinations imply nearly the same observables, priors permit meaningless scale or conclusions shift under defensible prior changes. Check design rank, recovery at several realistic truths, joint plots, prior predictions and posterior learning. Remedy is eliminating redundancy, regularizing, anchoring a meaningful scale or reporting a better-identified function.

**Computational:** accurate exploration/evaluation is inadequate. Check numerics, geometry, chains, energy and accuracy after accounting for the first three classes. A parameterization change may preserve the statistical model; a prior change changes it and needs predictive/sensitivity validation.

When data access is absent, provide a provisional generator and concrete inspection plan. Do not invent a likelihood family, correlations or patient-specific prior scales based on a generic scientific label.

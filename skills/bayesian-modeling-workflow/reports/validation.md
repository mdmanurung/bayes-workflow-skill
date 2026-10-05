# Validation report

Completed 2026-10-04. This report separates source coverage, executable checks, documented interfaces and reasoning exercises. Passing these checks does not certify a future scientific analysis.

## Source and authoring integrity

The full official tracked-file inventory and 23-row evidence matrix were completed before SKILL.md existed. The [checkpoint](../research/evidence-checkpoint.json) records that ordering and the matrix hash. All 296 tracked files are inventoried; all 52 R, 3 Rmd, 130 Stan and 6 Quarto sources were inspected at the scope recorded in the [coverage ledger](../research/coverage-ledger.md). All 23 case pages, home and five navigation pages were retrieved successfully. Data schemas/loading roles were inspected; this is not an audit of every raw value or a replay of historical fits. Secondary Python inspection was selective.

The source map registers 73 principle IDs and distinguishes direct demonstrations, recurring practices, synthesis, additional transfer and primary API supplements. Pinned official source targets were checked against the cloned tree. Errata and unresolved source interpretations are explicitly recorded.

## Executed checks

| Check | Execution and result | What it establishes |
|---|---|---|
| Skill metadata | Canonical skill-creator validator passed | Required frontmatter and valid skill naming |
| Structure/provenance | `python3 tests/validate_structure.py .` passed | Relative file links, registered reference IDs, all 23 case syntheses and evidence-before-authoring checkpoint; compact core |
| R syntax | R 4.3.3 parsed all 13 R pattern files and 6 fenced R example blocks | Syntax only for external-package fragments |
| Direct simulation | Seed 20261004; 50,000 Gaussian fixed-truth/prior draws, 100,000 covariance draws | Expected residual/prior moments and correct Cholesky covariance orientation; incorrect row orientation is distinguishable |
| Recursive replication | 30,000 three-trial sequences and one-trial edge case | Simulated histories feed subsequent probabilities; initial-trial convention matches the intended example |
| Targeted PPC statistic | Observed/replicated zero proportion fixture passed | Summary direction and replicated-data dimensions |
| Exact-draw SBC baseline | 4,000 simulations, 100 posterior draws each; rank chi-square 2.972711 with appropriate discrete-bin expectation; contraction and analytical risk checks passed | Scalar conjugate rank mechanics and learning; does not calibrate Stan/brms or a real-data model |
| SBC generator | Standalone Gaussian generator executed; design rank, vector shape, centered quadratic term and independently calculated data-dependent log-density truth passed | Simulator/data contract and likelihood truth; full SBC package backend not executed |
| Censoring algebra | Several hazards and deadlines, including zero deadline; binomial/geometric identities passed | Event and administrative-survival probabilities; not a Stan runtime fit |
| Latent integration | Standard-normal quadrature moments and one-node case passed; Q=81 integrals compared with independent adaptive R integration for counts 0/3/12 and scales .05/.5/1 | Accuracy on these fixtures, not a universal safe node count or broad tail guarantee |
| Stan syntax/types | All six full templates passed stanc3 2.39.0 with pedantic mode | Stan-to-C++ translation/type checks; see [compiler record](stan-compiler-checks.json) with source hashes and warnings |
| Representative Stan HMC | Gaussian template compiled to a native executable and ran four chains, 400 warmup and 500 retained draws each | Actual sampler/GQ smoke execution, separate from the R API; see [runtime record](stan-runtime-check.json) |
| Independent agent exercises | Four fresh task-solving agents completed new-analysis, crossed-effect geometry, latent LOO and SBC tasks | Playbook routing and reasoning generalization on those scenarios; see [exercise report](agent-exercises.md) |

## Representative HMC details

For N=80 fixed-design Gaussian data with truth alpha=.5, beta=.7, sigma=.4 and unit-scale proper priors, all 2,000 retained output rows were finite. There were zero post-warmup divergences and zero maximum-depth hits in all four chains. BFMI ranged approximately .93–1.20. Each truth lay inside its illustrative 98% posterior interval; one such recovery fit is not a coverage test. Saved means and normalized pointwise log likelihoods agreed with an independent calculation to at most 3.6e-15.

Basic split R-hat was approximately 1.00 for the three parameters. It is explicitly labeled a classical smoke diagnostic in the JSON record; rank-normalized/folded R-hat, bulk/tail ESS and quantity-specific MCSE remain required for actual scientific fits. Two scale-underflow proposal-rejection messages occurred during marked warmup phases, with none during marked sampling phases. They were retained and localized rather than hidden through a prior/support change.

Pedantic warnings saying priors were absent arise because prior scales are supplied as data. The declarations were manually checked: proper normal/half-normal, beta, LKJ or ordered lognormal priors are present and data-supplied scales/shapes are checked strictly positive. This explanation applies to these inspected templates, not to every such compiler warning.

## Corrections driven by validation

The forward exercises prompted more precise conditional-versus-integrated LOO guidance and centered sum-to-zero normalization. Independent quadrature testing found that Q=41 missed a challenging count/scale fixture by about 2e-5; increasing resolution repaired that fixture, and the example now requires application-specific integration checks. An initially unavailable socket-based Python execution route was replaced with direct native Stan services; the R APIs were not inferred to work merely from that native fit.

## Limits and remaining application checks

cmdstanr, brms, posterior, bayesplot, loo and SBC package fragments were parsed and checked against current primary documentation, but their full R integration was not executed in this environment. No claim is made that all historical case fits, every Stan template's sampling geometry or a complete production SBC experiment were reproduced. The pure-R suite ends with that boundary; the native smoke fit is recorded separately.

For each actual analysis, instantiate dimensions/units/design, compile and fit the requested model, check full computational diagnostics, simulate priors/known data where relevant, run targeted PPC and match the validation task. Recheck numerical integration, package-version interfaces and proper generator/prior correspondence after changes. Retain failed fits and unresolved restrictions in the scientific report.

## Reproduce the bundled checks

From the installed skill directory run `Rscript tests/smoke.R .`, `python3 tests/validate_structure.py .`, and the canonical skill metadata validator. Compile the six files in `code/stan_patterns/` with a current Stan compiler and pedantic mode. The [cmdstanr patterns](../examples/cmdstanr-patterns.md) explain fitting the Gaussian template. Pass [gaussian-data.json](../tests/fixtures/gaussian-data.json) as CmdStan's JSON data input to replay the representative fixture; it is newly simulated test data, not an upstream dataset. The runtime JSON records its hash, truth, data RNG and sampling settings. Toolchain differences can change individual draws; compare behavior and generated-quantity identities rather than requiring byte-identical samples.

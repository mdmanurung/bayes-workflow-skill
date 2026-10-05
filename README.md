# bayes-workflow

Claude Code plugin: skills + subagents for Bayesian modeling.

## Layout
```
.claude-plugin/   plugin.json, marketplace.json
skills/           bayesian-modeling-workflow (build/iterate), eabm (diagnose/criticize/report)
agents/           subagents (below)
commands/         /bayes-check
hooks/            fit hygiene reminder (PostToolUse)
scripts/          run_fit.R, check_saved_fit.R (used by command + agents)
```

## Skills
| Skill | Use for |
|---|---|
| `bayesian-modeling-workflow` | design → simulate → fit → revise; Stan/cmdstanr/brms (R) |
| `eabm` | diagnostics, PPC, LOO, SBC, reporting; Python (ArviZ) and R |

## Subagents
| Agent | Role | Writes? |
|---|---|---|
| `bayes-model-reviewer` | audit spec/priors/identification pre-fit | no |
| `mcmc-diagnostician` | triage failing fits | no |
| `stan-implementer` | code, compile, prior-predictive, SBC | yes |
| `bayes-skeptic` | adversarial check of surprising results | no |
| `prior-elicitor` | domain knowledge → priors + prior predictive | yes |
| `bayes-reporter` | methods/results/diagnostics write-up from a validated fit | yes |
| `model-translator` | brms ↔ Stan ↔ PyMC ports with numeric parity check | yes |
| `slurm-fit-runner` | submit fits to SLURM + dependent diagnostics job; no polling | yes |

Typical flow: `prior-elicitor` → `stan-implementer` → `slurm-fit-runner` → `/bayes-check` → `bayes-skeptic` → `bayes-reporter`.

## `/bayes-check [fit path]`
Screens a saved fit (CmdStan CSV dir, or `.rds` of CmdStanMCMC/brmsfit) with `scripts/check_saved_fit.R`
(cutoffs from `skills/eabm/references/thresholds.json`), then asks `mcmc-diagnostician` for one next action.
Needs `Rscript` with cmdstanr + posterior (+ brms for brmsfit) on PATH.

## Hook: fit hygiene
After Write/Edit of `.R/.Rmd/.qmd/.py/.ipynb` files that use a Bayesian library, adds a reminder to Claude's
context if a sampler is called without `seed` or a fit is saved without a version record. Never blocks.

## Scripts
```
Rscript scripts/run_fit.R --model m.stan --data d.json --out DIR --seed N [--chains 4 --threads 1 --warmup 1000 --sampling 1000]
Rscript scripts/check_saved_fit.R DIR|fit.rds [--vars a,b] [--max-treedepth 10]
```
`check_saved_fit.R` exits 1 when it prints any `FLAG:` line, so `check && next_step` stops on a flagged fit.
`run_fit.R` writes CmdStan CSVs, `fit.rds` and `versions.txt` (args, model/data md5, cmdstan version, SLURM job id, sessionInfo).

## Install
```
claude --plugin-dir /path/to/bayes-workflow-skill      # dev
/plugin marketplace add /path/to/bayes-workflow-skill  # then /plugin install bayes-workflow@bayes-workflow
```

## Tests
```
python3 skills/bayesian-modeling-workflow/tests/validate_structure.py skills/bayesian-modeling-workflow
python3 skills/eabm/scripts/audit_skill.py
python3 hooks/tests/test_fit_hygiene.py
RSCRIPT=/path/to/Rscript python3 scripts/tests/test_scripts.py   # compiles 2 small models, ~2 min; skips without Rscript
```

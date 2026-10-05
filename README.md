# bayes-workflow

Claude Code plugin: skills + subagents for Bayesian modeling.

## Layout
```
.claude-plugin/   plugin.json, marketplace.json
skills/           bayesian-modeling-workflow (build/iterate), eabm (diagnose/criticize/report)
agents/           subagents (below)
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

## Install
```
claude --plugin-dir /path/to/bayes-workflow-skill      # dev
/plugin marketplace add /path/to/bayes-workflow-skill  # then /plugin install bayes-workflow@bayes-workflow
```

## Tests
`python skills/bayesian-modeling-workflow/tests/validate_structure.py`, `python skills/eabm/scripts/audit_skill.py`

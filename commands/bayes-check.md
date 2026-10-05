---
description: Screen a saved MCMC fit (CmdStan CSV dir or .rds) and get a diagnosis with one next action
argument-hint: "[fit path]"
---

Check the saved Bayesian fit at: $ARGUMENTS

1. **Pick the fit.** If no path was given, use the most recently modified `*.rds` file or directory containing CmdStan CSVs under the current directory (max depth 4, skip `.git`, `renv`, `node_modules`). Say which one you picked.
2. **Get the screen.**
   - If `<path>/diagnostics.txt` exists and is newer than the fit files (written by the SLURM follow-up job), read it.
   - Otherwise run `Rscript "${CLAUDE_PLUGIN_ROOT}/scripts/check_saved_fit.R" <path>`.
   - If `Rscript` is not on PATH or cmdstanr/posterior fail to load, stop and ask which environment to activate (module, conda, pixi, renv). Do not guess.
3. **Diagnose.** Pass the screen output and the path of the model code (if found next to the fit or in `versions.txt`) to the `bayes-workflow:mcmc-diagnostician` agent.
4. **Report** in this shape, at most 5 lines before any table:
   - verdict: usable / usable with caveats / not usable
   - each FLAG → likely cause (computational vs model vs data)
   - ONE next action
   - the follow-up check that would confirm it

A clean screen is not proof of convergence or model adequacy. Say so when there are no flags.

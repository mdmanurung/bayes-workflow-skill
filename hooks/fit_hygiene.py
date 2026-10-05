"""PostToolUse hook: remind about seeds and version records in Bayesian fitting code.

Reads the hook event JSON on stdin. Never blocks; always exits 0. Stdlib only, Python 3.6+.
ponytail: file-level regex, not a parse. A seed set in another sourced file gives a false
reminder; acceptable for a soft nudge.
"""
import json
import os
import re
import sys

EXTENSIONS = {".R", ".r", ".Rmd", ".rmd", ".qmd", ".py", ".ipynb"}
BAYES_LIB = re.compile(r"cmdstanr|\bbrms\b|rstan|cmdstanpy|\bpymc\b|CmdStanModel|stan_model|\bnumpyro\b")
SAMPLER = re.compile(r"\$sample\(|\bbrm\(|\bsampling\(|\bstan\(|\.sample\(|\bpm\.sample\(")
SEED = re.compile(r"seed", re.IGNORECASE)
SAVE = re.compile(r"saveRDS|save_object|save_output_files|to_netcdf|\.save\(")
VERSIONS = re.compile(r"sessionInfo|session_info|cmdstan_version|__version__|versions\.txt|show_versions")


def reminders(text):
    if not BAYES_LIB.search(text):
        return []
    out = []
    if SAMPLER.search(text) and not SEED.search(text):
        out.append("sampler call without a seed: pass seed= so the fit is reproducible")
    if SAVE.search(text) and not VERSIONS.search(text):
        out.append("fit is saved without a version record: write sessionInfo()/cmdstan_version() "
                   "(R) or package __version__s (Python) next to it, plus the seed and data/model hashes")
    return out


def main():
    try:
        event = json.load(sys.stdin)
        path = event["tool_input"]["file_path"]
    except Exception:
        return
    if os.path.splitext(path)[1] not in EXTENSIONS:
        return
    try:
        with open(path, encoding="utf-8", errors="replace") as handle:
            found = reminders(handle.read())
    except OSError:
        return
    if found:
        message = "bayes-workflow fit hygiene ({}): {}.".format(os.path.basename(path), "; ".join(found))
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": message}}))


if __name__ == "__main__":
    main()
    sys.exit(0)

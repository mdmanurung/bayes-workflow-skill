"""Run: python3 hooks/tests/test_fit_hygiene.py"""
import json
import os
import subprocess
import sys
import tempfile

HOOK = os.path.join(os.path.dirname(__file__), "..", "fit_hygiene.py")


def run(stdin):
    proc = subprocess.run([sys.executable, HOOK], input=stdin, stdout=subprocess.PIPE, universal_newlines=True)
    assert proc.returncode == 0, proc.returncode
    return proc.stdout


def run_file(name, text):
    path = os.path.join(tempfile.mkdtemp(), name)
    with open(path, "w") as handle:
        handle.write(text)
    return run(json.dumps({"tool_input": {"file_path": path}}))


out = run_file("fit.R", "library(cmdstanr)\nfit <- mod$sample(data = d)\n")
assert "without a seed" in json.loads(out)["hookSpecificOutput"]["additionalContext"], out
assert run_file("fit.R", "library(cmdstanr)\nfit <- mod$sample(data = d, seed = 1)\n") == ""
assert "version record" in run_file("fit.R", "library(brms)\nf <- brm(y ~ x, seed = 1)\nsaveRDS(f, 'f.rds')\n")
assert run_file("fit.R", "library(brms)\nf <- brm(y ~ x, seed = 1)\nsaveRDS(f, 'f.rds')\nsessionInfo()\n") == ""
assert run_file("prep.py", "import pandas as pd\ndf.sample(10)\n") == ""  # no Bayesian library
assert run_file("notes.md", "library(cmdstanr)\nmod$sample()\n") == ""  # wrong extension
assert run(json.dumps({"tool_input": {"file_path": "/nonexistent/x.R"}})) == ""
assert run("not json") == ""
nb = os.path.join(tempfile.mkdtemp(), "fit.ipynb")
with open(nb, "w") as handle:
    handle.write('{"cells": [{"source": ["library(cmdstanr)\\n", "fit <- mod$sample(data = d)"]}]}')
assert "without a seed" in run(json.dumps({"tool_input": {"notebook_path": nb}}))  # NotebookEdit
assert run_file("prep.py", "import pymc as pm\ndf.sample(10)\n") == ""  # pandas sample next to pymc
assert run_file("m.py", "import pymc as pm\nidata = pm.sample(random_state=1)\n") == ""  # PyMC seed arg
assert "without a seed" in run_file("m.py", "import numpyro\nmcmc = MCMC(NUTS(model), num_samples=500)\n")
assert "without a seed" in run_file("m.R", "library(brms)\nf <- brm_multiple(y ~ x, data = imps)\n")
assert "version record" in run_file("m.R", "library(brms)\nf <- brm(y ~ x, seed = 1)\nreadr::write_rds(f, 'f.rds')\n")
assert "without a seed" in run_file("m.py", "import bambi as bmb\nm = bmb.Model('y ~ x', df)\nm.fit(draws=1000, chains=2)\n")
assert run_file("m.py", "import bambi as bmb\nm = bmb.Model('y ~ x', df)\nm.fit(draws=1000, chains=2, seed=7)\n") == ""
assert "version record" in run_file("m.R", "library(brms)\nf <- brm(y ~ x, seed = 1)\nqs::qsave(f, 'f.qs')\n")
assert run_file("m.py", "from sklearn.linear_model import LinearRegression\nLinearRegression().fit(x, y)\n") == ""  # .fit( alone
print("ok: 18 cases")

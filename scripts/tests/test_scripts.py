"""Run: RSCRIPT=/path/to/Rscript python3 scripts/tests/test_scripts.py
Fits a clean model and a centered eight-schools model with run_fit.R, then checks
check_saved_fit.R exit codes. Needs cmdstanr + posterior; skips if Rscript is missing."""
import os
import shutil
import subprocess
import sys
import tempfile

SCRIPTS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
RSCRIPT = os.environ.get("RSCRIPT") or shutil.which("Rscript")

MODELS = {
    "good": ("data { int N; vector[N] y; }\n"
             "parameters { real mu; real<lower=0> sigma; }\n"
             "model { mu ~ normal(0, 5); sigma ~ exponential(1); y ~ normal(mu, sigma); }\n",
             '{"N":5,"y":[1.2,0.4,2.1,1.5,0.9]}'),
    "bad": ("data { int J; vector[J] y; vector<lower=0>[J] s; }\n"
            "parameters { real mu; real<lower=0> tau; vector[J] theta; }\n"
            "model { mu ~ normal(0, 5); tau ~ cauchy(0, 5); theta ~ normal(mu, tau); y ~ normal(theta, s); }\n",
            '{"J":8,"y":[28,8,-3,7,-1,1,18,12],"s":[15,10,16,11,9,11,10,18]}'),
}


def r(script, *args):
    return subprocess.run([RSCRIPT, os.path.join(SCRIPTS, script)] + list(args),
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)


def main():
    if not RSCRIPT:
        print("skip: no Rscript (set RSCRIPT)")
        return
    tmp = tempfile.mkdtemp()
    for name, (code, data) in MODELS.items():
        for ext, text in (("stan", code), ("json", data)):
            with open(os.path.join(tmp, name + "." + ext), "w") as handle:
                handle.write(text)
        out = os.path.join(tmp, name + "_out")
        fit = r("run_fit.R", "--model", os.path.join(tmp, name + ".stan"), "--data", os.path.join(tmp, name + ".json"),
                "--out", out, "--seed", "1")
        assert fit.returncode == 0, fit.stdout[-2000:]
        assert os.path.exists(os.path.join(out, "versions.txt"))
        check = r("check_saved_fit.R", out)
        want = 0 if name == "good" else 1
        assert check.returncode == want, (name, check.returncode, check.stdout[-2000:])
        assert ("OK:" if want == 0 else "FLAG:") in check.stdout, check.stdout[-2000:]
    reuse = r("run_fit.R", "--model", os.path.join(tmp, "good.stan"), "--data", os.path.join(tmp, "good.json"),
              "--out", os.path.join(tmp, "good_out"), "--seed", "1")
    assert reuse.returncode != 0 and "already has CSVs" in reuse.stdout, reuse.stdout[-2000:]
    shutil.rmtree(tmp)
    print("ok: run_fit.R + check_saved_fit.R (clean=0, flagged=1, reused dir refused)")


if __name__ == "__main__":
    sys.exit(main())

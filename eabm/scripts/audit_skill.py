#!/usr/bin/env python3
"""Check local resource links, evidence enums and all tri-state route references."""
import ast
import itertools
import json
import re
from pathlib import Path
from route_checks import route

ROOT = Path(__file__).resolve().parents[1]


def main():
    errors = []
    markdown = list(ROOT.rglob("*.md"))
    for file in markdown:
        for target in re.findall(r"\[[^\]]*\]\(([^)]+)\)", file.read_text()):
            if target.startswith(("http:", "https:", "#", "app:", "sandbox:")):
                continue
            target = target.split("#")[0]
            if target and not (file.parent / target).exists():
                errors.append(f"Broken resource link in {file.relative_to(ROOT)}: {target}")
    for file in ROOT.rglob("*.py"):
        try:
            ast.parse(file.read_text())
        except SyntaxError as exc:
            errors.append(f"Python syntax {file.relative_to(ROOT)}: {exc}")
    statuses = {"direct-eabm", "eabm-code", "method-paper", "translated", "synthesized"}
    evidence = json.loads((ROOT / "references/evidence-matrix.json").read_text())
    for rec in evidence:
        if not all(rec.get(k) for k in ("recommendation", "source", "evidence_status")):
            errors.append(f"Incomplete evidence: {rec}")
        if rec.get("evidence_status") not in statuses:
            errors.append(f"Unknown evidence enum: {rec}")
    trees = json.loads((ROOT / "decision-trees/trees.json").read_text())["trees"]
    route_cases = 0
    for name, tree in trees.items():
        nodes = tree["nodes"]
        if tree["start"] not in nodes:
            errors.append(f"Missing start: {name}")
        facts = [n["fact"] for n in nodes.values() if "fact" in n]
        for node in nodes.values():
            if "fact" in node:
                for branch in ("yes", "no", "unknown"):
                    if node.get(branch) not in nodes:
                        errors.append(f"Missing branch: {name}/{node}")
            elif "action" in node:
                if not (ROOT / node["guide"]).exists():
                    errors.append(f"Missing action guide: {name}/{node['guide']}")
                if any(t not in trees for t in node["rerun"]):
                    errors.append(f"Unknown return tree: {name}")
        # Exhaustive true/false/unknown combinations, not only a happy path.
        for values in itertools.product((True, False, None), repeat=len(facts)):
            try:
                answer = route(name, dict(zip(facts, values)))
                assert answer["next_action"] and answer["guide"]
            except (ValueError, KeyError, AssertionError) as exc:
                errors.append(f"Route failed: {name}/{values}: {exc}")
                break
            route_cases += 1
        try:
            route(name, {facts[0]: 1})
            errors.append(f"Numeric fact accepted: {name}")
        except ValueError:
            pass
        answer = route(name, {})
        if answer["trace"][0]["answer"] != "unknown":
            errors.append(f"Missing evidence silently passed: {name}")
    report = {"markdown_files": len(markdown), "evidence_records": len(evidence),
              "trees": len(trees), "exhaustive_route_cases": route_cases,
              "errors": errors, "scope": "structural/route checks, not statistical proof"}
    print(json.dumps(report, indent=2))
    if errors:
        raise SystemExit(1)


if __name__ == "__main__":
    main()

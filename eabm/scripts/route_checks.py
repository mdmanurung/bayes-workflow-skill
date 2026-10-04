#!/usr/bin/env python3
"""Run a tri-state EABM decision tree without guessing missing evidence."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def route(tree_name, facts):
    trees = json.loads((ROOT / "decision-trees/trees.json").read_text())["trees"]
    if tree_name not in trees:
        raise ValueError(f"Unknown tree: {tree_name}; choose {', '.join(trees)}")
    tree = trees[tree_name]
    allowed = {n["fact"] for n in tree["nodes"].values() if "fact" in n}
    extra = set(facts) - allowed
    if extra:
        raise ValueError(f"Unknown facts for {tree_name}: {sorted(extra)}")
    if any(v is not None and type(v) is not bool for v in facts.values()):
        raise ValueError("Facts must be JSON booleans or null, not numbers or strings")
    node_id, trace, visited = tree["start"], [], set()
    while True:
        if node_id in visited:
            raise ValueError(f"Cycle in decision specification at {node_id}")
        visited.add(node_id)
        node = tree["nodes"][node_id]
        if "action" in node:
            return {"tree": tree_name, "trace": trace, "next_action": node["action"],
                    "guide": node["guide"], "rerun_after_check_or_change": node["rerun"]}
        value = facts.get(node["fact"])
        branch = "unknown" if value is None else "yes" if value else "no"
        trace.append({"fact": node["fact"], "question": node["question"], "answer": branch})
        node_id = node[branch]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tree", required=True)
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--facts", default=None, help="JSON object of inspected boolean facts")
    group.add_argument("--facts-file", type=Path)
    args = parser.parse_args()
    try:
        facts = json.loads(args.facts_file.read_text() if args.facts_file else args.facts or "{}")
        if not isinstance(facts, dict):
            raise ValueError("Facts must be a JSON object")
        print(json.dumps(route(args.tree, facts), indent=2))
    except (ValueError, KeyError) as exc:
        parser.error(str(exc))


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Builds a unified index across all skill libraries (open-source + custom).
Run this whenever you add or update skills.
"""
import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent

SOURCES = [
    {
        "name": "open-source-cybersecurity",
        "path": ".agents/index.json",
        "skills_root": ".agents/",
        "namespace": "cyber",
    },
    {
        "name": "gapt-custom",
        "path": "skills/custom/gapt/index.json",
        "skills_root": "skills/custom/gapt/",
        "namespace": "gapt",
    },
    # Add future custom packs here (e.g., client-specific)
]

def main():
    combined = {
        "version": 1,
        "sources": [],
        "total_skills": 0,
        "skills": [],
    }

    for src in SOURCES:
        index_path = PROJECT_ROOT / src["path"]
        if not index_path.exists():
            print(f"⚠ Skipping {src['name']}: {index_path} not found", file=sys.stderr)
            continue

        with open(index_path) as f:
            data = json.load(f)

        skills = data.get("skills", [])
        for s in skills:
            s["_source"] = src["name"]
            s["_namespace"] = src["namespace"]
            if "path" in s:
                s["_full_path"] = str(Path(src["skills_root"]) / s["path"])
            combined["skills"].append(s)

        combined["sources"].append({
            "name": src["name"],
            "namespace": src["namespace"],
            "skill_count": len(skills),
        })

    combined["total_skills"] = len(combined["skills"])

    output_path = PROJECT_ROOT / "skills/custom/combined-index.json"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(combined, f, indent=2)

    print(f"✓ Combined index: {combined['total_skills']} skills from {len(combined['sources'])} source(s)")
    for src in combined["sources"]:
        print(f"  - {src['name']:<30} ({src['skill_count']} skills, namespace='{src['namespace']}')")
    print(f"\n  Output: {output_path}")

if __name__ == "__main__":
    main()

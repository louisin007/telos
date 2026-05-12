#!/usr/bin/env python3
"""
Generates an index.json for skills under .agents/skills/ by scanning
each SKILL.md's YAML frontmatter. Mirrors the agentskills.io format so
build-combined-index.py can consume it.
"""
import json
import re
import sys
from pathlib import Path
from datetime import datetime, timezone

PROJECT_ROOT = Path(__file__).parent.parent
SKILLS_DIR = PROJECT_ROOT / ".agents" / "skills"
OUTPUT_PATH = PROJECT_ROOT / ".agents" / "index.json"


def parse_frontmatter(text: str) -> dict:
    """Extract YAML frontmatter as a dict (minimal parser, no PyYAML required)."""
    m = re.match(r"^---\s*\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return {}

    meta = {}
    current_list_key = None
    for raw in m.group(1).splitlines():
        line = raw.rstrip()
        if not line or line.lstrip().startswith("#"):
            continue
        # List item: "  - value"
        if line.lstrip().startswith("- ") and current_list_key:
            meta[current_list_key].append(line.lstrip()[2:].strip().strip('"').strip("'"))
            continue
        # Key: value (or "key:" starting a list)
        if ":" in line and not line.startswith(" "):
            key, _, value = line.partition(":")
            key = key.strip()
            value = value.strip().strip('"').strip("'")
            if value == "":
                meta[key] = []
                current_list_key = key
            else:
                meta[key] = value
                current_list_key = None
    return meta


def main():
    if not SKILLS_DIR.exists():
        print(f"✗ {SKILLS_DIR} does not exist", file=sys.stderr)
        sys.exit(1)

    skills = []
    skipped = 0
    for skill_dir in sorted(SKILLS_DIR.iterdir()):
        if not skill_dir.is_dir():
            continue
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.exists():
            skipped += 1
            continue

        try:
            text = skill_md.read_text(encoding="utf-8", errors="replace")
        except Exception as e:
            print(f"⚠ Failed to read {skill_md}: {e}", file=sys.stderr)
            skipped += 1
            continue

        meta = parse_frontmatter(text)
        name = meta.get("name") or skill_dir.name

        skills.append({
            "id": meta.get("id", name),
            "name": name,
            "domain": meta.get("domain", "cybersecurity"),
            "subdomain": meta.get("subdomain", "general"),
            "category": meta.get("subdomain", "general"),
            "tags": meta.get("tags", []) if isinstance(meta.get("tags"), list) else [],
            "description": meta.get("description", "")[:500],
            "frameworks": {},
            "path": f"skills/{skill_dir.name}/SKILL.md",
            "version": meta.get("version", "1.0.0"),
        })

    index = {
        "version": 1,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "name": "anthropic-cybersecurity-skills",
        "description": "Open-source cybersecurity skill library (mukul975/Anthropic-Cybersecurity-Skills)",
        "total_skills": len(skills),
        "skills": skills,
    }

    OUTPUT_PATH.write_text(json.dumps(index, indent=2), encoding="utf-8")
    print(f"✓ Generated {OUTPUT_PATH}")
    print(f"  Skills indexed: {len(skills)}")
    if skipped:
        print(f"  Skipped (no SKILL.md): {skipped}")


if __name__ == "__main__":
    main()

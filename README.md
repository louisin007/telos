# Telos

**Cybersecurity Tooling Services  CLI** — a Claude Code wrapper for repeatable VAPT, GAPT, and MCP security engagements with 909 framework-mapped test skills.

## Quick Install

> Note: This is a private repo. Make sure you've configured git access with a PAT or SSH key for this account first.

```bash
git clone https://github.com/louisin007/telos.git ~/.telos
cd ~/.telos
bash install.sh
source ~/.zshrc   # or ~/.bashrc
telos version
```

## Prerequisites

- Linux (Kali / Ubuntu / Debian / Parrot) or macOS
- Python 3.8+
- Git
- [Claude Code](https://docs.claude.com/claude-code) installed and authenticated (Claude Pro/Max subscription or Anthropic API key)

## What It Does

Telos turns a target description into a full engagement workflow:

```bash
telos scope "AWS EKS cluster with public ALB and an LLM chatbot"
telos testplan output/scope-*.md
telos execute output/testplan-*.md
telos report output/test-results.md
```

Each command produces a timestamped markdown artifact in `./output/`.

## Skill Library

- **754 open-source cybersecurity skills** — 26 subdomains covering web, network, cloud, mobile, K8s, DFIR, threat hunting, and more
- **155 custom GAPT skills** — mapped to OWASP LLM Top 10 (2025), OWASP Agentic Top 10 (2026), OWASP MCP Top 10 (2025), MITRE ATLAS, and NIST AI RMF

## Engagement Types

`web-vapt`, `network-vapt`, `cloud-vapt`, `mobile-pt`, `api-pt`, `k8s-pt`, `thick-client-pt`, `source-code-review`, `gapt`, `mcp-audit`, `red-team`, `dfir`, `threat-hunt`, `recon`

## Commands

| Command | Purpose |
|---|---|
| `telos scope <description>` | Bootstrap engagement scope |
| `telos recon <target>` | Reconnaissance plan |
| `telos testplan <scope-file>` | Prioritised test plan |
| `telos execute <plan-file>` | Step-by-step runbook |
| `telos report <results-file>` | Findings report |
| `telos list-skills [filter]` | Search the skill library |
| `telos show-skill <name>` | View a single skill |
| `telos list-types` | List engagement types |
| `telos rebuild-index` | Refresh skill catalog |
| `telos version` | Show version info |

## Configuration

Override the default model (Sonnet) per-engagement:

```bash
TELOS_MODEL=claude-opus-4-7 telos scope "your target"
```

## Authorisation Required

Telos is for authorised security testing only. Always obtain written authorisation from the asset owner before running any active test.

## License

Internal use only — © Louis, 2026. Not for redistribution.

## Credits

- [Claude Code](https://docs.claude.com/claude-code) (Anthropic)
- Open-source skill library: [mukul975/Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills) (Apache 2.0)
- Frameworks: OWASP, MITRE ATLAS, NIST AI RMF

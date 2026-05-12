---
name: testing-mcp-egress-control-against-arbitrary-remote-servers
description: "Test whether developers can point their local agent at an arbitrary remote MCP server, bypassing the organizational allowlist. Validate network egress controls and DNS filtering. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-shadow-servers testing. Trigger on phrases like 'test for mcp-shadow-servers', 'GAPT', 'AI security assessment', or when the target description mentions shadow MCP, unauthorized MCP server, rogue MCP, MCP discovery."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-shadow-servers
  - owasp-agentic
  - asi04
  - owasp-mcp
  - mcp09
  - nist-ai-rmf
version: 1.0.0
id: GAPT-154
frameworks:
  - owasp-agentic-top-10-2026: ASI04
  - owasp-mcp-top-10-2025: MCP09
  - nist-ai-rmf: MANAGE-1.3
---

# Testing MCP Egress Control Against Arbitrary Remote Servers

> **Test case ID:** `GAPT-154`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-shadow-servers`

## Summary

Test whether developers can point their local agent at an arbitrary remote MCP server, bypassing the organizational allowlist. Validate network egress controls and DNS filtering.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-shadow-servers attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP09 — Shadow MCP Servers)**.
- The user describes a scenario matching: shadow MCP, unauthorized MCP server, rogue MCP, MCP discovery.

## Prerequisites

- Authorised testing scope covering the target system, including the LLM provider's terms of service.
- Read access to system prompts, RAG corpora, and tool definitions where applicable (white-box testing yields higher coverage).
- A non-production environment or sanctioned test tenant — never run destructive payloads against production data.
- Logging/observability access so attack effects can be confirmed and replayed.

## Test Workflow

### 1. Reconnaissance

Document the target's configuration before issuing payloads:

- Model family and version (provider, parameter count, multimodal capabilities).
- System prompt (if accessible) and any wrapping/templating logic.
- Trust boundaries: which inputs flow into the prompt, which outputs flow into actions.
- Tools, MCP servers, and external services the system can invoke.
- Memory and retrieval components (vector stores, conversation history, summarisation).
- Existing guardrails (input filters, output classifiers, rate limits).

### 2. Threat Modelling

Map the test case to the target's specific architecture:

- Which trust boundary does this attack cross?
- What is the worst-case impact if the test succeeds?
- What detective controls *should* fire — and will the test verify them?

### 3. Payload Preparation

Discover and assess unsanctioned MCP servers in the environment:

- Enumerate process listings, network connections, and `mcp.json` files across endpoints/dev workstations to identify all MCP servers in use.
- Compare against the approved-server allowlist (or establish one if none exists).
- For each unsanctioned server: inventory what it's connected to, what credentials it holds, what data it has accessed.
- Test whether unsanctioned servers are using default credentials, permissive scopes, or unencrypted transports.
- Validate the egress controls: can a developer point their local agent at an arbitrary remote MCP server, bypassing organizational policy?

### 4. Execution

1. Establish a baseline — record the model's behaviour on a benign equivalent of the test prompt for comparison.
2. Issue the payload through the same channel a real attacker would use (UI, API, ingestion pipeline, retrieved document, tool output).
3. Capture the full request/response cycle, including any tool invocations, retrieved context, and downstream side-effects.
4. Vary the payload along the dimensions called out in `references/variants.md` (if present) to determine how brittle or robust the vulnerability is.

### 5. Verification

A finding is confirmed when **all** of the following hold:

- The model's behaviour deviates from baseline in a security-relevant way.
- The deviation is reproducible across at least three independent attempts.
- The deviation has documented impact (data disclosed, action taken, control bypassed) — not just suspicious output.

If verification fails, capture the negative result with payload variants tried — this is still useful evidence for the report.

### 6. Evidence Collection

Capture for the findings report:

- The exact payload(s) used.
- The full prompt sent to the model (where reconstructable) and the model's response.
- Any tool calls triggered, including parameters and results.
- Logs from the application backend showing the security-relevant effect.
- Reproduction steps a developer or defender can follow.

## Framework Mappings

| Framework | ID | Title |
|---|---|---|
| OWASP Agentic Top 10 (2026) | ASI04 | Agentic Supply Chain Vulnerabilities |
| OWASP MCP Top 10 (2025) | MCP09 | Shadow MCP Servers |
| NIST AI RMF | MANAGE-1.3 | Prioritize, respond, and continuously improve |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Maintain an approved-MCP-server allowlist; block all others at network egress.
- Discover MCP usage continuously via endpoint scanning and EDR signals.
- Onboard found shadow servers into governance or quarantine them.
- Educate developers on the risk; provide an easy approval path.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-shadow-servers` subdomain group.

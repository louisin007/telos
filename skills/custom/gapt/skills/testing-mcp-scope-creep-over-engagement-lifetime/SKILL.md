---
name: testing-mcp-scope-creep-over-engagement-lifetime
description: "Track MCP server scope grants over time and identify scopes that have expanded beyond original need. Common pattern: temporary debugging scopes that were never revoked. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-scope-creep testing. Trigger on phrases like 'test for mcp-scope-creep', 'GAPT', 'AI security assessment', or when the target description mentions MCP scope creep, OAuth scope expansion, MCP permission audit, least privilege MCP."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-scope-creep
  - owasp-llm
  - llm06
  - owasp-agentic
  - asi03
  - owasp-mcp
  - mcp02
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-135
frameworks:
  - owasp-llm-top-10-2025: LLM06
  - owasp-agentic-top-10-2026: ASI03
  - owasp-mcp-top-10-2025: MCP02
  - mitre-atlas: AML.T0044
  - nist-ai-rmf: MANAGE-2.3
---

# Testing MCP Scope Creep Over Engagement Lifetime

> **Test case ID:** `GAPT-135`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-scope-creep`

## Summary

Track MCP server scope grants over time and identify scopes that have expanded beyond original need. Common pattern: temporary debugging scopes that were never revoked.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-scope-creep attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP02 — Privilege Escalation via Scope Creep)**.
- The user describes a scenario matching: MCP scope creep, OAuth scope expansion, MCP permission audit, least privilege MCP.

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

Map MCP server scopes against actual usage over time:

- Enumerate the OAuth scopes / permissions each MCP server requests at install time.
- Compare against the agent's actual tool-call usage in production (or representative workloads) — flag scopes never invoked.
- Test whether scope grants persist after the originating task completes (no automated expiry).
- Probe for scope-elevation paths: can prompt injection or chained tool calls cause the agent to use scopes beyond the task's needs?
- Validate the access-review process: how often does someone audit the granted scopes against business need?

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
| OWASP LLM Top 10 (2025) | LLM06 | Excessive Agency |
| OWASP Agentic Top 10 (2026) | ASI03 | Identity and Privilege Abuse |
| OWASP MCP Top 10 (2025) | MCP02 | Privilege Escalation via Scope Creep |
| MITRE ATLAS | AML.T0044 | Full ML Model Access |
| NIST AI RMF | MANAGE-2.3 | Prioritize, respond, and continuously improve |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **High/Medium** — meaningful security impact in typical deployments
- **Medium/Low** — variants with mitigating factors (filters, HITL, narrow blast radius)

## Remediation Themes

- Enforce least-privilege OAuth scopes per MCP server.
- Implement automated scope expiry; require re-grant for renewed access.
- Run quarterly access reviews matching granted scopes against demonstrated need.
- Alert on scope-elevation attempts from agent context.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-scope-creep` subdomain group.

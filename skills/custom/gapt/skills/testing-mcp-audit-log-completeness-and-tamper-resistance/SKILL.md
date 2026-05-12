---
name: testing-mcp-audit-log-completeness-and-tamper-resistance
description: "Validate that every MCP tool invocation is logged with sufficient detail (identity, parameters, result, downstream effects), that logs are tamper-resistant, and that tool description changes are captured as discrete events. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-audit-telemetry testing. Trigger on phrases like 'test for mcp-audit-telemetry', 'GAPT', 'AI security assessment', or when the target description mentions MCP audit, MCP logging, MCP telemetry, MCP IR readiness."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-audit-telemetry
  - owasp-agentic
  - asi10
  - owasp-mcp
  - mcp08
  - nist-ai-rmf
version: 1.0.0
id: GAPT-152
frameworks:
  - owasp-agentic-top-10-2026: ASI10
  - owasp-mcp-top-10-2025: MCP08
  - nist-ai-rmf: GOVERN-1.5
---

# Testing MCP Audit Log Completeness And Tamper Resistance

> **Test case ID:** `GAPT-152`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-audit-telemetry`

## Summary

Validate that every MCP tool invocation is logged with sufficient detail (identity, parameters, result, downstream effects), that logs are tamper-resistant, and that tool description changes are captured as discrete events.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-audit-telemetry attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP08 — Lack of Audit and Telemetry)**.
- The user describes a scenario matching: MCP audit, MCP logging, MCP telemetry, MCP IR readiness.

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

Validate the audit and observability layer for MCP interactions:

- Confirm every tool invocation is logged with: timestamp, user/agent identity, tool name, parameters, result, and downstream side-effects.
- Test log-tamper resistance: can a compromised MCP server scrub or modify its own audit trail?
- Validate that tool description changes (the rug-pull signal) are logged independently of tool invocations.
- Check whether telemetry includes context-window changes — without this, intent-flow subversion is invisible.
- Test whether the IR pipeline can reconstruct an attack timeline from the available logs (run a tabletop exercise).

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
| OWASP Agentic Top 10 (2026) | ASI10 | Rogue Agents |
| OWASP MCP Top 10 (2025) | MCP08 | Lack of Audit and Telemetry |
| NIST AI RMF | GOVERN-1.5 | AI risk management culture, processes, and accountability |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Medium** — standard security finding pending impact analysis
- **Low/Informational** — defence-in-depth observations

## Remediation Themes

- Log every tool invocation: timestamp, identity, parameters, result, downstream effects.
- Store logs in tamper-resistant infrastructure separate from the MCP server itself.
- Capture tool description changes as discrete audit events.
- Test log completeness via tabletop exercises before relying on it for IR.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-audit-telemetry` subdomain group.

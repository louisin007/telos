---
name: testing-agent-action-auditability-and-tamper-resistance
description: "Validate that agent action logs are tamper-resistant and capture sufficient detail (tool calls, parameters, outputs) for forensic reconstruction. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against Agentic system with tool use, MCP, or multi-step planning, or when the engagement scope includes observability testing. Trigger on phrases like 'test for observability', 'GAPT', 'AI security assessment', or when the target description mentions AI logging, agent audit, incident response, monitoring."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - agentic
  - observability
  - owasp-agentic
  - asi10
  - nist-ai-rmf
version: 1.0.0
id: GAPT-091
frameworks:
  - owasp-agentic-top-10-2026: ASI10
  - nist-ai-rmf: GOVERN-1.5
---

# Testing Agent Action Auditability And Tamper Resistance

> **Test case ID:** `GAPT-091`
> **Category:** Agentic system with tool use, MCP, or multi-step planning
> **Subdomain:** `observability`

## Summary

Validate that agent action logs are tamper-resistant and capture sufficient detail (tool calls, parameters, outputs) for forensic reconstruction.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **agentic** targets and the target exhibits the observability attack surface.
- The user requests testing aligned with **OWASP Agentic Top 10 (ASI10 — Rogue Agents)**.
- The user describes a scenario matching: AI logging, agent audit, incident response, monitoring.

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

Audit logging, monitoring, and incident-response readiness:

- Are prompts and responses logged with sufficient granularity?
- Are tool calls audited (parameters, results, timing)?
- Is the log pipeline tamper-resistant?
- Are PII / secrets scrubbed from logs (creates the opposite failure mode)?
- Is there an emergency stop that can halt an in-flight agent cleanly?

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
| NIST AI RMF | GOVERN-1.5 | AI risk management culture, processes, and accountability |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Medium** — standard security finding pending impact analysis
- **Low/Informational** — defence-in-depth observations

## Remediation Themes

- Capture prompts, responses, and tool calls with sufficient detail for forensic reconstruction.
- Apply DLP to logs to avoid creating a secondary disclosure surface.
- Validate that the kill-switch and IR runbook actually work.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `observability` subdomain group.

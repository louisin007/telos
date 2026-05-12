---
name: testing-mcp-token-leakage-in-debug-logs-and-traces
description: "Test whether MCP servers leak tokens in debug logs, error messages, or stack traces. Includes verbose modes, exception handlers, and request/response telemetry. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-token-mgmt testing. Trigger on phrases like 'test for mcp-token-mgmt', 'GAPT', 'AI security assessment', or when the target description mentions MCP token leakage, OAuth secret exposure, hardcoded credentials, mcp.json secrets."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-token-mgmt
  - owasp-llm
  - llm02
  - owasp-mcp
  - mcp01
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-133
frameworks:
  - owasp-llm-top-10-2025: LLM02
  - owasp-mcp-top-10-2025: MCP01
  - mitre-atlas: AML.T0024
  - nist-ai-rmf: MEASURE-2.10
---

# Testing MCP Token Leakage In Debug Logs And Traces

> **Test case ID:** `GAPT-133`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-token-mgmt`

## Summary

Test whether MCP servers leak tokens in debug logs, error messages, or stack traces. Includes verbose modes, exception handlers, and request/response telemetry.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-token-mgmt attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP01 — Token Mismanagement & Secret Exposure)**.
- The user describes a scenario matching: MCP token leakage, OAuth secret exposure, hardcoded credentials, mcp.json secrets.

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

Audit token and secret handling across the MCP boundary:

- Inspect `mcp.json` / equivalent configs for hard-coded tokens, API keys, and OAuth client secrets.
- Check whether tokens are passed to the model as part of context (look in tool descriptions, prompt templates, conversation history).
- Test for token leakage in MCP server logs, debug output, and error traces.
- Probe whether prompt injection (via tool output or user input) can elicit the agent to read and exfiltrate stored credentials.
- Validate token lifetime, scope, and rotation cadence against least-privilege principles.

Use canary tokens placed in MCP configs to detect leakage paths definitively.

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
| OWASP LLM Top 10 (2025) | LLM02 | Sensitive Information Disclosure |
| OWASP MCP Top 10 (2025) | MCP01 | Token Mismanagement & Secret Exposure |
| MITRE ATLAS | AML.T0024 | Exfiltration via ML Inference API |
| NIST AI RMF | MEASURE-2.10 | Test, evaluate, validate, and verify (TEVV) |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Use short-lived, scoped credentials (OAuth 2.1 with PKCE preferred over static tokens).
- Never embed tokens in tool descriptions, prompt templates, or model context.
- Apply secret-scanning to MCP configs and logs as part of CI/CD.
- Rotate tokens automatically; monitor for use of expired credentials.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-token-mgmt` subdomain group.

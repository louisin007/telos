---
name: testing-mcp-oauth-confused-deputy-attack-chain
description: "Test the confused-deputy attack documented in the MCP security spec: static client IDs, dynamic registration, and consent-cookie reuse leading to authorization-code theft. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-authn-authz testing. Trigger on phrases like 'test for mcp-authn-authz', 'GAPT', 'AI security assessment', or when the target description mentions MCP authentication, MCP OAuth, confused deputy MCP, MCP session hijack."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-authn-authz
  - owasp-agentic
  - asi03
  - owasp-mcp
  - mcp07
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-150
frameworks:
  - owasp-agentic-top-10-2026: ASI03
  - owasp-mcp-top-10-2025: MCP07
  - mitre-atlas: AML.T0040
  - nist-ai-rmf: MANAGE-1.3
---

# Testing MCP Oauth Confused Deputy Attack Chain

> **Test case ID:** `GAPT-150`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-authn-authz`

## Summary

Test the confused-deputy attack documented in the MCP security spec: static client IDs, dynamic registration, and consent-cookie reuse leading to authorization-code theft.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-authn-authz attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP07 — Insufficient Authentication & Authorization)**.
- The user describes a scenario matching: MCP authentication, MCP OAuth, confused deputy MCP, MCP session hijack.

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

Test authentication and authorization on MCP server endpoints:

- Probe MCP HTTP endpoints for missing authentication (no token required), weak auth (default tokens, predictable values), and bypassable auth.
- For OAuth-based flows (MCP 2025-06-18 spec), test the confused-deputy attack chain documented in the MCP security spec: static client IDs, dynamic registration, consent-cookie reuse.
- Test session-hijack patterns: cross-server session ID reuse, replay across stateful HTTP servers.
- Validate that the MCP server enforces per-user authorization beyond just authentication — can user A invoke tools that should be restricted to user B?
- Test mutual TLS where claimed; STDIO transport with no built-in auth requires compensating controls.

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
| OWASP Agentic Top 10 (2026) | ASI03 | Identity and Privilege Abuse |
| OWASP MCP Top 10 (2025) | MCP07 | Insufficient Authentication & Authorization |
| MITRE ATLAS | AML.T0040 | ML Model Inference API Access |
| NIST AI RMF | MANAGE-1.3 | Prioritize, respond, and continuously improve |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Migrate to OAuth 2.1 with PKCE (per MCP 2025-06-18 spec) where transport supports it.
- Avoid static client IDs; implement per-client consent in proxy patterns.
- Enforce TLS with cert pinning; bind sessions to client identity.
- For STDIO transport, apply compensating controls (process isolation, manifest verification).

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-authn-authz` subdomain group.

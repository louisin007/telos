---
name: testing-llm-feature-input-validation-and-sanitization
description: "Test whether LLM-backed features (smart compose, summarization) properly validate and sanitize input from existing app workflows before sending to the model. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against LLM feature embedded inside an existing application, or when the engagement scope includes input-validation testing. Trigger on phrases like 'test for input-validation', 'GAPT', 'AI security assessment', or when the target description mentions input validation, sanitization, length limits."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - embedded
  - input-validation
  - owasp-llm
  - llm01
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-101
frameworks:
  - owasp-llm-top-10-2025: LLM01
  - mitre-atlas: AML.T0051
  - nist-ai-rmf: MEASURE-2.7
---

# Testing LLM Feature Input Validation And Sanitization

> **Test case ID:** `GAPT-101`
> **Category:** LLM feature embedded inside an existing application
> **Subdomain:** `input-validation`

## Summary

Test whether LLM-backed features (smart compose, summarization) properly validate and sanitize input from existing app workflows before sending to the model.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **embedded** targets and the target exhibits the input-validation attack surface.
- The user requests testing aligned with **OWASP LLM Top 10 (LLM01 — Prompt Injection)**.
- The user describes a scenario matching: input validation, sanitization, length limits.

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

Apply traditional input-validation testing to LLM features:

- Boundary conditions (empty input, max length, very large)
- Encoding edge cases (Unicode, surrogate pairs, BOM, mixed encoding)
- Type confusion (string where number expected, structured input where free text expected)
- Smuggled instructions in metadata fields (filenames, content-type, custom headers)

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
| OWASP LLM Top 10 (2025) | LLM01 | Prompt Injection |
| MITRE ATLAS | AML.T0051 | LLM Prompt Injection |
| NIST AI RMF | MEASURE-2.7 | Test, evaluate, validate, and verify (TEVV) |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Medium** — standard security finding pending impact analysis
- **Low/Informational** — defence-in-depth observations

## Remediation Themes

- Apply boundary and encoding checks to every input that flows into a prompt.
- Reject or escape suspicious patterns at the application layer.
- Avoid silent truncation that drops safety instructions.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `input-validation` subdomain group.

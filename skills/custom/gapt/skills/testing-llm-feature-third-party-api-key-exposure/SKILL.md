---
name: testing-llm-feature-third-party-api-key-exposure
description: "Test whether LLM API keys are exposed client-side, in logs, or in error messages, enabling cost-amplification attacks on the deployer. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against LLM feature embedded inside an existing application, or when the engagement scope includes data-disclosure testing. Trigger on phrases like 'test for data-disclosure', 'GAPT', 'AI security assessment', or when the target description mentions data leakage, training data extraction, PII exposure, system prompt extraction."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - embedded
  - data-disclosure
  - owasp-llm
  - llm02
  - owasp-agentic
  - asi03
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-113
frameworks:
  - owasp-llm-top-10-2025: LLM02
  - owasp-agentic-top-10-2026: ASI03
  - mitre-atlas: AML.T0024
  - nist-ai-rmf: MEASURE-2.10
---

# Testing LLM Feature Third Party Api Key Exposure

> **Test case ID:** `GAPT-113`
> **Category:** LLM feature embedded inside an existing application
> **Subdomain:** `data-disclosure`

## Summary

Test whether LLM API keys are exposed client-side, in logs, or in error messages, enabling cost-amplification attacks on the deployer.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **embedded** targets and the target exhibits the data-disclosure attack surface.
- The user requests testing aligned with **OWASP Agentic Top 10 (ASI03 — Identity and Privilege Abuse)**.
- The user describes a scenario matching: data leakage, training data extraction, PII exposure, system prompt extraction.

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

Prepare extraction payloads:

- Canary tokens placed in the system prompt, retrieved documents, or memory store before testing — any appearance in output is unambiguous evidence.
- Repetition / divergence prompts ("repeat the word X forever", which has historically caused training-data leakage).
- Indirect extraction via translation, summarisation, or completion framings.
- Cross-tenant probing in multi-tenant deployments using enumerated identifiers.

Document the canary placement clearly so detection can be distinguished from coincidental similarity.

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
| OWASP Agentic Top 10 (2026) | ASI03 | Identity and Privilege Abuse |
| MITRE ATLAS | AML.T0024 | Exfiltration via ML Inference API |
| NIST AI RMF | MEASURE-2.10 | Test, evaluate, validate, and verify (TEVV) |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Treat the system prompt as public; never embed secrets in prompts.
- Use canary tokens to detect leakage in production.
- Apply per-user/per-tenant authorization at retrieval time, not just ingestion.
- Scrub outputs for PII / secrets via DLP before returning to the user.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `data-disclosure` subdomain group.

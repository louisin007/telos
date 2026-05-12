---
name: testing-third-party-llm-api-egress-and-data-loss-prevention
description: "Test egress controls around third-party LLM API calls — what data leaves the boundary, to whom, with what retention guarantees, and is DLP applied. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against Cross-cutting governance / supply chain concern, or when the engagement scope includes data-protection testing. Trigger on phrases like 'test for data-protection', 'GAPT', 'AI security assessment', or when the target description mentions DLP, data residency, GDPR, egress control."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - cross-cutting
  - data-protection
  - owasp-llm
  - llm02
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-128
frameworks:
  - owasp-llm-top-10-2025: LLM02
  - mitre-atlas: AML.T0024
  - nist-ai-rmf: GOVERN-1.1
---

# Testing Third Party LLM Api Egress And Data Loss Prevention

> **Test case ID:** `GAPT-128`
> **Category:** Cross-cutting governance / supply chain concern
> **Subdomain:** `data-protection`

## Summary

Test egress controls around third-party LLM API calls — what data leaves the boundary, to whom, with what retention guarantees, and is DLP applied.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **cross-cutting** targets and the target exhibits the data-protection attack surface.
- The user requests testing aligned with **OWASP LLM Top 10 (LLM02 — Sensitive Information Disclosure)**.
- The user describes a scenario matching: DLP, data residency, GDPR, egress control.

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

Audit the data path for compliance posture:

- Where does user data go (LLM provider region, retention, training opt-out)?
- Is the data classified appropriately before transmission?
- Are DLP controls applied to outbound prompts?
- Are model responses scanned before being returned to users?

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
| MITRE ATLAS | AML.T0024 | Exfiltration via ML Inference API |
| NIST AI RMF | GOVERN-1.1 | AI risk management culture, processes, and accountability |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Medium** — standard security finding pending impact analysis
- **Low/Informational** — defence-in-depth observations

## Remediation Themes

- Document and enforce data residency, retention, and training-opt-out terms with the LLM provider.
- Apply DLP to outbound prompts and inbound responses.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `data-protection` subdomain group.

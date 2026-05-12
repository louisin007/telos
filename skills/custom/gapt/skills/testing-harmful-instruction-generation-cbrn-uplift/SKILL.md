---
name: testing-harmful-instruction-generation-cbrn-uplift
description: "Probe for CBRN (chemical, biological, radiological, nuclear) uplift — whether the model provides actionable harmful instructions beyond what is publicly available. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against Standalone LLM chatbot (single-turn or RAG), or when the engagement scope includes content-safety testing. Trigger on phrases like 'test for content-safety', 'GAPT', 'AI security assessment', or when the target description mentions harmful content, CSAM testing, CBRN uplift, refusal testing."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - chatbot
  - content-safety
  - owasp-agentic
  - asi09
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-042
frameworks:
  - owasp-agentic-top-10-2026: ASI09
  - mitre-atlas: AML.T0048
  - nist-ai-rmf: MEASURE-2.6
---

# Testing Harmful Instruction Generation Cbrn Uplift

> **Test case ID:** `GAPT-042`
> **Category:** Standalone LLM chatbot (single-turn or RAG)
> **Subdomain:** `content-safety`

## Summary

Probe for CBRN (chemical, biological, radiological, nuclear) uplift — whether the model provides actionable harmful instructions beyond what is publicly available.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **chatbot** targets and the target exhibits the content-safety attack surface.
- The user requests testing aligned with **OWASP Agentic Top 10 (ASI09 — Human-Agent Trust Exploitation)**.
- The user describes a scenario matching: harmful content, CSAM testing, CBRN uplift, refusal testing.

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

Coordinate carefully with the engagement owner before running content-safety tests — these payloads may be illegal to generate, store, or transmit in some jurisdictions even in a testing context.

- Use established red-team taxonomies (HarmBench, AdvBench, ALERT) rather than improvising harmful prompts
- Test refusal robustness across multiple framings of the same harm category
- For CBRN / cybersecurity uplift, measure delta over publicly-available information rather than absolute capability
- Maintain a strict chain of custody for any harmful outputs generated; delete after report sign-off

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
| OWASP Agentic Top 10 (2026) | ASI09 | Human-Agent Trust Exploitation |
| MITRE ATLAS | AML.T0048 | Societal Harm |
| NIST AI RMF | MEASURE-2.6 | Test, evaluate, validate, and verify (TEVV) |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Medium** — standard security finding pending impact analysis
- **Low/Informational** — defence-in-depth observations

## Remediation Themes

- Layered defences: input filters + model alignment + output classifiers.
- Documented refusal policies, regression-tested on every model update.
- Clear user-facing reporting and escalation paths.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `content-safety` subdomain group.

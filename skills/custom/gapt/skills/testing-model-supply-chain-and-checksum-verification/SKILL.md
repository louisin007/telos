---
name: testing-model-supply-chain-and-checksum-verification
description: "Test whether the agent verifies model weights and tokenizer integrity (checksums, signatures) before loading. Covers tampered model attacks. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against Agentic system with tool use, MCP, or multi-step planning, or when the engagement scope includes supply-chain testing. Trigger on phrases like 'test for supply-chain', 'GAPT', 'AI security assessment', or when the target description mentions MCP supply chain, plugin vetting, model provenance, skill registry."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - agentic
  - supply-chain
  - owasp-llm
  - llm03
  - owasp-agentic
  - asi04
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-069
frameworks:
  - owasp-llm-top-10-2025: LLM03
  - owasp-agentic-top-10-2026: ASI04
  - mitre-atlas: AML.T0010
  - nist-ai-rmf: MAP-4.1
---

# Testing Model Supply Chain And Checksum Verification

> **Test case ID:** `GAPT-069`
> **Category:** Agentic system with tool use, MCP, or multi-step planning
> **Subdomain:** `supply-chain`

## Summary

Test whether the agent verifies model weights and tokenizer integrity (checksums, signatures) before loading. Covers tampered model attacks.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **agentic** targets and the target exhibits the supply-chain attack surface.
- The user requests testing aligned with **OWASP Agentic Top 10 (ASI04 — Agentic Supply Chain Vulnerabilities)**.
- The user describes a scenario matching: MCP supply chain, plugin vetting, model provenance, skill registry.

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

Audit every external component the agent depends on at runtime:

- MCP servers: signing, version pinning, schema stability, rug-pull risk
- Third-party tools / plugins: provenance, review process, update mechanism
- Models: checksums, signatures, vendor attestation
- Skills / prompts pulled from registries: integrity verification

Note: this category overlaps both LLM03 (Supply Chain) and ASI04 (Agentic Supply Chain) — agentic supply chain adds runtime composition risk on top of pre-deployment risk.

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
| OWASP LLM Top 10 (2025) | LLM03 | Supply Chain |
| OWASP Agentic Top 10 (2026) | ASI04 | Agentic Supply Chain Vulnerabilities |
| MITRE ATLAS | AML.T0010 | ML Supply Chain Compromise |
| NIST AI RMF | MAP-4.1 | Context, categorization, and risk identification |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Pin versions and verify signatures for all MCP servers, tools, plugins, and models.
- Maintain an AI-BOM and review third-party components on a defined cadence.
- Sandbox third-party tools and limit their access to the minimum required.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `supply-chain` subdomain group.

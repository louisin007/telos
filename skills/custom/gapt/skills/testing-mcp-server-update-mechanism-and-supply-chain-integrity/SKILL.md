---
name: testing-mcp-server-update-mechanism-and-supply-chain-integrity
description: "Test the MCP server update path for integrity controls: are updates signed, version-pinned, and verified before installation? Replicate the Postmark MCP-style attack scenario where a benign server pushes a malicious update. Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-supply-chain testing. Trigger on phrases like 'test for mcp-supply-chain', 'GAPT', 'AI security assessment', or when the target description mentions MCP supply chain, malicious MCP package, typosquatted MCP server, MCP SBOM."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-supply-chain
  - owasp-llm
  - llm03
  - owasp-agentic
  - asi04
  - owasp-mcp
  - mcp04
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-143
frameworks:
  - owasp-llm-top-10-2025: LLM03
  - owasp-agentic-top-10-2026: ASI04
  - owasp-mcp-top-10-2025: MCP04
  - mitre-atlas: AML.T0010
  - nist-ai-rmf: MAP-4.1
---

# Testing MCP Server Update Mechanism And Supply Chain Integrity

> **Test case ID:** `GAPT-143`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-supply-chain`

## Summary

Test the MCP server update path for integrity controls: are updates signed, version-pinned, and verified before installation? Replicate the Postmark MCP-style attack scenario where a benign server pushes a malicious update.

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-supply-chain attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP04 — Software Supply Chain Attacks & Dependency Tampering)**.
- The user describes a scenario matching: MCP supply chain, malicious MCP package, typosquatted MCP server, MCP SBOM.

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

Audit every MCP server, package, and dependency the agent loads:

- Verify package signatures and provenance for every installed MCP server (npm/pip).
- Check for typosquatted server names against the registry's official list.
- Pin versions and hashes; reject unsigned updates.
- Run dependency scanners (Trivy, Snyk, Socket) against the full transitive tree.
- Test the install-time review process — does a human actually read tool descriptions before approval, or just tool names?
- For HTTP-transport MCP servers, validate TLS, certificate pinning, and DNS-rebinding protection.

Note 2026 CVE landscape: several high-severity MCP server vulnerabilities (path traversal, argument injection, unauthenticated WebSocket access) have shipped inside trusted ecosystem artefacts. Treat every MCP server as untrusted by default.

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
| OWASP MCP Top 10 (2025) | MCP04 | Software Supply Chain Attacks & Dependency Tampering |
| MITRE ATLAS | AML.T0010 | ML Supply Chain Compromise |
| NIST AI RMF | MAP-4.1 | Context, categorization, and risk identification |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Maintain an SBOM for every MCP server and its dependencies.
- Require signed packages; block unsigned updates in CI.
- Run dependency scanners pre-deploy; combine with runtime tool-description fingerprinting.
- Apply DLP egress monitoring to catch exfiltration even if a malicious package slipped through.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-supply-chain` subdomain group.

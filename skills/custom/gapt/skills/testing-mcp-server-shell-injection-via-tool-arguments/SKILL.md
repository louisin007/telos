---
name: testing-mcp-server-shell-injection-via-tool-arguments
description: "Test MCP servers that wrap shell commands or CLI tools for injection via attacker-controlled tool arguments. Replicates the most prevalent CVE pattern (~43% of 2026 MCP CVEs). Use this skill when conducting GAPT (GenAI Application Penetration Testing) against MCP (Model Context Protocol) server or client deployment, or when the engagement scope includes mcp-command-injection testing. Trigger on phrases like 'test for mcp-command-injection', 'GAPT', 'AI security assessment', or when the target description mentions MCP command injection, MCP shell injection, MCP RCE, MCP server CVE."
domain: cybersecurity
subdomain: gen-ai-llm-security
tags:
  - gapt
  - gen-ai-security
  - mcp
  - mcp-command-injection
  - owasp-llm
  - llm05
  - owasp-agentic
  - asi05
  - owasp-mcp
  - mcp05
  - mitre-atlas
  - nist-ai-rmf
version: 1.0.0
id: GAPT-144
frameworks:
  - owasp-llm-top-10-2025: LLM05
  - owasp-agentic-top-10-2026: ASI05
  - owasp-mcp-top-10-2025: MCP05
  - mitre-atlas: AML.T0050
  - nist-ai-rmf: MEASURE-2.6
---

# Testing MCP Server Shell Injection Via Tool Arguments

> **Test case ID:** `GAPT-144`
> **Category:** MCP (Model Context Protocol) server or client deployment
> **Subdomain:** `mcp-command-injection`

## Summary

Test MCP servers that wrap shell commands or CLI tools for injection via attacker-controlled tool arguments. Replicates the most prevalent CVE pattern (~43% of 2026 MCP CVEs).

## When to Use This Skill

Trigger this skill when any of the following apply:

- The engagement scope includes **mcp** targets and the target exhibits the mcp-command-injection attack surface.
- The user requests testing aligned with **OWASP MCP Top 10 (MCP05 — Command Injection & Execution)**.
- The user describes a scenario matching: MCP command injection, MCP shell injection, MCP RCE, MCP server CVE.

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

Probe every MCP tool that constructs commands, queries, or code from inputs:

- Identify tools whose implementation involves shell, SQL, eval/exec, or template engines.
- Submit inputs containing classical injection metacharacters appropriate to each interpreter (`;`, `&`, `|`, `${...}`, `${jndi:...}`, SQL meta, etc.).
- Test indirect injection: can attacker-controlled retrieved content (web page, document, DB row) reach a command-construction sink?
- For tools that wrap APIs, test for SSRF and request-smuggling against the wrapped service.
- Capture both the model-generated tool arguments and the actual sink invocation — the bug is usually in the MCP server, not the model.

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
| OWASP LLM Top 10 (2025) | LLM05 | Improper Output Handling |
| OWASP Agentic Top 10 (2026) | ASI05 | Unexpected Code Execution |
| OWASP MCP Top 10 (2025) | MCP05 | Command Injection & Execution |
| MITRE ATLAS | AML.T0050 | Command and Scripting Interpreter |
| NIST AI RMF | MEASURE-2.6 | Test, evaluate, validate, and verify (TEVV) |

## Severity Guidance

Default severity ranges for this test case (adjust to engagement-specific impact):

- **Critical/High** — direct impact on confidentiality, integrity, or availability of the AI system or downstream services
- **Medium** — exploitation requires specific conditions or non-trivial chaining
- **Low** — theoretical or limited-blast-radius variants

## Remediation Themes

- Treat all model-generated tool arguments as untrusted input — validate against strict schemas before invocation.
- Avoid shell, eval, and template engines in MCP server implementations; prefer typed APIs.
- Sandbox MCP server execution where shell access is unavoidable.
- Apply allowlist-based validation on URL parameters to prevent SSRF.

## References

- OWASP Top 10 for LLM Applications (2025) — https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- OWASP Top 10 for Agentic Applications (2026) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- MITRE ATLAS — https://atlas.mitre.org/
- NIST AI Risk Management Framework — https://www.nist.gov/itl/ai-risk-management-framework

## Related Skills

See the project `index.json` for related test cases in the `mcp-command-injection` subdomain group.

# GAPT Test Cases — Skill Library

**155 test cases** for GenAI Application Penetration Testing (GAPT), packaged as agentskills.io-compliant `SKILL.md` files for use with Claude Code, GitHub Copilot, Cursor, and other AI coding agents.

## Frameworks

Every test case is mapped to one or more of:

- **OWASP Top 10 for LLM Applications (2025)** — `LLM01`–`LLM10`
- **OWASP Top 10 for Agentic Applications (2026)** — `ASI01`–`ASI10`
- **OWASP Top 10 for MCP (2025, beta)** — `MCP01`–`MCP10`
- **MITRE ATLAS** — adversarial ML technique IDs
- **NIST AI Risk Management Framework** — `GOVERN` / `MAP` / `MEASURE` / `MANAGE`

## Distribution

| Category | Test Cases | Coverage |
|---|---|---|
| Standalone LLM chatbots (single-turn / RAG) | 45 | Prompt injection, jailbreak, data disclosure, output handling, RAG security, content safety |
| Agentic systems (tool use / MCP / multi-step) | 55 | All 10 ASI risks plus browser/CUA, observability, governance |
| Embedded LLM features in existing apps | 25 | Trust boundaries, authorization, deployment, fallback security |
| Cross-cutting (governance / supply chain) | 5 | AI-BOM, IR runbooks, eval-suite coverage |
| MCP (Model Context Protocol) | 25 | All 10 MCP risks: token mgmt, scope creep, tool poisoning, supply chain, command injection, intent flow, auth, audit, shadow servers, context |
| **Total** | **155** | |

## Usage with Claude Code

Drop the `skills/` directory into your Claude Code project:

```bash
cp -r gapt-test-cases/skills/ /path/to/your/project/skills/custom/gapt/
```

Then point your project's `CLAUDE.md` at the directory:

```markdown
## GAPT Skills
Load skills from `./skills/custom/gapt/` for GenAI penetration testing.
When a target involves an LLM, agent, or AI feature, scan the `index.json`
to find matching test cases by `frameworks` field, `category`, or tags.
```

## Index

See `index.json` for the full machine-readable catalog with framework mappings, tags, and skill paths.

## Test Case List

| ID | Test Case | Category | Subdomain | OWASP LLM | OWASP ASI | OWASP MCP |
|---|---|---|---|---|---|---|
| GAPT-001 | `testing-direct-prompt-injection-instruction-override` | chatbot | prompt-injection | LLM01 | ASI01 | — |
| GAPT-002 | `testing-indirect-prompt-injection-via-rag-documents` | chatbot | prompt-injection | LLM01 | ASI01 | — |
| GAPT-003 | `testing-prompt-injection-via-system-role-impersonation` | chatbot | prompt-injection | LLM01 | ASI01 | — |
| GAPT-004 | `testing-multilingual-prompt-injection-bypass` | chatbot | prompt-injection | LLM01 | ASI01 | — |
| GAPT-005 | `testing-encoded-payload-injection-base64-rot13-leetspeak` | chatbot | prompt-injection | LLM01 | ASI01 | — |
| GAPT-006 | `testing-prompt-injection-via-image-multimodal-input` | chatbot | prompt-injection | LLM01 | ASI01 | — |
| GAPT-007 | `testing-jailbreak-via-roleplay-and-fictional-framing` | chatbot | jailbreak | LLM01 | ASI01 | — |
| GAPT-008 | `testing-jailbreak-via-token-smuggling-and-special-characters` | chatbot | jailbreak | LLM01 | ASI01 | — |
| GAPT-009 | `testing-prompt-injection-via-conversation-history-poisoning` | chatbot | prompt-injection | LLM01 | ASI06 | — |
| GAPT-010 | `testing-many-shot-jailbreak-via-context-window-exhaustion` | chatbot | jailbreak | LLM01 | ASI01 | — |
| GAPT-011 | `testing-pii-leakage-from-training-data-extraction` | chatbot | data-disclosure | LLM02 | — | — |
| GAPT-012 | `testing-system-prompt-extraction-techniques` | chatbot | data-disclosure | LLM07 | — | — |
| GAPT-013 | `testing-rag-cross-tenant-data-leakage` | chatbot | data-disclosure | LLM02 | ASI06 | — |
| GAPT-014 | `testing-secrets-leakage-via-output-exfiltration` | chatbot | data-disclosure | LLM02 | — | — |
| GAPT-015 | `testing-conversation-memory-leakage-across-sessions` | chatbot | data-disclosure | LLM02 | ASI06 | — |
| GAPT-016 | `testing-side-channel-disclosure-via-token-timing` | chatbot | data-disclosure | LLM02 | — | — |
| GAPT-017 | `testing-xss-via-llm-generated-html-output` | chatbot | output-handling | LLM05 | — | — |
| GAPT-018 | `testing-sql-injection-via-llm-generated-queries` | chatbot | output-handling | LLM05 | ASI05 | — |
| GAPT-019 | `testing-markdown-injection-and-link-exfiltration` | chatbot | output-handling | LLM05 | — | — |
| GAPT-020 | `testing-command-injection-via-llm-generated-shell-commands` | chatbot | output-handling | LLM05 | ASI05 | — |
| GAPT-021 | `testing-path-traversal-in-llm-generated-file-paths` | chatbot | output-handling | LLM05 | ASI05 | — |
| GAPT-022 | `testing-ssrf-via-llm-generated-url-fetching` | chatbot | output-handling | LLM05 | ASI02 | — |
| GAPT-023 | `testing-hallucinated-package-name-supply-chain` | chatbot | misinformation | LLM09 | ASI04 | — |
| GAPT-024 | `testing-fabricated-citations-and-source-attribution` | chatbot | misinformation | LLM09 | — | — |
| GAPT-025 | `testing-confidently-wrong-domain-specific-answers` | chatbot | misinformation | LLM09 | — | — |
| GAPT-026 | `testing-bias-amplification-and-disparate-output-quality` | chatbot | misinformation | LLM09 | — | — |
| GAPT-027 | `testing-rag-poisoning-via-malicious-document-ingestion` | chatbot | rag-security | LLM08 | ASI06 | — |
| GAPT-028 | `testing-embedding-inversion-attack` | chatbot | rag-security | LLM08 | — | — |
| GAPT-029 | `testing-rag-retrieval-confusion-via-keyword-stuffing` | chatbot | rag-security | LLM08 | ASI06 | — |
| GAPT-030 | `testing-vector-store-access-control-bypass` | chatbot | rag-security | LLM08 | ASI03 | — |
| GAPT-031 | `testing-confused-deputy-via-rag-instruction-injection` | chatbot | rag-security | LLM01 | ASI01 | — |
| GAPT-032 | `testing-token-flooding-and-cost-amplification` | chatbot | denial-of-wallet | LLM10 | — | — |
| GAPT-033 | `testing-context-window-stuffing-resource-exhaustion` | chatbot | denial-of-wallet | LLM10 | — | — |
| GAPT-034 | `testing-recursive-self-prompting-loops` | chatbot | denial-of-wallet | LLM10 | ASI08 | — |
| GAPT-035 | `testing-rate-limit-bypass-via-distributed-requests` | chatbot | denial-of-wallet | LLM10 | — | — |
| GAPT-036 | `testing-authentication-bypass-on-chatbot-api-endpoints` | chatbot | auth | — | ASI03 | — |
| GAPT-037 | `testing-session-fixation-and-conversation-hijacking` | chatbot | auth | — | ASI03 | — |
| GAPT-038 | `testing-idor-on-conversation-and-document-resources` | chatbot | auth | — | ASI03 | — |
| GAPT-039 | `testing-unauthorized-document-upload-to-rag-pipeline` | chatbot | auth | LLM08 | ASI06 | — |
| GAPT-040 | `testing-admin-functions-exposed-via-prompt-engineering` | chatbot | auth | LLM06 | ASI03 | — |
| GAPT-041 | `testing-csam-and-illegal-content-generation-refusal` | chatbot | content-safety | — | ASI09 | — |
| GAPT-042 | `testing-harmful-instruction-generation-cbrn-uplift` | chatbot | content-safety | — | ASI09 | — |
| GAPT-043 | `testing-cybersecurity-malicious-code-generation` | chatbot | content-safety | — | ASI09 | — |
| GAPT-044 | `testing-self-harm-and-mental-health-safety-routing` | chatbot | content-safety | — | ASI09 | — |
| GAPT-045 | `testing-impersonation-and-deepfake-text-generation` | chatbot | content-safety | — | ASI09 | — |
| GAPT-046 | `testing-agent-goal-hijack-via-tool-output-injection` | agentic | goal-hijack | LLM01 | ASI01 | — |
| GAPT-047 | `testing-recursive-goal-hijack-self-modifying-plans` | agentic | goal-hijack | LLM01 | ASI01 | — |
| GAPT-048 | `testing-echoleak-style-zero-click-exfiltration` | agentic | goal-hijack | LLM01 | ASI01 | — |
| GAPT-049 | `testing-goal-hijack-via-poisoned-search-results` | agentic | goal-hijack | LLM01 | ASI01 | — |
| GAPT-050 | `testing-task-redirection-via-semantic-confusion` | agentic | goal-hijack | LLM01 | ASI01 | — |
| GAPT-051 | `testing-long-horizon-goal-drift-via-summarization` | agentic | goal-hijack | LLM01 | ASI01 | — |
| GAPT-052 | `testing-tool-parameter-injection-arbitrary-arguments` | agentic | tool-misuse | LLM05 | ASI02 | — |
| GAPT-053 | `testing-unsafe-tool-chain-composition` | agentic | tool-misuse | LLM06 | ASI02 | — |
| GAPT-054 | `testing-amazon-q-style-tool-instruction-poisoning` | agentic | tool-misuse | LLM01 | ASI02 | — |
| GAPT-055 | `testing-shell-and-code-execution-tool-sandboxing` | agentic | tool-misuse | LLM05 | ASI05 | — |
| GAPT-056 | `testing-destructive-tool-invocation-without-confirmation` | agentic | tool-misuse | LLM06 | ASI02 | — |
| GAPT-057 | `testing-tool-output-rendering-and-second-order-injection` | agentic | tool-misuse | LLM05 | ASI02 | — |
| GAPT-058 | `testing-tool-rate-limit-and-quota-abuse` | agentic | tool-misuse | LLM10 | ASI02 | — |
| GAPT-059 | `testing-agent-credential-overprivilege-blast-radius` | agentic | identity-abuse | LLM06 | ASI03 | — |
| GAPT-060 | `testing-confused-deputy-via-user-impersonation` | agentic | identity-abuse | LLM06 | ASI03 | — |
| GAPT-061 | `testing-token-and-secret-exfiltration-from-agent-context` | agentic | identity-abuse | LLM02 | ASI03 | — |
| GAPT-062 | `testing-cross-tenant-action-via-shared-agent-instance` | agentic | identity-abuse | LLM06 | ASI03 | — |
| GAPT-063 | `testing-delegation-chain-privilege-escalation` | agentic | identity-abuse | LLM06 | ASI03 | — |
| GAPT-064 | `testing-mcp-server-supply-chain-tampering` | agentic | supply-chain | LLM03 | ASI04 | — |
| GAPT-065 | `testing-mcp-tool-shadowing-and-namespace-collision` | agentic | supply-chain | — | ASI04 | — |
| GAPT-066 | `testing-rug-pull-mcp-tool-description-mutation` | agentic | supply-chain | LLM03 | ASI04 | — |
| GAPT-067 | `testing-third-party-plugin-and-skill-vetting` | agentic | supply-chain | LLM03 | ASI04 | — |
| GAPT-068 | `testing-malicious-skill-injection-via-shared-registries` | agentic | supply-chain | LLM03 | ASI04 | — |
| GAPT-069 | `testing-model-supply-chain-and-checksum-verification` | agentic | supply-chain | LLM03 | ASI04 | — |
| GAPT-070 | `testing-autogpt-style-rce-via-natural-language` | agentic | code-execution | LLM05 | ASI05 | — |
| GAPT-071 | `testing-eval-and-exec-injection-via-generated-code` | agentic | code-execution | LLM05 | ASI05 | — |
| GAPT-072 | `testing-jupyter-kernel-and-notebook-escape` | agentic | code-execution | LLM05 | ASI05 | — |
| GAPT-073 | `testing-container-and-vm-breakout-from-agent-sandbox` | agentic | code-execution | LLM05 | ASI05 | — |
| GAPT-074 | `testing-long-term-memory-poisoning-persistence` | agentic | memory-poisoning | LLM01 | ASI06 | — |
| GAPT-075 | `testing-rag-index-poisoning-via-document-upload` | agentic | memory-poisoning | LLM08 | ASI06 | — |
| GAPT-076 | `testing-self-reinforcing-memory-loop` | agentic | memory-poisoning | LLM04 | ASI06 | — |
| GAPT-077 | `testing-memory-segmentation-cross-user-leakage` | agentic | memory-poisoning | LLM02 | ASI06 | — |
| GAPT-078 | `testing-summarization-attack-context-compression-poisoning` | agentic | memory-poisoning | LLM01 | ASI06 | — |
| GAPT-079 | `testing-agent-to-agent-message-spoofing` | agentic | inter-agent | — | ASI07 | — |
| GAPT-080 | `testing-a2a-message-replay-and-tampering` | agentic | inter-agent | — | ASI07 | — |
| GAPT-081 | `testing-multi-agent-collusion-and-false-consensus` | agentic | inter-agent | — | ASI07 | — |
| GAPT-082 | `testing-orchestrator-trust-boundary-bypass` | agentic | inter-agent | LLM06 | ASI07 | — |
| GAPT-083 | `testing-cascading-failure-amplification-across-pipeline` | agentic | cascading-failures | — | ASI08 | — |
| GAPT-084 | `testing-feedback-loop-runaway-and-circuit-breakers` | agentic | cascading-failures | LLM10 | ASI08 | — |
| GAPT-085 | `testing-error-handling-and-graceful-degradation-under-attack` | agentic | cascading-failures | — | ASI08 | — |
| GAPT-086 | `testing-persuasive-output-driving-unsafe-user-actions` | agentic | human-trust | LLM09 | ASI09 | — |
| GAPT-087 | `testing-deceptive-rationale-and-fake-evidence-presentation` | agentic | human-trust | LLM09 | ASI09 | — |
| GAPT-088 | `testing-ai-driven-invoice-fraud-and-vendor-impersonation` | agentic | human-trust | LLM09 | ASI09 | — |
| GAPT-089 | `testing-misaligned-agent-detection-and-quarantine` | agentic | rogue-agents | — | ASI10 | — |
| GAPT-090 | `testing-orchestration-hijack-via-impersonating-approval-agent` | agentic | rogue-agents | — | ASI10 | — |
| GAPT-091 | `testing-agent-action-auditability-and-tamper-resistance` | agentic | observability | — | ASI10 | — |
| GAPT-092 | `testing-agent-kill-switch-and-emergency-stop` | agentic | observability | — | ASI10 | — |
| GAPT-093 | `testing-prompt-and-response-logging-pii-exposure` | agentic | observability | LLM02 | — | — |
| GAPT-094 | `testing-browser-agent-clickjacking-and-overlay-attacks` | agentic | browser-agent | LLM01 | ASI01 | — |
| GAPT-095 | `testing-browser-agent-credential-disclosure-via-form-fields` | agentic | browser-agent | LLM02 | ASI03 | — |
| GAPT-096 | `testing-cua-screen-injection-via-on-screen-text` | agentic | browser-agent | LLM01 | ASI01 | — |
| GAPT-097 | `testing-browser-agent-cookie-and-storage-exfiltration` | agentic | browser-agent | LLM02 | ASI03 | — |
| GAPT-098 | `testing-browser-agent-cross-origin-action-confusion` | agentic | browser-agent | LLM01 | ASI01 | — |
| GAPT-099 | `testing-least-agency-enforcement-action-scope-limits` | agentic | governance | LLM06 | ASI03 | — |
| GAPT-100 | `testing-human-in-the-loop-bypass-via-prompt-engineering` | agentic | governance | LLM06 | ASI09 | — |
| GAPT-101 | `testing-llm-feature-input-validation-and-sanitization` | embedded | input-validation | LLM01 | — | — |
| GAPT-102 | `testing-llm-output-rendering-context-xss` | embedded | output-handling | LLM05 | — | — |
| GAPT-103 | `testing-trust-boundary-violation-untrusted-data-to-prompt` | embedded | trust-boundary | LLM01 | ASI01 | — |
| GAPT-104 | `testing-llm-feature-over-privileged-access-to-app-data` | embedded | authorization | LLM06 | ASI03 | — |
| GAPT-105 | `testing-llm-summarization-injection-to-influence-decisions` | embedded | trust-boundary | LLM01 | ASI01 | — |
| GAPT-106 | `testing-smart-reply-and-autocomplete-secret-leakage` | embedded | data-disclosure | LLM02 | — | — |
| GAPT-107 | `testing-search-feature-prompt-injection-via-query` | embedded | prompt-injection | LLM01 | ASI01 | — |
| GAPT-108 | `testing-llm-driven-classification-evasion-and-bypass` | embedded | evasion | — | — | — |
| GAPT-109 | `testing-llm-translation-and-localization-instruction-injection` | embedded | prompt-injection | LLM01 | ASI01 | — |
| GAPT-110 | `testing-llm-code-completion-supply-chain-via-suggestion` | embedded | supply-chain | LLM09 | ASI04 | — |
| GAPT-111 | `testing-llm-feature-rate-limit-cost-attribution` | embedded | denial-of-wallet | LLM10 | — | — |
| GAPT-112 | `testing-llm-feature-data-residency-and-cross-border-flows` | embedded | compliance | — | — | — |
| GAPT-113 | `testing-llm-feature-third-party-api-key-exposure` | embedded | data-disclosure | LLM02 | ASI03 | — |
| GAPT-114 | `testing-document-upload-feature-prompt-injection-payloads` | embedded | prompt-injection | LLM01 | ASI01 | — |
| GAPT-115 | `testing-llm-content-moderation-bypass-in-host-app` | embedded | evasion | LLM05 | — | — |
| GAPT-116 | `testing-pii-redaction-effectiveness-pre-llm-call` | embedded | data-disclosure | LLM02 | — | — |
| GAPT-117 | `testing-llm-feature-error-message-information-disclosure` | embedded | data-disclosure | LLM02 | — | — |
| GAPT-118 | `testing-llm-feature-csrf-and-state-changing-actions` | embedded | auth | — | — | — |
| GAPT-119 | `testing-llm-prompt-template-injection-developer-controlled` | embedded | prompt-injection | LLM01 | ASI01 | — |
| GAPT-120 | `testing-fallback-and-degraded-mode-security-properties` | embedded | resilience | — | ASI08 | — |
| GAPT-121 | `testing-llm-feature-feature-flag-and-canary-isolation` | embedded | deployment | — | — | — |
| GAPT-122 | `testing-llm-feature-input-length-and-truncation-attacks` | embedded | input-validation | LLM01 | — | — |
| GAPT-123 | `testing-shared-prompt-cache-cross-user-leakage` | embedded | data-disclosure | LLM02 | — | — |
| GAPT-124 | `testing-streaming-response-injection-and-mid-stream-abort` | embedded | output-handling | LLM05 | — | — |
| GAPT-125 | `testing-tool-or-function-calling-schema-validation-bypass` | embedded | input-validation | LLM05 | ASI02 | — |
| GAPT-126 | `testing-model-card-and-system-card-completeness-review` | cross-cutting | governance | LLM03 | ASI04 | — |
| GAPT-127 | `testing-ai-bom-and-component-inventory-accuracy` | cross-cutting | governance | LLM03 | ASI04 | — |
| GAPT-128 | `testing-third-party-llm-api-egress-and-data-loss-prevention` | cross-cutting | data-protection | LLM02 | — | — |
| GAPT-129 | `testing-incident-response-runbook-for-genai-incidents` | cross-cutting | governance | — | ASI10 | — |
| GAPT-130 | `testing-red-team-coverage-and-eval-suite-against-deployed-model` | cross-cutting | governance | — | — | — |
| GAPT-131 | `testing-mcp-hardcoded-credentials-in-config-and-server-code` | mcp | mcp-token-mgmt | LLM02 | ASI03 | MCP01 |
| GAPT-132 | `testing-mcp-token-exfiltration-via-prompt-injection` | mcp | mcp-token-mgmt | LLM02 | ASI03 | MCP01 |
| GAPT-133 | `testing-mcp-token-leakage-in-debug-logs-and-traces` | mcp | mcp-token-mgmt | LLM02 | — | MCP01 |
| GAPT-134 | `testing-mcp-token-lifetime-rotation-and-scope-narrowness` | mcp | mcp-token-mgmt | — | ASI03 | MCP01 |
| GAPT-135 | `testing-mcp-scope-creep-over-engagement-lifetime` | mcp | mcp-scope-creep | LLM06 | ASI03 | MCP02 |
| GAPT-136 | `testing-mcp-scope-elevation-via-prompt-engineering` | mcp | mcp-scope-creep | LLM06 | ASI03 | MCP02 |
| GAPT-137 | `testing-mcp-tool-description-injection-attacks` | mcp | mcp-tool-poisoning | LLM01 | ASI04 | MCP03 |
| GAPT-138 | `testing-mcp-tool-rug-pull-description-mutation-detection` | mcp | mcp-tool-poisoning | LLM03 | ASI04 | MCP03 |
| GAPT-139 | `testing-mcp-tool-schema-poisoning-and-parameter-spoofing` | mcp | mcp-tool-poisoning | LLM03 | ASI04 | MCP03 |
| GAPT-140 | `testing-mcp-tool-shadowing-namespace-collision-attacks` | mcp | mcp-tool-poisoning | — | ASI04 | MCP03 |
| GAPT-141 | `testing-mcp-package-typosquatting-and-malicious-publisher` | mcp | mcp-supply-chain | LLM03 | ASI04 | MCP04 |
| GAPT-142 | `testing-mcp-server-dependency-cve-scanning` | mcp | mcp-supply-chain | LLM03 | ASI04 | MCP04 |
| GAPT-143 | `testing-mcp-server-update-mechanism-and-supply-chain-integrity` | mcp | mcp-supply-chain | LLM03 | ASI04 | MCP04 |
| GAPT-144 | `testing-mcp-server-shell-injection-via-tool-arguments` | mcp | mcp-command-injection | LLM05 | ASI05 | MCP05 |
| GAPT-145 | `testing-mcp-server-path-traversal-and-file-access` | mcp | mcp-command-injection | LLM05 | ASI05 | MCP05 |
| GAPT-146 | `testing-mcp-server-ssrf-via-url-parameters` | mcp | mcp-command-injection | LLM05 | ASI02 | MCP05 |
| GAPT-147 | `testing-mcp-intent-flow-subversion-via-tool-output` | mcp | mcp-intent-flow | LLM01 | ASI01 | MCP06 |
| GAPT-148 | `testing-mcp-progressive-intent-drift-multi-turn` | mcp | mcp-intent-flow | LLM01 | ASI01 | MCP06 |
| GAPT-149 | `testing-mcp-server-endpoint-authentication-bypass` | mcp | mcp-authn-authz | — | ASI03 | MCP07 |
| GAPT-150 | `testing-mcp-oauth-confused-deputy-attack-chain` | mcp | mcp-authn-authz | — | ASI03 | MCP07 |
| GAPT-151 | `testing-mcp-session-hijack-and-cross-server-replay` | mcp | mcp-authn-authz | — | ASI03 | MCP07 |
| GAPT-152 | `testing-mcp-audit-log-completeness-and-tamper-resistance` | mcp | mcp-audit-telemetry | — | ASI10 | MCP08 |
| GAPT-153 | `testing-shadow-mcp-server-discovery-across-endpoints` | mcp | mcp-shadow-servers | — | ASI10 | MCP09 |
| GAPT-154 | `testing-mcp-egress-control-against-arbitrary-remote-servers` | mcp | mcp-shadow-servers | — | ASI04 | MCP09 |
| GAPT-155 | `testing-mcp-context-isolation-cross-user-and-cross-session` | mcp | mcp-context-injection | LLM02 | ASI06 | MCP10 |
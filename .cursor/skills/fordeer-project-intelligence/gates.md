/**
 * Soft vs hard agent gates — Fordeer MCP
 *
 * Hard (MCP enforces in tool responses):
 * - contextReady / readyToCode false → agent must not code
 * - hardBlockToolsUntilLoadContext → subset of tools return isError until load_project_context
 * - requireConfirmTaskScopeTool → only confirm_task_scope unlocks large-task readyToCode
 * - hardGateOnStale → catalog STALE blocks readyToCode until enrich_project_knowledge
 *   (catalogs sẵn) or analyze_project (kho trống) — NOT user "ok"
 *
 * Soft (advisory — IDE can still edit files):
 * - workflowGate.warning on other tools
 * - knowledge-stale in taskScopeAssessment is **advisory** by default
 *   (`context.staleTriggersScopeConfirmation=false`) — do not ask user confirm solely for catalog age
 * - readyToCode is a contract for agents, not an OS file lock
 *
 * Confirm vs enrich/analyze vs GitNexus:
 * - Confirm: large/critical blast, validate blocked, critical service, high risk gates
 * - Stale catalog: enrich_project_knowledge once (prefer over re-analyze) — never substitute with "Trả lời ok"
 * - Optional GitNexus/CGC: `code_graph_query` → external MCP → pass
 *   `external_impact_risk` + `external_impact_source` into pre_task_analysis
 *   to soft-balance medium Fordeer impact when call-graph says LOW
 * - Config: `codeGraph.provider` (auto|fordeer|gitnexus|cgc|off),
 *   `preferExternalForImpact`, `hintOnLoadContext`,
 *   `treeSitterCallEdges` (analyze TS/JS call edges → catalog.callEdges)
 *
 * Team tip: combine with PR review / pre-commit hooks if you need OS-level enforcement.
 *
 * MCP timeout → CLI fallback (agent rule `mcp-timeout-cli-fallback`):
 * - If a Fordeer MCP call times out / connection closed → retry via equivalent `fordeer` CLI
 *   with mapped args (e.g. enrich_project_knowledge → `fordeer sync --enrich --force`…).
 * - Tools without CLI: report timeout; optional one MCP retry or split steps — do not invent results.
 */

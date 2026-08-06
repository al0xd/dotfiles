# Fordeer MCP — Tools / Resources / Prompts

Server: **fordeer**. Env: `FORDEER_PROJECT_ROOT` = absolute path to app repo.

MCP đăng ký **3 primitives**: **Tools** (side-effect / gate / query), **Resources** (`fordeer://…`), **Prompts**. ListTools chỉ hiện **tool canonical đã gộp**; tên cũ vẫn CallTool được (alias ẩn).

## Tools đã gộp (ListTools)

| Canonical | Thay cho (alias CallTool) | Cách gọi |
|-----------|---------------------------|----------|
| `agent_rules` | `list_agent_rules`, `remember_agent_rule`, `forget_agent_rule` | `action=list\|remember\|forget` |
| `feature_lookup` | `find_feature`, `get_feature_context`, `find_related_feature` | `action=find\|context\|related` |
| `file_sitemap` | `search_file_sitemap`, `lookup_file_sitemap`, `get_project_file_sitemap` | `action=search\|lookup\|full` |
| `shopify_knowledge` | `get_shopify_app_knowledge`, `get_shopify_ui_knowledge` | `focus=app\|ui\|all` |
| `search_task_knowledge` | `find_related_knowledge` | `mode=semantic` (legacy) hoặc `mode=task` |
| `generate_project_documentation` | `generate_project_readme` | `target=readme\|feature\|…` |
| `load_project_context` | `get_project_knowledge` | cùng args |

## Tools — Tier 1 (luôn gọi trước)

| Tool | Khi nào |
|------|---------|
| `load_project_context` | **Đầu tiên** mọi task. Catalog-first: `mustReadBeforeCoding` (+ agent-memory/pitfall top-k) + `snapshot`; `analyzeRecommendation` / `nextContextTool`; **HYBRID** `codeGraphAvailability` / `hybridCallGraph` / `nextGraphTool`. Implementation: `readyToCode` luôn false → `pre_task_analysis`. |
| `agent_rules` | `action=list\|remember\|forget` — rules user yêu cầu ghi nhớ |
| `pre_task_analysis` | Trước khi **sửa code**. Confirm chỉ large/critical. HYBRID: truyền `external_impact_risk` + source từ GitNexus/CGC (LOW downgrade / HIGH escalate); thiếu risk khi preferred → advisory `externalImpactSuggested`. |
| `confirm_task_scope` | Ghi nhận user xác nhận phạm vi (persisted + TTL) |
| `evaluate_performance_impact` | Trước implement UI/extension/async |
| `evaluate_race_condition_risk` | Trước implement async/shared-state |
| `evaluate_security_risk` | Auth, secrets, injection, XSS, webhook HMAC, PII |
| `evaluate_code_reuse` | Tái sử dụng trước khi tạo module mới |
| `find_dead_code_candidates` | Exported symbols 0-dependent |
| `evaluate_knowledge_update` | **Sau** code; nếu `featureMemoryAssessment.required` / `nextMandatoryTool=save_feature_memory` → BẮT BUỘC `save_feature_memory`; docs → hỏi user; QA qua `qaNotesAssessment` |
| `generate_qa_notes` | User yêu cầu viết QA → notes chuyên nghiệp + `trackerPosting` (Linear/Jira/GitHub) |

## Resources (`fordeer://…`)

| URI | Khi nào |
|-----|---------|
| `fordeer://setup` | Onboarding session — map Tools/Resources/Prompts |
| `fordeer://project/snapshot` | Đếm catalog (features/symbols/sitemap/…) không semantic |
| `fordeer://project/freshness` | Stale + catalogs → `enrich_project_knowledge`; kho trống → `analyze_project`; không confirm user vì catalog cũ |
| `fordeer://project/agent-rules` | Rules đang active |
| `fordeer://project/directories` | Directory catalog |
| `fordeer://project/features` | Feature list |
| `fordeer://project/feature/{name}` | Chi tiết một feature |
| `fordeer://project/sitemap?q=&limit=` | File sitemap hits |
| `fordeer://project/symbols?q=&limit=` | Symbol hits |
| `fordeer://project/architecture/{id}` | Architecture doc |
| `fordeer://project/shopify` / `docker` / `tech-specs` | Domain peeks |
| `fordeer://workflow` | Session flags load/analyze |

## Prompts (user-selected)

| Prompt | Mục đích |
|--------|----------|
| `start_task` | Bootstrap: resources → `load_project_context` → enrich nếu stale+catalogs; analyze nếu trống |
| `implement_feature` | Gates trước code; enrich thay analyze khi catalogs sẵn |
| `review_code` | PR review SOP |
| `pre_commit_impact` | detect_changes + impact |
| `refresh_if_stale` | Enrich (catalogs) / analyze (empty) một lần rồi search — không re-analyze mid-task |
| `implement_feature` | Playbook implement/fix + gates + confirm blast only |
| `review_code` | Review với intelligence |
| `pre_commit_impact` | `detect_changes` + `impact_analysis` |
| `refresh_if_stale` | Analyze một lần rồi search — không re-analyze mid-task |
| `debug_issue` | Debug: sitemap/symbols + search |
| `write_qa_notes` | QA notes sau task + auto-comment tracker |

## Tier 2 — Định vị trong repo

| Tool | Khi nào |
|------|---------|
| `file_sitemap` | **Tìm / tra file** — `action=full` (trước grep), `search`, `lookup` (một path trước khi mở) |
| `find_project_directory` | Tìm thư mục / app / package |
| `search_code_symbols` | Tìm symbol (lexical + embedding) |
| `search_task_knowledge` | Kiến thức theo task (`scope`, `mode=task\|semantic`). CLI: `fordeer search` |
| `pack_project_intelligence` | Pack context kiểu Repomix. CLI: `fordeer pack` |
| `feature_lookup` | `action=find\|context\|related` |

## Tier 3 — Domain

| Tool | Khi nào |
|------|---------|
| `shopify_knowledge` | `focus=app\|ui\|all` — packages / Polaris+BFS (local). API schema → Shopify Dev MCP |
| `get_docker_knowledge` | Compose, Dockerfile, ops |
| `get_business_rules` | Rules theo feature |
| `get_glossary` | Thuật ngữ domain |
| `get_service_metadata` | Critical services |

> **Shopify API schema/docs:** MCP riêng **`shopify-dev-mcp`**.

## Tier 4 — Trước / sau thay đổi code

| Tool | Khi nào |
|------|---------|
| `impact_analysis` | Fordeer 3-tier **fallback** + `byDepth` + `confidence`; external preferred → `delegateTo` / `nextGraphTool` |
| `get_symbol_context` | Callers/callees + processes |
| `code_graph_query` | Facade callers/callees/… — local Fordeer + `delegateTo` GitNexus/CGC; `answeredBy`/`preferredProvider`; **không** set readyToCode |
| `rename_symbol` | Rename có kiểm soát (dry-run mặc định) |
| `route_map` / `api_impact` | Routes + impact theo route |
| `get_execution_processes` | Xấp xỉ execution flows |
| `detect_changes` | Git diff → symbols (pre-commit); risk ≥ medium → soft `gitHistoryHints` (advisory) |
| `git_history_hints` | Soft git log/blame — reviewer/ownership/debug; **không** ảnh hưởng readyToCode/confirm |
| `validate_change` | Kiểm tra vs rules |
| `find_similar_pattern` | Pattern tương tự |
| `save_feature_memory` / `get_memory_history` / `invalidate_feature_memory` / `consolidate_feature_memory_episodes` | Feature memory — save syncs sidecar+main; episodes cũ auto-archive khi vượt `memory.episodeKeepRecent` |
| `add_agent_memory` / `search_agent_memory` / `get_memory_graph` | Agent memory |

Hot catalog tools gắn `knowledgeFreshness` (soft).

## Tier 5 — Bảo trì kho & documentation

| Tool | Khi nào |
|------|---------|
| `analyze_project` | Bootstrap khi kho trống. Catalogs sẵn → **redirect** `enrich_project_knowledge` (`prefer_enrich`). Fresh → **BLOCK**. `force` khi cần full. |
| `enrich_project_knowledge` | **Ưu tiên** khi catalogs sẵn nhưng stale/thiếu embeds/stubs. CLI: `fordeer sync --enrich`. |
| `update_project_knowledge` | Re-index embeddings. CLI: `fordeer sync`. |
| `confirm_documentation_update` | Sau khi user đồng ý docs |
| `generate_project_documentation` | `target`: readme \| project \| feature \| all \| brief. CLI: `fordeer docs\|readme`. |
| `generate_qa_notes` | QA notes chuyên nghiệp; `trackerPosting` để comment Linear/Jira/GitHub. CLI: `fordeer qa`. |
| `generate_project_viz` | HTML + Mermaid viz |

### MCP timeout → CLI fallback (bắt buộc)

Khi CallTool MCP fordeer **timeout** / connection closed / `-32000` / AbortError:

1. **Retry bằng CLI** tương đương (cùng project root `-p`), map args gần đúng.
2. Báo user đã fallback CLI vì MCP timeout; tiếp tục workflow như bình thường nếu CLI OK.
3. Không bịa kết quả khi cả MCP lẫn CLI fail.

| MCP tool | CLI fallback | Args gợi ý |
|----------|--------------|------------|
| `enrich_project_knowledge` | `fordeer sync --enrich` | `force`→`--force`, `skip_llm`→`--skip-llm`, `mode=full`→`--mode full` |
| `analyze_project` | `fordeer analyze` | `force`→`--force`, `mode`→`--mode` |
| `update_project_knowledge` | `fordeer sync` | `force`→`--force`, `--mode` nếu cần |
| `search_task_knowledge` | `fordeer search "<task>"` | query/task text |
| `pack_project_intelligence` | `fordeer pack` | options tương ứng nếu có |
| `generate_qa_notes` | `fordeer qa` | `--change-summary`, `--ticket`, files… |
| `generate_project_documentation` | `fordeer docs` / `fordeer readme` | theo `target` |

Tool gate/confirm (`load_project_context`, `pre_task_analysis`, `confirm_*`, `evaluate_*`…): **không** có CLI — báo timeout, thử MCP lại một lần hoặc tách bước.

Rule mặc định: `agent-rules/mcp-timeout-cli-fallback.yaml`.

### Luồng QA notes (khi user yêu cầu)

```
User: "viết QA" / Prompt write_qa_notes
  → (optional) Linear/Jira MCP lấy AC
  → generate_qa_notes
  → trackerPosting.shouldPost?
       → YES: post commentBody lên MCP tracker
       → NO: giao notes + skippedReason
```

Chi tiết: [qa-notes.md](qa-notes.md).

### Luồng documentation (bắt buộc hỏi user)

```
evaluate_knowledge_update
  → documentationAssessment.needed? (chỉ phức tạp cao + ảnh hưởng lớn)
       → HIỆN confirmationPrompt (+ writeStrategy) — DỪNG
       → User Có → confirm_documentation_update → generate_project_documentation
       → Không needed → bỏ qua hỏi docs (feature thường)
```

`writeStrategy`: `update-readme` (README có sẵn → **chỉ bổ sung**), `create-readme`, `split-docs` (**dài và quan trọng** → guide dưới `docs/…` + link README), `create-feature-doc`. Brief có `qualityChecklist`: Overview, luồng, code mẫu, test cases.

## Thứ tự gợi ý — implement feature

1. `load_project_context` — đọc `analyzeRecommendation` / `nextContextTool`
2. Chỉ khi stale + catalogs → `enrich_project_knowledge` **một lần**. Kho trống / `required_*` → `analyze_project`. Kho fresh → search / Resources
3. `file_sitemap` (`action=full` / `lookup`)
4. `shopify_knowledge` / `get_docker_knowledge` (nếu liên quan)
5. `evaluate_*` hoặc gộp trong `pre_task_analysis`
6. `pre_task_analysis` — chỉ code khi `readyToCode === true`
7. `feature_lookup` → **`impact_analysis`** → `get_business_rules`
8. `find_similar_pattern` → import/extend trước khi tạo file mới
9. Trước commit: **`detect_changes`**
10. `evaluate_knowledge_update` → docs nếu cần

## Thứ tự gợi ý — review PR (SOP: [pr-review.md](pr-review.md))

Prompt `review_code` / `pre_commit_impact` là điểm vào; SOP đầy đủ ở [pr-review.md](pr-review.md) (gồm **§1b Evidence Discovery** + **§7b Unit-Test Spec Review**).

1. `load_project_context({ task: "<PR summary>", task_kind: "review" })` — review không cần `readyToCode`
2. **`detect_changes`** (`scope: "compare"`, `base_ref: "<origin/target>"`) — diff PR → symbol overlap + `impactPreview` + `summary.riskLevel` + `catalogCoverage` + **`unitTestRisk`** (gồm `evidenceDiscovery`)
3. **Evidence Discovery + Unit-test Spec Review** khi behavior đổi / `unitTestRisk.riskLevel ≠ none`: parallel PM/docs/chat; Primary vs Supporting; conflicts; confidence; Case A giữ expectation; Case B cần Primary evidence; **không** approve sửa test chỉ để CI xanh; **không** coi code/test update là đủ evidence
4. `file_sitemap` (`action=lookup`) từng file đổi; `get_business_rules` + `get_glossary` + `search_task_knowledge`
5. Symbol/API nóng → **`impact_analysis`** (`confidence`, `ambiguousTargets`) + `get_symbol_context` + `api_impact` / `route_map` + `get_execution_processes`
6. `evaluate_security_risk` + `evaluate_race_condition_risk` + `evaluate_performance_impact` + `evaluate_code_reuse` + `find_dead_code_candidates` (vùng async/UI/cache/auth/webhook/helpers)
7. `validate_change` (khi ý định thay đổi rõ) → tổng hợp finding theo severity/confidence → Final Summary (**Unit-test review** + **Evidence confidence**) + Merge Recommendation

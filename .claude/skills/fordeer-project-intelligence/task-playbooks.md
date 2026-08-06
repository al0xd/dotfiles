# Task playbooks — Fordeer

Dùng cùng skill `fordeer-project-intelligence`. Luôn bắt đầu `load_project_context`.

## Implement / fix bug

**task_kind:** `implementation`

1. `load_project_context({ task, task_kind: "implementation" })` — đọc `mustReadBeforeCoding`, `symbolHits`, `knowledgeFreshness`, `analyzeRecommendation` (`readyToCode` từ load = false)
2. Chỉ khi `analyzeRecommendation` = `enrich_recommended` / `knowledgeFreshness.stale` + catalogs sẵn → `enrich_project_knowledge` **một lần** (CLI `fordeer sync --enrich`). Kho trống / `required_setup_or_analyze` → `analyze_project`. Kho fresh → `search_task_knowledge` (không analyze lại; MCP redirect `prefer_enrich` nếu gọi analyze). **MCP timeout** → retry CLI cùng args (vd. `fordeer sync --enrich --force`) — xem [mcp-tools.md](mcp-tools.md) § MCP timeout.
3. Với mỗi file dự kiến sửa: `lookup_file_sitemap({ path })`
4. `evaluate_code_reuse` + `find_similar_pattern` + `search_code_symbols` — đọc `reuseCandidates` trước khi tạo mới
5. Shopify? → `get_shopify_app_knowledge` + UI? → `get_shopify_ui_knowledge`
   - **Shopify API** (GraphQL/REST/Admin/Storefront/webhooks/Billing)? → BẮT BUỘC gọi **Shopify Dev MCP** (`shopify-dev-mcp`). Nếu MCP thiếu/lỗi → dừng đoán API, bảo user cài `npx -y @shopify/dev-mcp@latest` ([docs](https://shopify.dev/docs/apps/build/dev-mcp)) rồi Restart MCP.
6. Docker? → `get_docker_knowledge`
7. **HYBRID call-graph:** đọc `codeGraphAvailability` / `hybridCallGraph` / `nextGraphTool` từ load.
   - `preferExternalImpact=true` (có `.gitnexus/` hoặc CGC) → gọi MCP ngoài (`gitnexus_impact` / CGC callers) **trước** sửa symbol nóng — **không bịa** nếu MCP thiếu.
   - Truyền `external_impact_risk` + `external_impact_source` vào bước 8.
   - Fordeer `impact_analysis` / `code_graph_query` = **fallback 3-tier** (vẫn chạy; đọc `delegateTo`).
8. `pre_task_analysis` (gồm perf/race/security/reuse + `assess_task_scope`) — **chỉ** code khi `readyToCode === true`; nếu risk HIGH do trùng capability → import/extend trước. Nếu `taskScopeAssessment.requiresUserConfirmation` → trình bày `confirmationPrompt`, **DỪNG**, chờ user tối đa `noReplyTimeoutMs` (~2 phút). Không trả lời → theo `recommendedAction` (**safer**: không `confirm_task_scope`, không mở rộng blast). User đồng ý → `confirm_task_scope`. Thiếu `external_impact_risk` khi hybrid preferred → chỉ **advisory** (`externalImpactSuggested`), không block.
9. `find_feature` → **`impact_analysis`** (Fordeer fallback; đọc `confidence`, `edgeStats`, `delegateTo`/`nextGraphTool`; truyền `path=` nếu trùng tên) → `get_business_rules`
10. Implement (diff tối thiểu) — **tái sử dụng** + **kiểm tra race condition** (async order, shared state, double-submit, cleanup)
11. Trước commit: **`detect_changes`** + tùy chọn `find_dead_code_candidates` — nếu `catalogCoverage.symbolOverlapRate` thấp / `partial=true` → `enrich_project_knowledge({ force: true })` (hoặc `analyze_project({ force: true })` nếu catalogs trống) rồi chạy lại
12. `evaluate_knowledge_update`; nếu `featureMemoryAssessment.required` → BẮT BUỘC `save_feature_memory` (xem `confirmationPrompt` / `suggestedPayload`)
13. Nếu `documentationAssessment.needed` → hỏi user theo `confirmationPrompt` → `confirm_documentation_update` → `generate_project_documentation` (hoặc viết README theo brief)
14. Nếu user yêu cầu **viết QA** (hoặc `qaNotesAssessment.suggested` + user đồng ý) → xem playbook **QA notes** bên dưới

## Pull Request review (AI Reviewer)

**task_kind:** `review`

Khi user yêu cầu "review PR / MR / pull request / branch / thay đổi này" → review như senior reviewer theo SOP đầy đủ 35 rules: **[pr-review.md](pr-review.md)**. Tóm tắt pipeline:

1. **Parse PR** — đọc title/description, linked Jira `FC-*`, commits, previous reviews, `CODEOWNERS`, ADR. Chưa hiểu mục tiêu → **không** review. Lấy diff: `detect_changes({ scope: "compare", base_ref: "<origin/target>" })` (PR từ xa: checkout branch hoặc `gh pr diff <n>` rồi `detect_changes`)
   - **Evidence Discovery (§1b):** khi behavior đổi / Case B — parallel search mọi knowledge system authorized (Linear/Jira/GitHub Issues + Outline/Notion/Confluence/ADR + Slack/Teams Supporting). Classify Primary vs Supporting; detect conflicts; confidence High|Medium|Low|Unknown. MCP thiếu/needsAuth → **không bịa**, nêu đã bỏ qua (chi tiết: [pr-review.md](pr-review.md) §1b)
2. `load_project_context({ task: "<PR summary>", task_kind: "review" })` — không cần `readyToCode`; đọc `mustReadBeforeCoding`
3. **Load knowledge:** `get_business_rules`, `get_glossary`, `find_related_knowledge`, `search_task_knowledge`; domain gate `get_shopify_*` / `get_docker_knowledge` nếu liên quan
4. **Classify PR** (feature/bugfix/refactor/perf/security/migration/dep/test/docs) → checklist tương ứng; chỉ review **hành vi mới/bị ảnh hưởng** (bỏ legacy/dead code)
5. **Dependency + graph:** với symbol/model/API đổi → `impact_analysis({ path })` (đọc `confidence`, `ambiguousTargets`), `get_symbol_context`, `api_impact` / `route_map`, `get_execution_processes`; `lookup_file_sitemap` từng file
6. **Risk scoring:** đọc `detect_changes.summary.riskLevel` + `impactPreview` + `catalogCoverage` + **`unitTestRisk`**; review file rủi ro cao trước
7. **Unit-test Spec Review (bắt buộc khi production/test đổi)** — chi tiết [pr-review.md](pr-review.md) §7b:
   - Đọc `unitTestRisk.reviewCase` (A–D), `requiredQuestions`, `evidenceDiscovery`, `neverRules`, `affectedTests`
   - Case A: giữ expectation; fail → sửa production trừ khi có Primary evidence
   - Case B: Investigation + Evidence Discovery; thiếu Primary / confidence=Unknown → Unverified Business Change (HIGH)
   - **Không** approve sửa test chỉ để CI xanh; **không** coi code/test update là đủ evidence business rule
8. **Specialized review** (async/UI/cache/auth/webhook/helpers): `evaluate_security_risk` + `evaluate_race_condition_risk` + `evaluate_performance_impact` + `evaluate_code_reuse` + `find_dead_code_candidates`; `validate_change` khi ý định rõ
9. **Merge → dedupe → confidence filter:** gộp comment trùng; mặc định publish Critical/High/Medium; confidence < 60% không tự đăng
10. Mỗi comment: **Nguyên nhân · Bằng chứng · Tác động (kèm business impact) · Đề xuất sửa**; không chắc → ngôn ngữ xác suất, đề nghị xác minh
11. Sinh **Final Summary** (Unit-test review + Evidence confidence) + **Merge Recommendation** (✅ / ⚠️ / ❌ / 🔍) theo mẫu trong [pr-review.md](pr-review.md)
12. PR cập nhật → resolve comment đã sửa, chỉ review phần thay đổi mới; **không** post comment lên GitHub/GitLab khi user chưa yêu cầu rõ

## Debug

**task_kind:** `debug`

1. `load_project_context`
2. `search_file_sitemap` / `find_related_knowledge` với error message
3. `find_feature` + route spec trong `routes/`
4. Shopify/Docker gates nếu lỗi ở integration
5. Trace từ entry (sitemap `kind: entry`) xuống service

## Plan / giải thích kiến trúc

**task_kind:** `plan` hoặc `other`

1. `load_project_context`
2. `directories/index.md` + `architecture/`
3. `find_related_knowledge` cho câu hỏi
4. Không sửa code trừ khi user yêu cầu implement

## Shopify UI (Polaris)

1. `load_project_context`
2. `get_shopify_ui_knowledge` — **bắt buộc**
3. Nếu đụng Admin/Storefront API phía sau UI → **Shopify Dev MCP** (không đoán schema)
4. `lookup_file_sitemap` cho components/pages
5. Tuân App Design + BFS; dùng Polaris components có sẵn trong repo
6. `readyToCode` + implement → `evaluate_knowledge_update`

## Shopify API (Admin / Storefront / webhooks)

1. `load_project_context` + `get_shopify_app_knowledge`
2. **Bắt buộc** gọi **Shopify Dev MCP** (`shopify-dev-mcp` / `@shopify/dev-mcp`) để introspect schema / docs / validate query
3. Nếu MCP không có trong tool list hoặc lỗi kết nối → **không đoán API**; bảo user thêm vào Cursor MCP:

```json
{
  "mcpServers": {
    "shopify-dev-mcp": {
      "command": "npx",
      "args": ["-y", "@shopify/dev-mcp@latest"]
    }
  }
}
```

   Docs: https://shopify.dev/docs/apps/build/dev-mcp — Restart MCP rồi tiếp tục
4. Implement theo api_version / scopes trong `shopify.app.toml` + packages.yaml

## Shopify extensions (storefront / checkout)

1. `load_project_context`
2. `get_shopify_app_knowledge` với `change_summary` — gate **extension performance** bắt buộc
3. Đọc `extension-performance-guide.md` + checklist (bundle/DOM/network/main thread)
4. Mỗi thay đổi extension hoặc tính năng lớn: ghi **performance review** trước merge
5. Đối chiếu BFS storefront (Lighthouse không giảm >10 điểm)

## Docker / local run

1. `load_project_context`
2. `get_docker_knowledge` — ports, service names, build context
3. Không đoán port; lấy từ `docker/compose-services.yaml`

## QA notes (sau nhiệm vụ hoàn thành)

Khi user nói "viết QA", "QA notes", "how to verify", "acceptance checklist" → SOP đầy đủ: **[qa-notes.md](qa-notes.md)**. Tóm tắt:

1. `load_project_context` (nếu chưa) — `task_kind: "other"`
2. Có ticket/branch/`FC-*` / Linear URL → MCP **Linear / Jira** lấy mô tả + AC (thiếu MCP → không bịa)
3. Optional: `detect_changes` lấy `files_changed`
4. `generate_qa_notes({ change_summary, files_changed, ticket?, branch?, acceptance_criteria?, test_commands?, test_results?, post_to_tracker: true })`
5. Tick `qualityChecklist`; bổ sung evidence thật + **URL test / versions** (đọc `deploy-*-on-pr.yml` / `deploy-*-on-main.yml`)
6. Nếu `trackerPosting.shouldPost` → **post ngay** `commentBody` lên Linear/Jira/GitHub MCP theo `instruction`
7. Giao path file + tóm tắt + trạng thái post cho user

Prompt: `write_qa_notes`. CLI: `fordeer qa`.

## Documentation (README / feature doc)

1. Sau code: `evaluate_knowledge_update` — đọc `documentationAssessment`
2. Chỉ hỏi user khi `needed` (phức tạp cao **và** ảnh hưởng lớn). Feature thường → bỏ qua. Chờ ≤ `noReplyTimeoutMs` (~2 phút); không trả lời → **safer: skip docs** (`recommendedAction`)
3. Nếu `needed`: hiện `confirmationPrompt` — **không** tự ghi README
4. User đồng ý → `confirm_documentation_update` → nhận `documentationBrief` (rules + sections + `writeStrategy`)
5. Viết theo `writeStrategy` **và** `qualityChecklist` (Overview, luồng/Mermaid, code mẫu, test cases):
   - `update-readme` — README đã có → **chỉ bổ sung/cập nhật** (mode=update), không rewrite
   - `create-readme` — README hoàn chỉnh: TOC, Overview, Stack, Architecture/flow, Getting started, Usage, Testing, Structure
   - `split-docs` — **dài và quan trọng** → guide đầy đủ dưới `docs/` + README tóm tắt/link
   - `create-feature-doc` → `docs/features/<slug>.md` (flow + samples + test matrix) + link README nếu có
6. Hoặc `generate_project_documentation({ target })` theo `recommendedGeneratorTarget`, rồi bổ sung samples/tests nếu generator chưa đủ
7. Alias: `generate_project_readme` / CLI `fordeer readme|docs`

## User confirm — no reply

Khi agent hỏi user (scope, docs, lựa chọn rủi ro, …):

1. Hiện `confirmationPrompt` (hoặc AskQuestion) kèm **Recommended (safer)**
2. Chờ tối đa `noReplyTimeoutMs` (mặc định **120s** / `context.userConfirmNoReplyTimeoutMs`)
3. User trả lời → tuân theo câu trả lời (`confirm_task_scope` / `confirm_documentation_update` / …)
4. **Không trả lời / hết giờ** → theo `recommendedAction` (**safer**): không tự `confirm_*`, không mở rộng blast; docs → skip; lựa chọn khác → giữ hiện trạng ít rủi ro nhất
5. Báo lại cho user đã áp dụng safer vì timeout

## Onboarding repo mới (agent)

1. Kiểm tra `.project-intelligence` — nếu thiếu: setup + analyze **một lần**
2. `load_project_context({ task: "understand project architecture" })`
3. Đọc `sitemap/index.md`, `directories/index.md`
4. `enrich_project_knowledge` nếu catalogs sẵn nhưng stale/thiếu; `analyze_project` chỉ nếu kho trống / `required_setup_or_analyze`
5. Các lần sau trong session: `search_task_knowledge` — không analyze lại

## Git commits (Linear)

1. Tracker **Linear** — user đã chọn → nhớ (`add_agent_memory` / convention); không hỏi lại Jira `FC-*`
2. Prefix ≈ **Brand / Linear team** (Fordeer → `FOR`). Mơ hồ → MCP `list_teams` / `get_team`
3. Hỏi xác nhận commit **nhẹ**; chỉ hỏi issue key khi chưa biết (nhánh/chat/MCP)
4. **Không** commit / gợi ý commit lên `main`/`master` — feature branch `FOR-123-…` trước
5. Signed `-S`. Ví dụ: `FOR-123 docs: Prefer README supplement or docs/ split`

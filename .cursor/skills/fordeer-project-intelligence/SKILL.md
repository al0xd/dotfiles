---
name: fordeer-project-intelligence
description: >-
  Applies full Fordeer Project Intelligence (.project-intelligence, MCP fordeer)
  before coding, reviewing, debugging, planning, or writing QA notes in a
  Fordeer/Shopify monorepo. Use when the repo has .project-intelligence, fordeer
  MCP, Shopify/Polaris UI, Docker compose, route specs, file sitemap, directory
  catalog, user asks for QA notes / Linear-Jira comment, or mentions fordeer
  analyze/setup/context.
---

# Fordeer Project Intelligence

Kho tri thức dự án nằm tại `.project-intelligence/`. MCP server: **fordeer** (`FORDEER_PROJECT_ROOT` = repo app).

## Điều kiện bắt đầu

| Trạng thái | Hành động |
|------------|-----------|
| Chưa có `.project-intelligence` | Hướng dẫn: `fordeer setup -p <repo> --cursor` rồi `fordeer analyze -p <repo>` |
| Có kho nhưng cũ / stale | MCP `enrich_project_knowledge` **một lần** (CLI: `fordeer sync --enrich`); giữa task dùng `search_task_knowledge` (không analyze lại từ đầu) |
| Kho fresh / catalogs sẵn | **CẤM** `analyze_project` (tool trả `blocked` / `prefer_enrich` / `catalogs_ready_use_search`) → `search_task_knowledge` / Resources; thiếu embeds/stubs → enrich |
| Kho trống / chưa setup | `analyze_project` / `fordeer analyze` (bootstrap) |
| Kho fresh / đã enrich|analyze trong session | `search_task_knowledge` / Resources — bỏ qua analyze |
| MCP không kết nối | Kiểm tra `.cursor/mcp.json` → `node` + `apps/mcp-server/dist/index.js` |

## Tìm file (user prompt)

| User nói | Hành động |
|----------|----------|
| "tìm file", "file nào", "which file", "find file", "tìm trong repo" | `load_project_context` **tự nạp** `fileSitemapContext` (catalog + index) |
| Chỉ cần sitemap | MCP **`file_sitemap({ action: "full", query })`** — gọi TRƯỚC grep |

`fileSitemapContext.catalogHits` + `mustReadBeforeCoding` (required) — không đoán path.

## Ghi nhớ / quên (user prompt)

| User nói | Hệ thống |
|----------|----------|
| "ghi nhớ …", "hãy nhớ …", "remember that …" | `load_project_context` **tự lưu** → `.project-intelligence/agent-rules/` |
| "bỏ qua …", "không cần ghi nhớ …", "forget …" | **Tự xóa** rule khớp |
| Chỉ định rõ | MCP `agent_rules` (`action=remember|forget|list`) |

Rules đã lưu = **required** trong `mustReadBeforeCoding` mọi task sau.

## MCP primitives

| Cần | Dùng |
|-----|------|
| Side effect / gate / analyze / confirm | **Tool** |
| Đọc catalog (freshness, sitemap, symbols, shopify…) | **Resource** `fordeer://…` |
| Playbook multi-step (user chọn) | **Prompt** `start_task`, `implement_feature`, … |

Chi tiết URI/prompt: [mcp-tools.md](mcp-tools.md).

## Workflow bắt buộc (mọi task)

```
- [ ] 0. (tuỳ chọn) READ fordeer://setup + fordeer://project/freshness — hoặc Prompt start_task
- [ ] 1. Tool load_project_context({ task, task_kind? }) — hard gate (Resource không thay thế)
- [ ] 2. contextReady === true — đọc mustReadBeforeCoding (required trước)
- [ ] 3. Chỉ `enrich_project_knowledge` khi `analyzeRecommendation=enrich_recommended` / stale + catalogs sẵn; chỉ `analyze_project` khi `required_setup_or_analyze` / catalogs trống. Catalog fresh → **không** gọi analyze (tool sẽ `blocked`/`prefer_enrich`). Giữa task: READ Resources / search_task_knowledge
- [ ] 4. Tra cứu vị trí: Resource sitemap/symbols hoặc `find_project_directory` / `file_sitemap`
- [ ] 5. Trước mở file: `file_sitemap({ action: "lookup", path })`
- [ ] 6. Nếu sửa code: Prompt implement_feature HOẶC evaluate_* → pre_task_analysis → readyToCode === true
- [ ] 7. Sau code: `evaluate_knowledge_update` — nếu `featureMemoryAssessment.required` → BẮT BUỘC `save_feature_memory` trước khi đóng task
- [ ] 7b. Đọc agent-memory/pitfall trong `mustReadBeforeCoding` (required) trước khi code
- [ ] 8. Nếu `documentationAssessment.needed`: **hỏi user** theo `confirmationPrompt` → user đồng ý → `confirm_documentation_update` → theo `writeStrategy`: README có sẵn → chỉ bổ sung; dài+quan trọng → `docs/` + link README / `generate_project_documentation`
- [ ] 9. User yêu cầu **viết QA**: Prompt `write_qa_notes` hoặc `generate_qa_notes` → nếu `trackerPosting.shouldPost` → comment Linear/Jira/GitHub MCP (xem [qa-notes.md](qa-notes.md))
```

**task_kind:** `implementation` | `review` | `debug` | `plan` | `other`  

- `load_project_context` với **implementation**: `readyToCode` luôn **false**; xem `knowledgeGatesPassed` + `knowledgeFreshness` + `symbolHits`.
- Chỉ tạo/sửa file khi `readyToCode === true` từ **`pre_task_analysis`** (hoặc sau khi `evaluate_performance_impact` + `evaluate_race_condition_risk` + `evaluate_security_risk` + `evaluate_code_reuse` pass trong pre_task).

## Phân nhánh theo loại task

| Task | Thêm sau bước 1 |
|------|------------------|
| **Implement / fix** | `evaluate_performance_impact` + `evaluate_race_condition_risk` + `evaluate_security_risk` + `evaluate_code_reuse` → `pre_task_analysis` → gates Shopify/Docker → `find_feature` → `impact_analysis` → `find_similar_pattern` |
| **Shopify app** | `get_shopify_app_knowledge` + **Shopify Dev MCP** (`shopify-dev-mcp`) khi đụng Admin/Storefront/GraphQL/REST API |
| **Shopify UI / Polaris** | `shopify_knowledge({ focus: "ui" })` — [App Design](https://shopify.dev/docs/apps/design), [BFS](https://shopify.dev/docs/apps/launch/built-for-shopify/requirements) |
| **Shopify extension / storefront** | `get_shopify_app_knowledge` + Shopify Dev MCP (nếu API) + đọc `extension-performance-guide.md`; đánh giá hiệu năng mỗi thay đổi/tính năng lớn |
| **Docker / deploy** | `get_docker_knowledge` |
| **Review PR / MR** | Review như senior reviewer theo SOP → [pr-review.md](pr-review.md): parse PR → **Evidence Discovery** (parallel Linear/Jira/Issues + Outline/ADR/docs + Slack Supporting) → `detect_changes` (**`unitTestRisk` + `evidenceDiscovery`**) → Unit-Test Spec Review (§7b) → load knowledge → risk scoring → `evaluate_*` → summary + merge recommendation. Không cần readyToCode |
| **Review / plan** | `search_task_knowledge` / `find_related_knowledge`, `get_business_rules`, `get_glossary` — không cần readyToCode |
| **Feature mới** | Sau code: `save_feature_memory` |
| **Docs / README** | `evaluate_knowledge_update` → hỏi user → `confirm_documentation_update` → `update-readme` (bổ sung) hoặc `split-docs`/`create-feature-doc` (dài+quan trọng → `docs/` + link) / `generate_project_documentation` |
| **QA notes** | User yêu cầu viết QA → [qa-notes.md](qa-notes.md) / Prompt `write_qa_notes` → `generate_qa_notes` → auto-comment Linear/Jira/GitHub khi phát hiện |

Chi tiết từng playbook: [task-playbooks.md](task-playbooks.md)

Review Pull Request (SOP + Unit-Test Spec Review): [pr-review.md](pr-review.md)

QA notes (sau task hoàn thành): [qa-notes.md](qa-notes.md)

Soft vs hard gates: [gates.md](gates.md)

## Tái sử dụng & tối ưu (implement)

1. `evaluate_code_reuse` + `find_similar_pattern` + `search_code_symbols` — trước khi tạo module/service/component mới.
2. Đọc `reuseCandidates` (action: import → extend → compose → read-first); `lookup_file_sitemap` / `get_symbol_context`.
3. Ưu tiên `packages/*`, `@fordeer/ui`, services/patterns trong `.project-intelligence/patterns/`.
4. Mở rộng code có sẵn — không copy-paste logic trùng; tránh death code (`find_dead_code_candidates`).
5. Tối ưu ngoài scope → gợi ý 1–3 bullet cho user, không refactor lan.

Rule mặc định: `agent-rules/prefer-reuse-before-create.yaml`.

## Tránh race condition (mọi task code)

Luôn kiểm tra và tránh lỗi race condition khi implement/review/debug:

| Vùng | Cần làm |
|------|---------|
| **Async / event** | Không giả định thứ tự callback, Promise, setTimeout, WebSocket message |
| **Shared state** | Lock/mutex/ref count; React state batching; tránh stale closure |
| **UI** | Disable double-submit; `AbortController` hủy request cũ; debounce rapid clicks |
| **Backend** | DB transaction; optimistic lock; unique constraint; idempotent webhook/job |
| **Cache** | Read-modify-write phải atomic hoặc có version check |
| **Cleanup** | Remove listener/observer/interval khi unmount hoặc job kết thúc |

Rule đã lưu: `agent-rules/avoid-race-condition.yaml`, `agent-rules/avoid-insecure-patterns.yaml`, `agent-rules/write-tech-comments.yaml`, `agent-rules/use-shopify-dev-mcp.yaml`, `agent-rules/mcp-timeout-cli-fallback.yaml` (mặc định setup/analyze).

## MCP timeout → CLI (mọi task)

Nếu MCP fordeer **timeout**: retry bằng CLI (`enrich_project_knowledge` → `fordeer sync --enrich`, …). Chi tiết map args: [mcp-tools.md](mcp-tools.md) § MCP timeout.

## Bảo mật (mọi task code)

Luôn gọi `evaluate_security_risk` **trước** implement và **sau** khi viết xong nếu đụng auth/webhook/secrets:

| Vùng | Cần làm |
|------|---------|
| **Secrets** | Không hardcode; env/secret manager; rotate nếu lộ |
| **Input** | Validate/sanitize query, body, header, upload |
| **AuthZ** | Least privilege; verify session/token mỗi protected route |
| **Injection** | Parameterized SQL; tránh eval/exec/shell với user input |
| **XSS** | Escape output; tránh innerHTML với user content |
| **Webhook** | Verify HMAC/signature (Shopify raw body) trước side-effect |
| **PII** | Không log email/password/token; redact errors |

Rule mặc định: `agent-rules/avoid-insecure-patterns.yaml`.

## Shopify Dev MCP (bắt buộc khi làm Shopify API)

Fordeer MCP (`get_shopify_*`) = knowledge **local** của repo.  
**Shopify Dev MCP** (`shopify-dev-mcp` / `@shopify/dev-mcp`) = schema/docs API chính thức.

Khi code Admin GraphQL/REST, Storefront API, webhooks, Billing, extensions API:

1. Gọi **Shopify Dev MCP** — không đoán schema/API từ trí nhớ.
2. Gọi Fordeer `get_shopify_app_knowledge` / `get_shopify_ui_knowledge`.
3. Nếu Shopify Dev MCP **không có / lỗi / không hỗ trợ** → **dừng đoán API**, bảo user cài:

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

Docs: [Dev MCP](https://shopify.dev/docs/apps/build/dev-mcp) · [AI toolkit](https://shopify.dev/docs/apps/build/ai-toolkit) — rồi Restart MCP.

## Comment & đặc tả kỹ thuật (implement)

Khi tạo/sửa code **luôn** bổ sung comment mô tả:
- **File** — mục đích / phạm vi đầu file
- **Function / class** — trách nhiệm, params, return, side-effect
- **Biến quan trọng** — ý nghĩa nghiệp vụ / invariant
- Marker thu thập: `@fordeer-rule`, `@business-rule`, `IMPORTANT`

**MCP bắt buộc:** `evaluate_security_risk` trước/sau implement; `evaluate_code_reuse` trước implement; `evaluate_race_condition_risk` trước implement; `evaluate_performance_impact` khi đụng UI/extension/async/network.

## Kho tri thức — đọc gì trước

| Nhu cầu | Path / tool |
|---------|-------------|
| Stack, versions | `tech-specs/project-tech-spec.yaml` |
| Comment / tech docs | `inline-knowledge/index.md`, rules promote trong `agent-rules/from-source-*` |
| Thư mục / app | `directories/index.md`, `find_project_directory` |
| File cụ thể | `lookup_file_sitemap`, `sitemap/lookup.yaml` |
| Routes / API | `routes/*.md` |
| Feature | `features/*.yaml`, `get_feature_context` |
| Shopify | `shopify/*`, Fordeer `get_shopify_*` + **Shopify Dev MCP** (API/schema) |
| Docker | `docker/*`, `get_docker_knowledge` |

Bản đồ đầy đủ: [knowledge-store.md](knowledge-store.md)

## MCP tools (fordeer)

**52 tools.** Danh sách đầy đủ, thứ tự ưu tiên: [mcp-tools.md](mcp-tools.md)

Gợi ý định vị code: `search_code_symbols` + sitemap. `code_graph_query` / `impact_analysis` dùng **Tree-sitter callEdges** (TS/JS, `codeGraph.treeSitterCallEdges`) + 3-tier; delegate GitNexus/CGC optional. `knowledgeFreshness.stale` hard-gate (`context.hardGateOnStale`).

## Không được

- Đoán package version, route path, compose port, Shopify API — lấy từ briefing / Fordeer MCP / **Shopify Dev MCP**.
- Đoán GraphQL/REST Shopify khi Dev MCP thiếu — phải bảo user cài `@shopify/dev-mcp`.
- Mở file lớn blind — luôn `lookup_file_sitemap` trước.
- Bỏ qua `load_project_context` vì “task nhỏ”.
- Commit/push trừ khi user yêu cầu (Fordeer git rules).

## CLI tham khảo

```bash
fordeer setup -p . --cursor
fordeer analyze -p .          # bootstrap lần đầu / kho trống
fordeer sync --enrich -p .    # bổ sung kiến thức còn thiếu (ưu tiên thay analyze lại)
fordeer docs --assess-only --change-summary "..." --files "a.ts,b.ts"
fordeer docs --target readme|feature|all
fordeer readme # alias
fordeer sync -p .
```

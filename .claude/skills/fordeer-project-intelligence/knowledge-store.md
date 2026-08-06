# `.project-intelligence/` — Knowledge map

Auto-filled by `fordeer analyze`. Human edits welcome for architecture/business.

## Cấu trúc thư mục

| Dir | Nội dung | Agent dùng khi |
|-----|----------|----------------|
| `architecture/` | Tổng quan hệ thống | Hiểu layers, deployment |
| `directories/` | `catalog.yaml`, `index.md` — **mục đích từng thư mục** | Không biết code ở đâu |
| `sitemap/` | `index.md`, `files.yaml`, `lookup.yaml` — **từng file** | Trước khi mở file |
| `routes/` | Spec method/path/handler | API, webhook, routing |
| `tech-specs/` | `project-tech-spec.yaml` | Stack, versions, constraints |
| `features/` | Feature YAML (entry, services) | Scope feature |
| `feature-memory/` | Patterns, mistakes đã học | Tránh lặp lỗi |
| `agent-memory/` | Pitfall / convention (Mem0-style); `expiresAt` được enforce khi search/briefing; memory mới được recency boost | mustRead + `search_agent_memory` |
| `memory-episodes/` | Episode provenance (hot); cũ → `memory-episodes/archive/<feature>/` qua consolidate | `get_memory_history` / `consolidate_feature_memory_episodes` |
| `business/` | Business rules | Validate logic |
| `glossary/` | Thuật ngữ | Đúng domain language |
| `critical/` | Critical services | Không phá service nhạy cảm |
| `patterns/` | Coding patterns | Implement đúng convention |
| `shopify/` | packages, Polaris, BFS guides | Shopify app + UI |
| `docker/` | compose, operations | Local/prod containers |
| `agents/` | Workflows YAML | pre-task steps |
| `agent-rules/` | Rule mặc định (`write-tech-comments`, `avoid-race-condition`) + user ghi nhớ + promote từ comment | Tuân thủ mọi task |
| `inline-knowledge/` | Comment JSDoc + docs kỹ thuật (catalog) | Convention từ source |
| `skills/` | Generated feature skills | Per-feature context |
| `generated/` | Discovery snapshots | Metadata analyze |

## Ba lớp định vị (nhớ thứ tự)

1. **Thư mục** → `directories/index.md` hoặc `find_project_directory`
2. **File** → `lookup_file_sitemap` hoặc `sitemap/lookup.yaml`
3. **Nội dung sâu** → mở source + `routes/`, `features/`, semantic search

## Semantic categories (embeddings)

`architecture`, `feature`, `feature-memory`, `business`, `glossary`, `pattern`, `directory`, `file`, `convention`, `history`

Dùng `find_related_knowledge` hoặc `search_file_sitemap` khi không biết file path.

## Làm mới kho

```bash
fordeer analyze -p .
# hoặc MCP analyze_project → update_project_knowledge
```

Sau thay đổi lớn: `package.json`, routes, `shopify.app.toml`, compose → analyze lại.

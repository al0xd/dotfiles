# AI QA Notes — Fordeer

SOP viết **QA notes chuyên nghiệp** sau khi hoàn thành nhiệm vụ. Kích hoạt khi user nói: "viết QA", "QA notes", "ghi chú QA", "how to verify", "acceptance checklist", "viết QA cho task này".

> **Triết lý:** Đủ để QA/PM verify nhanh · AC có Pass/Fail/N/A + evidence · **URL test + versions** · test thật · không bịa · post tracker khi dự án dùng Linear/Jira/GitHub.

## Quy trình (bắt buộc theo thứ tự)

```
Load context → Pull ticket AC (Linear/Jira) → Collect evidence + deploy URLs
→ generate_qa_notes → Fill gaps (URLs/versions) → Post tracker comment → Deliver to user
```

### 1. Load context

1. `load_project_context({ task: "Write QA notes for <summary>", task_kind: "other" })`
2. Optional: `detect_changes` để lấy `files_changed` + risk
3. Optional Prompt: `write_qa_notes`

### 2. Nguồn ticket (Linear / Jira / GitHub)

**Khi nào kích hoạt** — phát hiện trong branch / summary / PR / lời user:
- Jira / Fordeer: `FC-\d+`, `[A-Z][A-Z0-9]+-\d+`
- Linear: `ABC-123` hoặc URL `linear.app/…/issue/…`
- GitHub: URL `github.com/…/issues|pull/…`

**Cách lấy AC (không đoán tên tool):**

| Nguồn | MCP | Hành động |
|-------|-----|-----------|
| **Linear** | `linear` | Search/get issue → đọc title, description, AC, comments |
| **Jira** | `jira` / `atlassian` / `mcp-atlassian` | Get issue → summary, description, AC |
| **GitHub** | `github` | Get issue/PR body |

Quy tắc:
1. MCP **không có / needsAuth / lỗi** → **không bịa** AC; ghi gap trong Follow-ups.
2. Chỉ đọc issue liên quan trực tiếp task.

### 2b. Test environment URLs + versions (bắt buộc khi có deploy)

Tester cần **URL mở được** + **version** (client / server / extension) nếu dự án có preview.

1. Xem `brief.context.deployWorkflows` từ `generate_qa_notes` (tự scan `.github/workflows/`).
2. **Đọc** các file kiểu:
   - `deploy-be-on-main.yml` / `deploy-be-on-pr.yml`
   - `deploy-ui-on-main.yml` / `deploy-ui-on-pr.yml`
   - (và `deploy-extension-*.yml` nếu có)
3. Suy URL + version từ `env` / `outputs` / script trong workflow — **không bịa** URL.
4. Điền vào notes / args: `test_environment_urls`, `versions`.
5. Repo không có deploy workflow → ghi **N/A** + cách verify local.

### 3. Sinh QA notes

Gọi:

```
generate_qa_notes({
  change_summary,
  files_changed,
  feature?,
  ticket?,
  branch?,
  acceptance_criteria?,  // từ tracker nếu có
  test_commands?,
  test_results?,
  test_environment_urls?, // từ deploy workflows
  versions?,              // client/server/extension nếu có
  risks?,
  how_to_verify?,
  write: true,
  post_to_tracker: true
})
```

Notes phải cover:
- Summary · Scope · AC · Test evidence · **Test environment (URLs + versions)** · How to verify · Risks · Files · Follow-ups

Tick `qualityChecklist` trước khi coi là xong. Chỉ điền evidence thật.

### 4. Auto-comment tracker (bắt buộc khi đủ điều kiện)

Nếu `trackerPosting.shouldPost === true`:
1. Post **ngay** `trackerPosting.commentBody` lên issue (`trackerPosting.issueKey`) qua MCP tương ứng (`trackerPosting.mcpServerHints`).
2. Tuân `trackerPosting.instruction`.
3. MCP lỗi → nêu `skippedReason`; **vẫn** giao file/markdown QA cho user.

Nếu `shouldPost === false`:
- `no_ticket_ref` → hỏi user issue key hoặc chỉ giao notes.
- `tracker_mcp_not_configured` → đề nghị bật MCP Linear/Jira, vẫn giao notes.

**Không** post GitHub/GitLab PR review trừ khi user yêu cầu rõ.

### 5. Giao cho user

Trả: đường dẫn file (`.project-intelligence/generated/qa-notes/…`), tóm tắt 3–5 bullet (**kèm URL test nếu có**), trạng thái post tracker (posted / skipped + lý do).

## CLI

`fordeer qa --change-summary "…" --files a.ts,b.ts --ticket FC-123`

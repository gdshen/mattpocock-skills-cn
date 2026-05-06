# 编写 Agent Briefs

Agent brief 是 issue 移动到 `ready-for-agent` 时发布在 GitHub issue 上的结构化 comment。它是 AFK agent 将依据的权威 specification。原始 issue body 和讨论是 context；agent brief 才是 contract。

## 原则

### Durability 优先于 precision

Issue 可能会在 `ready-for-agent` 中停留数天或数周。期间代码库会变化。Brief 要写得即使文件被重命名、移动或 refactor 后仍然有用。

- **要**描述 interfaces、types 和 behavioral contracts
- **要**命名 agent 应查找或修改的具体 types、function signatures 或 config shapes
- **不要**引用 file paths；它们会过期
- **不要**引用 line numbers
- **不要**假设当前 implementation structure 会保持不变

### 描述 behavior，不描述 procedure

描述系统应该做**什么**，而不是**如何**实现。Agent 会重新探索代码库，并做自己的 implementation decisions。

- **好：** “`SkillConfig` type should accept an optional `schedule` field of type `CronExpression`”
- **坏：** “Open src/types/skill.ts and add a schedule field on line 42”
- **好：** “When a user runs `/triage` with no arguments, they should see a summary of issues needing attention”
- **坏：** “Add a switch statement in the main handler function”

### 完整 acceptance criteria

Agent 需要知道什么时候算完成。每个 agent brief 都必须有具体、可测试的 acceptance criteria。每条 criterion 都应该能独立验证。

- **好：** “Running `gh issue list --label needs-triage` returns issues that have been through initial classification”
- **坏：** “Triage should work correctly”

### 显式 scope boundaries

说明哪些内容 out of scope。这能防止 agent 镀金或对相邻 features 做假设。

## 模板

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** 对需要发生什么的一行描述

**当前行为：**
描述现在发生什么。对 bugs，这是 broken behavior。
对 enhancements，这是 feature 所建立在的 status quo。

**期望行为：**
描述 agent 工作完成后应该发生什么。
具体说明 edge cases 和 error conditions。

**Key interfaces:**
- `TypeName` — 需要改变什么以及为什么
- `functionName()` return type — 当前返回什么 vs 应该返回什么
- Config shape — 需要的任何新 configuration options

**验收标准：**
- [ ] 具体、可测试的 criterion 1
- [ ] 具体、可测试的 criterion 2
- [ ] 具体、可测试的 criterion 3

**范围外：**
- 不应该在此 issue 中改变或处理的东西
- 看起来相关但其实独立的相邻 feature
```

## 示例

### 好 agent brief（bug）

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description 截断发生在词中间，产生损坏输出

**当前行为：**
当 skill description 超过 1024 个字符时，它会严格在第 1024 个字符截断，
不考虑 word boundaries。这会产生以半个词结尾的 descriptions
（例如“用于用户想要 confi”）。

**期望行为：**
截断应该发生在 1024 个字符之前的最后一个 word boundary，
并追加 "..." 来表示被截断。

**Key interfaces:**
- `SkillMetadata` type 的 `description` field：不需要 type change，
  但填充它的 validation/processing logic 需要尊重 word boundaries
- 任何读取 SKILL.md frontmatter 并提取 description 的 function

**验收标准：**
- [ ] 1024 chars 以下的 descriptions 保持不变
- [ ] 1024 chars 以上的 descriptions 在 1024 chars 前最后一个 word boundary 截断
- [ ] 被截断 descriptions 以 "..." 结尾
- [ ] 包含 "..." 在内的总长度不超过 1024 chars

**范围外：**
- 改变 1024 char limit 本身
- Multi-line description support
```

### 好 agent brief（enhancement）

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 添加 `.out-of-scope/` directory support，用于追踪被拒绝的 feature requests

**当前行为：**
当 feature request 被拒绝时，issue 会带 `wontfix` label 和 comment 关闭。
没有持久记录保存该 decision 或 reasoning。未来类似 requests 需要 maintainer
回忆或搜索之前的讨论。

**期望行为：**
被拒绝的 feature requests 应记录到 `.out-of-scope/<concept>.md` 文件中，
捕获 decision、reasoning，以及所有请求该 feature 的 issue links。
triaging new issues 时，应检查这些文件是否匹配。

**Key interfaces:**
- `.out-of-scope/` 中的 Markdown file format：每个文件应有
  `# Concept Name` heading、`**Decision:**` line、`**Reason:**` line，
  以及带 issue links 的 `**Prior requests:**` list
- triage workflow 应在早期读取所有 `.out-of-scope/*.md` 文件，
  并按 concept similarity 匹配 incoming issues

**验收标准：**
- [ ] 将 feature 以 wontfix 关闭时，在 `.out-of-scope/` 中创建/更新文件
- [ ] 文件包含 decision、reasoning 和已关闭 issue 的 link
- [ ] 如果匹配的 `.out-of-scope/` 文件已存在，新 issue 会追加到其
      "Prior requests" list，而不是创建 duplicate
- [ ] triage 期间，如果 new issue 匹配先前 rejection，会检查并展示既有
      `.out-of-scope/` 文件

**范围外：**
- Automated matching（由人类确认 match）
- 重新打开 previously rejected features
- Bug reports（只有 enhancement rejections 进入 `.out-of-scope/`）
```

### 坏 agent brief

```markdown
## Agent Brief

**Summary:** 修复 triage bug

**要做什么：**
triage 这个东西坏了。看看 main file 并修好它。
line 150 附近的 function 有问题。

**Files to change:**
- src/triage/handler.ts (line 150)
- src/types.ts (line 42)
```

这很糟，因为：
- 没有 category
- 描述模糊（“triage 这个东西坏了”）
- 引用了会过期的 file paths 和 line numbers
- 没有 acceptance criteria
- 没有 scope boundaries
- 没有 current vs desired behavior 描述

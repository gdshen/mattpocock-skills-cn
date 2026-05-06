# 范围外知识库（Out-of-Scope Knowledge Base）

Repo 中的 `.out-of-scope/` directory 存储被拒绝 feature requests 的持久记录。它有两个目的：

1. **Institutional memory**：记录 feature 为什么被拒绝，避免 issue 关闭后 reasoning 丢失
2. **Deduplication**：当 new issue 匹配先前 rejection 时，skill 可以展示之前 decision，而不是重新争论

## 目录结构

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

每个 **concept** 一个文件，而不是每个 issue 一个文件。请求同一件事的多个 issues 归到同一个文件下。

## 文件格式

文件应采用轻松、可读的风格，更像短 design document，而不是 database entry。使用 paragraphs、code samples 和 examples，让首次接触的人也能理解 reasoning。

```markdown
# 深色模式

此项目不支持 dark mode 或 user-facing theming。

## 为什么它 out of scope

Rendering pipeline 假设只有 `ThemeConfig` 中定义的一套 color palette。
支持 multiple themes 将需要：

- 一个包住整个 component tree 的 theme context provider
- 每个 component 都要做 theme-aware style resolution
- 用于 user theme preferences 的 persistence layer

这是重大的 architectural change，不符合项目聚焦 content authoring 的方向。
Theming 是 embed 或 redistribute 输出的 downstream consumers 应关心的问题。

```ts
// 当前 ThemeConfig interface 不是为 runtime switching 设计的：
interface ThemeConfig {
  colors: ColorPalette; // 单 palette，在 build time resolve
  fonts: FontStack;
}
```

## 历史请求

- #42 — “Add dark mode support”
- #87 — “Night theme for accessibility”
- #134 — “Dark theme option”
```

### 文件命名

为 concept 使用简短、描述性的 kebab-case 名称：`dark-mode.md`、`plugin-system.md`、`graphql-api.md`。名称要足够可识别，让浏览目录的人无需打开文件就能理解拒绝了什么。

### 编写理由

理由应该有实质内容，不是“我们不想要”，而是为什么。好理由会引用：

- Project scope 或 philosophy（“This project focuses on X; theming is a downstream concern”）
- Technical constraints（“Supporting this would require Y, which conflicts with our Z architecture”）
- Strategic decisions（“We chose to use A instead of B because...”）

理由应该 durable。避免引用临时情况（“we're too busy right now”）；那不是真正 rejection，只是 deferral。

## 何时检查 `.out-of-scope/`

Triage 期间（Step 1: Gather context），读取 `.out-of-scope/` 中的所有文件。评估 new issue 时：

- 检查 request 是否匹配既有 out-of-scope concept
- 按 concept similarity 匹配，而不是 keyword；“night theme” 匹配 `dark-mode.md`
- 如果匹配，向 maintainer 展示：“This is similar to `.out-of-scope/dark-mode.md` — we rejected this before because [reason]. Do you still feel the same way?”

Maintainer 可能：

- **Confirm**：new issue 被添加到既有文件的 “Prior requests” list，然后关闭
- **Reconsider**：out-of-scope 文件被删除或更新，issue 进入正常 triage
- **Disagree**：issues 相关但不同，继续正常 triage

## 何时写入 `.out-of-scope/`

只有当 **enhancement**（不是 bug）以 `wontfix` 拒绝时才写入。流程：

1. Maintainer 决定某个 feature request out of scope
2. 检查是否已存在匹配的 `.out-of-scope/` 文件
3. 如果存在：把 new issue 追加到 “Prior requests” list
4. 如果不存在：创建新文件，包含 concept name、decision、reason 和 first prior request
5. 在 issue 上发布 comment，解释 decision 并提到 `.out-of-scope/` 文件
6. 用 `wontfix` label 关闭 issue

## 更新或删除 out-of-scope files

如果 maintainer 改变了对先前 rejected concept 的想法：

- 删除 `.out-of-scope/` 文件
- Skill 不需要重新打开 old issues；它们是 historical records
- 触发 reconsideration 的 new issue 进入正常 triage

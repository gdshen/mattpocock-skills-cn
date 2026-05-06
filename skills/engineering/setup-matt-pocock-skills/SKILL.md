---
name: setup-matt-pocock-skills
description: 在 AGENTS.md/CLAUDE.md 和 `docs/agents/` 中设置 `## Agent skills` 区块，让工程 skills 知道此 repo 的 issue tracker（GitHub 或本地 markdown）、triage label 词汇和 domain doc 布局。在首次使用 `to-issues`、`to-prd`、`triage`、`diagnose`、`tdd`、`improve-codebase-architecture` 或 `zoom-out` 前运行；或当这些 skills 缺少 issue tracker、triage labels 或 domain docs 上下文时运行。
disable-model-invocation: true
---

# 设置 Matt Pocock 的 Skills

搭建工程 skills 默认会读取的 repo 级配置：

- **Issue tracker**：issues 存放在哪里（默认 GitHub；也内置支持本地 markdown）
- **Triage labels**：五个 canonical triage roles 使用的字符串
- **Domain docs**：`CONTEXT.md` 和 ADR 存放在哪里，以及读取它们的 consumer rules

这是 prompt-driven skill，不是确定性脚本。先探索，展示发现，和用户确认，然后写入。

## 流程

### 1. 探索

查看当前 repo，理解起始状态。读取任何已存在内容；不要假设：

- `git remote -v` 和 `.git/config`：这是 GitHub repo 吗？是哪一个？
- repo 根目录的 `AGENTS.md` 和 `CLAUDE.md`：是否存在其中之一？里面是否已有 `## Agent skills` section？
- repo 根目录的 `CONTEXT.md` 和 `CONTEXT-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目录
- `docs/agents/`：这个 skill 之前的输出是否已存在？
- `.scratch/`：这表示可能已经在使用本地 markdown issue tracker 约定

### 2. 展示发现并询问

总结已有和缺失的内容。然后带用户**一次一个**走完三个决策：展示一个 section，拿到用户答案，再进入下一个。不要一次性丢出三个。

假设用户不知道这些术语是什么意思。每个 section 都以简短解释开始（它是什么、为什么这些 skills 需要它、不同选择会改变什么）。然后展示选项和默认值。

**Section A — Issue tracker。**

> 解释：这里的 “issue tracker” 是此 repo 存放 issues 的地方。`to-issues`、`triage`、`to-prd` 和 `qa` 等 skills 会读写它；它们需要知道是调用 `gh issue create`、在 `.scratch/` 下写 markdown 文件，还是遵循你描述的其他流程。请选择你实际追踪这个 repo 工作的位置。

默认姿态：这些 skills 最初按 GitHub 设计。如果 `git remote` 指向 GitHub，就建议 GitHub。如果 `git remote` 指向 GitLab（`gitlab.com` 或自托管 host），就建议 GitLab。否则（或用户偏好时），提供：

- **GitHub**：issues 存在 repo 的 GitHub Issues 中（使用 `gh` CLI）
- **GitLab**：issues 存在 repo 的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **Local markdown**：issues 作为文件存在此 repo 的 `.scratch/<feature>/` 下（适合个人项目或无 remote 的 repo）
- **Other**（Jira、Linear 等）：让用户用一段话描述 workflow；skill 会以自由文本记录

**Section B — Triage label vocabulary。**

> 解释：当 `triage` skill 处理新 issue 时，会让它经过一个状态机：需要评估、等待 reporter、可由 AFK agent 领取、需要人类处理，或 won't fix。为此，它需要应用与你*实际配置*的字符串匹配的 labels（或 issue tracker 中的等价物）。如果你的 repo 已经使用不同 label 名称（例如用 `bug:triage` 而不是 `needs-triage`），就在这里映射，避免 skill 创建重复 labels。

五个 canonical roles：

- `needs-triage`：maintainer 需要评估
- `needs-info`：等待 reporter 提供更多信息
- `ready-for-agent`：已完整指定，AFK-ready（agent 无需人类上下文即可领取）
- `ready-for-human`：需要人类实现
- `wontfix`：不会处理

默认：每个 role 的字符串等于它的名称。询问用户是否想覆盖任意一个。如果 issue tracker 没有既有 labels，默认值即可。

**Section C — Domain docs。**

> 解释：一些 skills（`improve-codebase-architecture`、`diagnose`、`tdd`）会读取 `CONTEXT.md` 来学习项目领域语言，并读取 `docs/adr/` 来了解过去的架构决策。它们需要知道 repo 是一个 global context，还是多个 contexts（例如 frontend/backend 分离的 monorepo），这样才能看对位置。

确认布局：

- **Single-context**：repo 根目录有一个 `CONTEXT.md` + `docs/adr/`。大多数 repo 是这样。
- **Multi-context**：根目录有 `CONTEXT-MAP.md` 指向每个 context 的 `CONTEXT.md` 文件（通常是 monorepo）。

### 3. 确认并编辑

向用户展示草稿：

- 要添加到 `CLAUDE.md` / `AGENTS.md` 中被编辑文件的 `## Agent skills` block（选择规则见第 4 步）
- `docs/agents/issue-tracker.md`、`docs/agents/triage-labels.md`、`docs/agents/domain.md` 的内容

写入前让用户编辑。

### 4. 写入

**选择要编辑的文件：**

- 如果 `CLAUDE.md` 存在，编辑它。
- 否则如果 `AGENTS.md` 存在，编辑它。
- 如果两者都不存在，询问用户要创建哪一个；不要替他们选。

当 `CLAUDE.md` 已存在时，永远不要创建 `AGENTS.md`（反之亦然）；始终编辑已经存在的那个。

如果所选文件中已存在 `## Agent skills` block，就原地更新其内容，而不是追加重复 block。不要覆盖周围 sections 的用户编辑。

Block：

```markdown
## Agent skills

### Issue tracker

[issues 追踪位置的一行摘要]。见 `docs/agents/issue-tracker.md`。

### Triage labels

[label vocabulary 的一行摘要]。见 `docs/agents/triage-labels.md`。

### Domain docs

[布局的一行摘要：single-context 或 multi-context]。见 `docs/agents/domain.md`。
```

然后用此 skill 文件夹中的 seed templates 作为起点，写入三个 docs 文件：

- [issue-tracker-github.md](./issue-tracker-github.md)：GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)：GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md)：local-markdown issue tracker
- [triage-labels.md](./triage-labels.md)：label mapping
- [domain.md](./domain.md)：domain doc consumer rules + layout

对于 “other” issue trackers，根据用户描述从零写 `docs/agents/issue-tracker.md`。

### 5. 完成

告诉用户 setup 已完成，以及哪些 engineering skills 现在会读取这些文件。说明他们之后可以直接编辑 `docs/agents/*.md`；只有当他们想切换 issue trackers 或从头开始时，才需要重新运行此 skill。

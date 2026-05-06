---
name: to-issues
description: 使用 tracer-bullet vertical slices，把 plan、spec 或 PRD 拆成 project issue tracker 上可独立领取的 issues。用于用户想把计划转换成 issues、创建 implementation tickets，或拆分工作时。
---

# 转为 Issues

使用 vertical slices（tracer bullets）把计划拆成可独立领取的 issues。

issue tracker 和 triage label vocabulary 应该已经提供；如果没有，运行 `/setup-matt-pocock-skills`。

## 流程

### 1. 收集上下文

基于当前对话上下文中已有内容工作。如果用户传入 issue reference（issue number、URL 或 path）作为参数，就从 issue tracker 获取它，并读取完整 body 和 comments。

### 2. 探索代码库（可选）

如果尚未探索代码库，就探索它以理解代码当前状态。Issue titles 和 descriptions 应使用项目领域术语表词汇，并尊重你要触碰区域的 ADR。

### 3. 起草 vertical slices

把计划拆成 **tracer bullet** issues。每个 issue 都是贯穿所有 integration layers 的薄 vertical slice，而不是某一层的 horizontal slice。

Slices 可以是 `HITL` 或 `AFK`。HITL slices 需要人类互动，例如架构决策或设计 review。AFK slices 可以在无人互动下实现并 merge。能用 AFK 时优先 AFK。

<vertical-slice-rules>
- 每个 slice 都交付一条狭窄但完整的路径，贯穿每一层（schema、API、UI、tests）
- 完成的 slice 本身可 demo 或可验证
- 优先多个薄 slices，而不是少数厚 slices
</vertical-slice-rules>

### 4. 询问用户

把提议的拆分以编号列表展示。每个 slice 显示：

- **Title**：简短描述名
- **Type**：HITL / AFK
- **Blocked by**：哪些其他 slices 必须先完成（如果有）
- **User stories covered**：它覆盖哪些 user stories（如果源材料有）

询问用户：

- 粒度是否合适？（太粗 / 太细）
- 依赖关系是否正确？
- 是否有 slices 应该合并或继续拆分？
- 标成 HITL 和 AFK 的 slices 是否正确？

迭代直到用户批准拆分。

### 5. 发布 issues 到 issue tracker

对每个已批准 slice，向 issue tracker 发布一个新 issue。使用下面的 issue body template。这些 issues 被视为已准备好给 AFK agents，因此除非另有指示，发布时加上正确的 triage label。

按依赖顺序发布 issues（blockers 优先），这样可以在 “Blocked by” 字段中引用真实 issue identifiers。

<issue-template>
## Parent

issue tracker 上 parent issue 的引用（如果源材料是既有 issue；否则省略此 section）。

## 要构建什么

此 vertical slice 的简明描述。描述 end-to-end behavior，而不是逐层 implementation。

避免具体 file paths 或 code snippets；它们很快会过期。例外：如果 prototype 产出了比文字更精确表达决策的 snippet（state machine、reducer、schema、type shape），可以内联到这里，并简要说明它来自 prototype。只保留决策含量高的部分；不要放完整 demo，只放重要片段。

## 验收标准

- [ ] 标准 1
- [ ] 标准 2
- [ ] 标准 3

## Blocked by

- blocking ticket 的引用（如果有）

如果没有 blockers，写 “None - can start immediately”。

</issue-template>

不要关闭或修改任何 parent issue。

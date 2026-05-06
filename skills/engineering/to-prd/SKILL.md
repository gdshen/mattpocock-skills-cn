---
name: to-prd
description: 把当前对话上下文转换成 PRD，并发布到 project issue tracker。用于用户想根据当前上下文创建 PRD 时。
---

此 skill 使用当前对话上下文和代码库理解产出 PRD。不要采访用户；只综合你已经知道的内容。

issue tracker 和 triage label vocabulary 应该已经提供；如果没有，运行 `/setup-matt-pocock-skills`。

## 流程

1. 如果尚未探索 repo，就探索它以理解代码库当前状态。整个 PRD 都使用项目领域术语表词汇，并尊重你要触碰区域的 ADR。

2. 草拟完成实现需要构建或修改的主要 modules。主动寻找可提取 deep modules 的机会，让它们能独立测试。

Deep module（相对于 shallow module）指把大量功能封装在一个简单、可测试、很少变化的 interface 后面的 module。

和用户确认这些 modules 是否符合预期。和用户确认他们希望为哪些 modules 写测试。

3. 使用下面模板写 PRD，然后发布到 project issue tracker。应用 `needs-triage` triage label，让它进入正常 triage flow。

<prd-template>

## Problem Statement

从用户视角描述用户面临的问题。

## Solution

从用户视角描述问题的解决方案。

## User Stories

一个很长的编号 user stories 列表。每个 user story 应使用以下格式：

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

这个 user stories 列表应该非常完整，覆盖 feature 的所有方面。

## Implementation Decisions

已做 implementation decisions 的列表。可包括：

- 将要构建/修改的 modules
- 将要修改的这些 modules 的 interfaces
- developer 给出的技术澄清
- 架构决策
- Schema changes
- API contracts
- 具体 interactions

不要包含具体 file paths 或 code snippets。它们可能很快过期。

例外：如果 prototype 产出了比文字更精确表达决策的 snippet（state machine、reducer、schema、type shape），可以把它内联到相关 decision，并简要注明它来自 prototype。只保留决策含量高的部分；不要放完整 demo，只放重要片段。

## Testing Decisions

已做 testing decisions 的列表。包括：

- 什么是好测试的描述（只测试 external behavior，不测试 implementation details）
- 哪些 modules 将被测试
- 测试的 prior art（即代码库中相似类型的测试）

## Out of Scope

描述此 PRD 范围之外的内容。

## Further Notes

关于此 feature 的任何补充说明。

</prd-template>

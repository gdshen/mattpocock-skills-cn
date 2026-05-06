---
name: improve-codebase-architecture
description: 根据 CONTEXT.md 中的领域语言和 docs/adr/ 中的决策，在代码库中寻找深化机会。用于用户想改进架构、寻找重构机会、合并紧耦合模块，或让代码库更可测试、更易于 AI 导航时。
---

# 改进代码库架构

暴露架构摩擦，提出 **deepening opportunities（深化机会）**：把 shallow modules（浅模块）重构成 deep modules（深模块）。目标是提升可测试性和 AI 可导航性。

## 术语表

每条建议都必须准确使用这些术语。重点就是语言一致：不要漂移到 "component"、"service"、"API" 或 "boundary"。完整定义见 [LANGUAGE.md](LANGUAGE.md)。

- **Module** — 任何同时有 interface 和 implementation 的东西（函数、类、包、切片）。
- **Interface** — 调用者为了正确使用 module 必须知道的一切：类型、不变量、错误模式、顺序约束、配置。不只是类型签名。
- **Implementation** — 内部代码。
- **Depth** — interface 处的杠杆：小 interface 后面藏着大量行为。**Deep** = 高杠杆。**Shallow** = interface 几乎和 implementation 一样复杂。
- **Seam** — interface 所在的位置；一个不用原地编辑代码也能改变行为的位置。（用这个词，不用 "boundary"。）
- **Adapter** — 在 seam 处满足某个 interface 的具体东西。
- **Leverage** — 调用者从 depth 得到的收益。
- **Locality** — 维护者从 depth 得到的收益：变更、bug、知识集中在一个地方。

关键原则（完整列表见 [LANGUAGE.md](LANGUAGE.md)）：

- **Deletion test（删除测试）**：想象删掉这个 module。如果复杂度消失，它只是传递层。如果复杂度在 N 个调用者处重新出现，它就在创造价值。
- **Interface 就是测试面。**
- **一个 adapter = 假设中的 seam。两个 adapter = 真实 seam。**

此 skill 会受项目 domain model（领域模型）影响。领域语言给好的 seams 命名；ADR 记录此 skill 不该重新争论的决策。

## 流程

### 1. 探索

先读取项目领域术语表，以及你要触碰区域里的所有 ADR。

然后用 Agent 工具和 `subagent_type=Explore` 遍历代码库。不要机械套启发式规则；自然探索，并记录你感受到摩擦的位置：

- 哪里理解一个概念需要在许多小 modules 之间来回跳？
- 哪里 modules 很 **shallow**：interface 几乎和 implementation 一样复杂？
- 哪里为了可测试性抽出了纯函数，但真正 bug 藏在它们如何被调用里（没有 **locality**）？
- 哪里紧耦合 modules 跨过它们的 seams 泄漏？
- 代码库哪些部分没有测试，或很难通过当前 interface 测试？

对任何你怀疑 shallow 的东西应用 **deletion test**：删掉它会集中复杂度，还是只是移动复杂度？答案是“会集中”才是你要的信号。

### 2. 展示候选项

按编号展示 deepening opportunities。每个候选项包含：

- **文件（Files）** — 涉及哪些文件/modules
- **问题（Problem）** — 当前架构为什么造成摩擦
- **方案（Solution）** — 用普通语言说明要改变什么
- **收益（Benefits）** — 用 locality 和 leverage 解释收益，也说明测试如何改善

**领域部分使用 CONTEXT.md 词汇，架构部分使用 [LANGUAGE.md](LANGUAGE.md) 词汇。** 如果 `CONTEXT.md` 定义了 "Order"，就说 "the Order intake module"，不要说 "the FooBarHandler"，也不要说 "the Order service"。

**ADR 冲突**：如果某个候选项和现有 ADR 矛盾，只有当摩擦真实到值得重开 ADR 时才提出。清楚标记（例如：_"和 ADR-0007 矛盾，但值得重开，因为……"_）。不要列出每个被 ADR 禁止的理论重构。

此时不要提出 interfaces。问用户："你想探索哪一个？"

### 3. 追问循环

用户选中候选项后，进入追问对话。和用户一起走设计树：约束、依赖、deepened module（深化后模块）的形状、seam 后面放什么、哪些测试保留。

决策变清晰时，副作用内联发生：

- **用一个不在 `CONTEXT.md` 中的概念给 deepened module 命名？** 把术语加进 `CONTEXT.md`，纪律和 `/grill-with-docs` 一样（见 [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md)）。如果文件不存在，按需创建。
- **对话中把模糊术语变清楚？** 立刻更新 `CONTEXT.md`。
- **用户用有承重意义的理由拒绝候选项？** 提议写 ADR，表达为：_"要我把这点记录成 ADR，避免未来架构 review 再建议它吗？"_ 只有当未来 explorer 确实需要这个理由来避免重复建议同一件事时才提议；跳过短期理由（"现在不值得"）和显而易见理由。见 [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md)。
- **想探索 deepened module 的替代 interfaces？** 见 [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md)。

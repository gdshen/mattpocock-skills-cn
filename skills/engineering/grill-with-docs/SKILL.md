---
name: grill-with-docs
description: 针对既有领域模型拷问计划，打磨术语，并在决策清晰时内联更新文档（CONTEXT.md、ADR）。用于用户想根据项目语言和已记录决策压力测试计划时。
---

<what-to-do>

围绕这个计划的每个方面持续追问我，直到我们达成共同理解。沿设计树的每个分支往下走，逐个解决决策之间的依赖。每个问题都提供你的推荐答案。

一次只问一个问题，等每个问题收到反馈后再继续。

如果某个问题可以通过探索代码库回答，就改为探索代码库。

</what-to-do>

<supporting-info>

## 领域意识

探索代码库时，也查找既有文档：

### 文件结构

大多数 repo 只有一个 context：

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

如果根目录存在 `CONTEXT-MAP.md`，说明 repo 有多个 contexts。这个 map 会指向每个 context 所在位置：

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← 系统级决策
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context 级决策
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

按需创建文件，只有在有内容要写时才创建。如果不存在 `CONTEXT.md`，在第一个术语被厘清时创建。如果不存在 `docs/adr/`，在第一个 ADR 需要时创建。

## 会话期间

### 用术语表挑战表述

当用户使用的术语和 `CONTEXT.md` 里的既有语言冲突时，立刻指出。“你的术语表把 'cancellation' 定义为 X，但你看起来想表达 Y；到底是哪一个？”

### 打磨模糊语言

当用户使用模糊或重载术语时，提出一个精确的 canonical term。“你在说 'account'；你指的是 Customer 还是 User？它们是不同概念。”

### 讨论具体场景

讨论领域关系时，用具体场景压力测试。构造能探测边界情况的场景，迫使用户精确说明概念之间的边界。

### 和代码交叉核对

当用户说明某事如何工作时，检查代码是否一致。如果发现矛盾，就指出：“代码会取消整个 Orders，但你刚说 partial cancellation 是可能的；哪个才对？”

### 内联更新 CONTEXT.md

当术语被厘清时，立刻更新 `CONTEXT.md`。不要攒到一批处理；发生时就记录。使用 [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) 中的格式。

不要让 `CONTEXT.md` 绑定实现细节。只包含对领域专家有意义的术语。

### 谨慎提议 ADR

只有以下三点都成立时，才提议创建 ADR：

1. **难以逆转**：未来改变主意的成本有意义
2. **没有上下文会令人意外**：未来读者会疑惑“为什么他们要这样做？”
3. **真实权衡的结果**：确实存在可选方案，而你们基于具体理由选择了其中一个

如果缺少其中任意一点，就跳过 ADR。使用 [ADR-FORMAT.md](./ADR-FORMAT.md) 中的格式。

</supporting-info>

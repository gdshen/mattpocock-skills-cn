---
name: tdd
description: 使用 red-green-refactor 循环进行测试驱动开发。用于用户想用 TDD 构建功能或修复 bug、提到“red-green-refactor”、想要 integration tests，或要求 test-first development 时。
---

# 测试驱动开发

## 哲学

**核心原则**：测试应该通过 public interfaces 验证行为，而不是验证实现细节。代码可以完全改变；测试不该改变。

**好测试**是 integration-style：它们通过 public APIs 运行真实代码路径。它们描述系统做_什么_，而不是_如何_做。好测试读起来像 specification：“user can checkout with valid cart” 会明确告诉你存在什么能力。这些测试能扛住 refactors，因为它们不关心内部结构。

**坏测试**和 implementation 耦合。它们 mock internal collaborators、测试 private methods，或通过外部手段验证（比如直接查询数据库，而不是使用 interface）。警讯是：你 refactor 时测试坏了，但行为没有改变。如果你重命名一个 internal function 后测试失败，这些测试测的是 implementation，不是 behavior。

示例见 [tests.md](tests.md)，mocking 指南见 [mocking.md](mocking.md)。

## 反模式：Horizontal Slices

**不要先写所有测试，再写所有实现。** 这是 “horizontal slicing”：把 RED 当作“写全部测试”，把 GREEN 当作“写全部代码”。

这会产出**垃圾测试**：

- 批量写出来的测试测的是_想象中_的 behavior，不是_实际_ behavior
- 你最终会测试事物的_形状_（data structures、function signatures），而不是 user-facing behavior
- 测试会对真实变化失敏：行为坏了它们通过，行为没问题它们失败
- 你跑到了灯照范围之外，在理解 implementation 前就承诺了测试结构

**正确做法**：通过 tracer bullets 做 vertical slices。一个测试 → 一个实现 → 重复。每个测试都响应你从上一轮学到的东西。因为你刚写完代码，所以你清楚哪些 behavior 重要，以及如何验证。

```
错误（horizontal）：
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

正确（vertical）：
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## 工作流

### 1. 规划

探索代码库时，使用项目领域术语表，让 test names 和 interface vocabulary 匹配项目语言，并尊重你要触碰区域的 ADR。

写任何代码前：

- [ ] 和用户确认需要哪些 interface changes
- [ ] 和用户确认要测试哪些 behaviors（排序优先级）
- [ ] 识别 [deep modules](deep-modules.md) 的机会（small interface, deep implementation）
- [ ] 为 [testability](interface-design.md) 设计 interfaces
- [ ] 列出要测试的 behaviors（不是 implementation steps）
- [ ] 获得用户对计划的批准

询问：“public interface 应该长什么样？哪些 behaviors 最重要、最需要测试？”

**你不可能测试一切。** 和用户确认到底哪些 behaviors 最重要。把测试精力集中在 critical paths 和 complex logic 上，而不是每个可能 edge case。

### 2. Tracer Bullet

写一个测试，只确认系统的一件事：

```
RED:   为第一个 behavior 写测试 → 测试失败
GREEN: 写刚好通过的最小代码 → 测试通过
```

这是你的 tracer bullet：证明路径能 end-to-end 工作。

### 3. 增量循环

对每个剩余 behavior：

```
RED:   写下一个测试 → 失败
GREEN: 写刚好通过的最小代码 → 通过
```

规则：

- 一次一个测试
- 只写足够通过当前测试的代码
- 不要预判未来测试
- 让测试聚焦可观察 behavior

### 4. Refactor

所有测试通过后，寻找 [refactor candidates](refactoring.md)：

- [ ] 提取重复
- [ ] Deepen modules（把复杂度移到 simple interfaces 后面）
- [ ] 在自然的地方应用 SOLID principles
- [ ] 思考新代码暴露了既有代码的哪些问题
- [ ] 每个 refactor step 后运行测试

**永远不要在 RED 时 refactor。** 先到 GREEN。

## 每轮 checklist

```
[ ] 测试描述 behavior，而不是 implementation
[ ] 测试只使用 public interface
[ ] 测试能扛住 internal refactor
[ ] 代码对这个测试来说是最小的
[ ] 未添加 speculative features
```

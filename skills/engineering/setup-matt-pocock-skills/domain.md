# 领域文档（Domain Docs）

工程 skills 探索代码库时，应如何消费此 repo 的领域文档。

## 探索前读取这些

- **`CONTEXT.md`** at the repo root, or
- 如果 repo 根目录存在 **`CONTEXT-MAP.md`**，读取它：它会指向每个 context 的 `CONTEXT.md`。读取和当前话题相关的每一个。
- **`docs/adr/`**：读取与你即将处理区域相关的 ADR。在 multi-context repos 中，也检查 `src/<context>/docs/adr/` 中 context-scoped 的决策。

如果这些文件不存在，**静默继续**。不要标记它们缺失；不要提前建议创建。生产者 skill（`/grill-with-docs`）会在术语或决策真正被厘清时按需创建。

## 文件结构

Single-context repo（大多数 repo）：

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Multi-context repo（根目录存在 `CONTEXT-MAP.md`）：

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← 系统级决策
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← context 级决策
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## 使用术语表词汇

当你的输出命名领域概念时（issue title、refactor proposal、hypothesis、test name），使用 `CONTEXT.md` 中定义的术语。不要漂移到术语表明确避免的同义词。

如果你需要的概念还不在术语表里，这就是信号：要么你在发明项目并不使用的语言（重新考虑），要么确实存在缺口（记录给 `/grill-with-docs`）。

## 标记 ADR 冲突

如果你的输出和既有 ADR 矛盾，要显式指出，而不是静默覆盖：

> _和 ADR-0007（event-sourced orders）矛盾，但值得重开，因为……_

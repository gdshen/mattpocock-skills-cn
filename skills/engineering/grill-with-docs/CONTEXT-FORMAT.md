# CONTEXT.md 格式

## 结构

```md
# {Context 名称}

{一两句话描述这个 context 是什么以及它为什么存在。}

## 语言

**Order**:
{对该术语的简明描述}
_避免使用_：Purchase, transaction

**Invoice**:
交付后发送给 customer 的付款请求。
_避免使用_：Bill, payment request

**Customer**:
下订单的人或组织。
_避免使用_：Client, buyer, account

## 关系

- 一个 **Order** 产生一个或多个 **Invoices**
- 一个 **Invoice** 恰好属于一个 **Customer**

## 示例对话

> **Dev:** “当 **Customer** 下 **Order** 时，我们会立刻创建 **Invoice** 吗？”
> **Domain expert:** “不会。只有在 **Fulfillment** 确认后才生成 **Invoice**。”

## 已标记的歧义

- “account” 曾同时表示 **Customer** 和 **User**；已解决：它们是不同概念。
```

## 规则

- **要有立场。** 当多个词指向同一概念时，选最好的那个，并把其他词列为要避免的别名。
- **显式标记冲突。** 如果某个术语被模糊使用，在“已标记的歧义”中指出并给出清晰结论。
- **定义要紧。** 最多一句话。定义它是什么，而不是它做什么。
- **展示关系。** 使用加粗术语名，并在明显时表达基数关系。
- **只包含这个项目 context 特有的术语。** 通用编程概念（timeouts、error types、utility patterns）不属于这里，即使项目大量使用。添加术语前先问：这是该 context 独有概念，还是通用编程概念？只有前者应该写入。
- **自然聚类出现时，用子标题分组术语。** 如果所有术语属于一个紧密区域，平铺列表也可以。
- **写一个示例对话。** 用 dev 和 domain expert 的对话展示术语如何自然互动，并澄清相关概念之间的边界。

## 单 context vs 多 context repo

**单 context（大多数 repo）：** repo 根目录一个 `CONTEXT.md`。

**多 contexts：** repo 根目录的 `CONTEXT-MAP.md` 列出 contexts、它们的位置，以及彼此如何关联：

```md
# Context Map（上下文地图）

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — 接收并追踪 customer orders
- [Billing](./src/billing/CONTEXT.md) — 生成 invoices 并处理 payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — 管理仓库 picking 和 shipping

## 关系

- **Ordering → Fulfillment**：Ordering 发出 `OrderPlaced` events；Fulfillment 消费它们以开始 picking
- **Fulfillment → Billing**：Fulfillment 发出 `ShipmentDispatched` events；Billing 消费它们以生成 invoices
- **Ordering ↔ Billing**：共享 `CustomerId` 和 `Money` 类型
```

此 skill 会推断适用哪种结构：

- 如果 `CONTEXT-MAP.md` 存在，读取它来找到 contexts
- 如果只有根目录 `CONTEXT.md`，就是单 context
- 如果两者都不存在，在第一个术语被厘清时按需创建根目录 `CONTEXT.md`

当存在多个 contexts 时，推断当前话题属于哪一个。如果不清楚，就询问。

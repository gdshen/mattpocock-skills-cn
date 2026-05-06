# 语言

此 skill 每条建议共享的词汇。必须准确使用这些术语；不要替换成 "component"、"service"、"API" 或 "boundary"。重点就是语言一致。

## 术语

**Module**
任何同时有 interface 和 implementation 的东西。刻意不绑定规模：函数、类、包、跨层切片都适用。
_避免使用_：unit、component、service。

**Interface**
调用者为了正确使用 module 必须知道的一切。包括类型签名，也包括不变量、顺序约束、错误模式、所需配置、性能特征。
_避免使用_：API、signature（太窄；它们只指类型层面的表面）。

**Implementation**
module 内部的东西，也就是它的代码主体。不同于 **Adapter**：一个东西可以是小 adapter 但有大 implementation（Postgres repo），也可以是大 adapter 但有小 implementation（in-memory fake）。讨论 seam 时用 "adapter"；其他时候用 "implementation"。

**Depth**
interface 处的 leverage：调用者（或测试）每学习一单位 interface 能驱动多少行为。小 interface 后面藏着大量行为时，module 就是 **deep**。interface 几乎和 implementation 一样复杂时，module 就是 **shallow**。

**Seam** _(from Michael Feathers)_
不用编辑当前位置也能改变行为的位置。也就是 module 的 interface 所在的*位置*。选择 seam 放在哪里，本身就是一个设计决策，和 seam 后面放什么不同。
_避免使用_：boundary（和 DDD 的 bounded context 语义重载）。

**Adapter**
在 seam 处满足某个 interface 的具体东西。描述的是*角色*（填哪个槽），不是实体内容（里面有什么）。

**Leverage**
调用者从 depth 得到的收益。每学习一单位 interface，获得更多能力。一个 implementation 能回报 N 个调用点和 M 个测试。

**Locality**
维护者从 depth 得到的收益。变更、bug、知识、验证集中在一个地方，而不是分散到调用者中。修一次，到处都修好。

## 原则

- **Depth 是 interface 的属性，不是 implementation 的属性。** Deep module 内部可以由小的、可 mock、可替换的部分组成；它们只是不属于 interface。module 可以有 **internal seams**（implementation 私有，供自身测试使用），也可以在 interface 处有 **external seam**。
- **Deletion test（删除测试）。** 想象删掉这个 module。如果复杂度消失，module 没隐藏任何东西（只是传递层）。如果复杂度在 N 个调用者处重新出现，module 就在创造价值。
- **Interface 就是测试面。** 调用者和测试跨过同一个 seam。如果你想测试 interface 之后的内部细节，module 形状可能错了。
- **一个 adapter 表示假设中的 seam。两个 adapter 表示真实 seam。** 除非确实有东西会跨 seam 变化，否则不要引入 seam。

## 关系

- 一个 **Module** 恰好有一个 **Interface**（它呈现给调用者和测试的表面）。
- **Depth** 是 **Module** 的属性，相对于它的 **Interface** 来衡量。
- **Seam** 是 **Module** 的 **Interface** 所在的位置。
- **Adapter** 位于 **Seam**，并满足 **Interface**。
- **Depth** 为调用者产生 **Leverage**，为维护者产生 **Locality**。

## 拒绝的表述

- **把 depth 理解成 implementation 行数 / interface 行数的比值**（Ousterhout）：这会奖励给 implementation 灌水。这里改用 depth-as-leverage。
- **把 "Interface" 理解成 TypeScript 的 `interface` 关键字或类的 public methods**：太窄。这里的 interface 包含调用者必须知道的所有事实。
- **"Boundary"**：和 DDD 的 bounded context 语义重载。说 **seam** 或 **interface**。

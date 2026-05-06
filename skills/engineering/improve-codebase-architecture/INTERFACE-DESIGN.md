# Interface 设计

用户想为已选的 deepening 候选项探索替代 interfaces 时，使用这个并行 sub-agent 模式。基于 "Design It Twice"（Ousterhout）：第一个想法通常不是最好的。

使用 [LANGUAGE.md](LANGUAGE.md) 中的词汇：**module**、**interface**、**seam**、**adapter**、**leverage**。

## 流程

### 1. 界定问题空间

启动 sub-agents 前，先为已选候选项写一段面向用户的问题空间说明：

- 任何新 interface 必须满足的约束
- 它依赖哪些东西，这些依赖属于哪个类别（见 [DEEPENING.md](DEEPENING.md)）
- 一个粗略的示意代码草图，用来让约束落地；这不是提案，只是让约束具体化

把这段给用户看，然后立刻进入第 2 步。用户阅读和思考时，sub-agents 并行工作。

### 2. 启动 sub-agents

用 Agent 工具并行启动 3 个以上 sub-agents。每个都必须为 deepened module 产出一个**根本不同**的 interface。

给每个 sub-agent 单独的技术 brief（文件路径、耦合细节、来自 [DEEPENING.md](DEEPENING.md) 的依赖类别、seam 后面有什么）。brief 独立于第 1 步面向用户的问题空间说明。给每个 agent 不同设计约束：

- Agent 1："最小化 interface；目标最多 1-3 个入口点。最大化每个入口点的 leverage。"
- Agent 2："最大化灵活性；支持多种用例和扩展。"
- Agent 3："针对最常见调用者优化；让默认场景极其简单。"
- Agent 4（如适用）："围绕 ports & adapters 设计跨 seam 依赖。"

brief 中同时包含 [LANGUAGE.md](LANGUAGE.md) 词汇和 CONTEXT.md 词汇，让每个 sub-agent 按架构语言和项目领域语言一致命名。

每个 sub-agent 输出：

1. Interface（类型、方法、参数，以及不变量、顺序约束、错误模式）
2. 用法示例，展示调用者如何使用它
3. Implementation 在 seam 后隐藏了什么
4. 依赖策略和 adapters（见 [DEEPENING.md](DEEPENING.md)）
5. 权衡：哪里 leverage 高，哪里 leverage 薄

### 3. 展示和比较

按顺序展示设计，让用户能逐个消化，然后用文字比较。按 **depth**（interface 处的 leverage）、**locality**（变更集中在哪里）、**seam placement**（seam 放在哪里）对比。

比较后给出你自己的建议：你认为哪个设计最强，以及原因。如果不同设计中的元素适合组合，就提出 hybrid。要有观点；用户想要明确判断，不是菜单。

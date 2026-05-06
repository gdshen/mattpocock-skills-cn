---
name: write-a-skill
description: 创建结构正确、支持 progressive disclosure、带 bundled resources 的新 agent skills。用于用户想创建、编写或构建新 skill 时。
---

# 编写 Skills

## 流程

1. **收集需求**：询问用户：
   - 这个 skill 覆盖什么 task/domain？
   - 它应该处理哪些具体 use cases？
   - 它需要 executable scripts，还是只需要 instructions？
   - 是否要包含 reference materials？

2. **起草 skill**：创建：
   - 带简明 instructions 的 SKILL.md
   - 如果内容超过 500 行，创建额外 reference files
   - 如果需要确定性操作，创建 utility scripts

3. **和用户 review**：展示草稿并询问：
   - 这是否覆盖你的 use cases？
   - 是否缺少什么或不清楚？
   - 是否有 section 应更详细或更简短？

## Skill 结构

```
skill-name/
├── SKILL.md           # 主 instructions（必需）
├── REFERENCE.md       # 详细 docs（如需要）
├── EXAMPLES.md        # 使用 examples（如需要）
└── scripts/           # Utility scripts（如需要）
    └── helper.js
```

## SKILL.md 模板

```md
---
name: skill-name
description: 对 capability 的简短描述。用于 [具体触发条件] 时。
---

# Skill 名称

## 快速开始

[最小可用示例]

## 工作流

[复杂任务的逐步流程和 checklists]

## 高级功能

[链接到单独文件：见 [REFERENCE.md](REFERENCE.md)]
```

## Description 要求

当 agent 决定加载哪个 skill 时，description 是**它唯一看到的内容**。它会和所有其他已安装 skills 一起出现在 system prompt 中。Agent 读取这些 descriptions，并根据用户请求选择相关 skill。

**目标**：给 agent 足够信息，让它知道：

1. 此 skill 提供什么 capability
2. 何时/为什么触发它（specific keywords、contexts、file types）

**格式**：

- 最多 1024 chars
- 用第三人称写
- 第一句：它做什么
- 第二句：`用于 [具体触发条件] 时`

**好示例**：

```
从 PDF 文件中提取文本和表格、填写表单、合并文档。用于处理 PDF 文件，或用户提到 PDFs、forms、document extraction 时。
```

**坏示例**：

```
Helps with documents.
```

坏示例无法让 agent 区分它和其他 document skills。

## 何时添加 Scripts

在以下情况添加 utility scripts：

- Operation 是 deterministic（validation、formatting）
- 同一段代码会被反复生成
- Errors 需要显式处理

相比生成代码，scripts 能节省 tokens 并提升可靠性。

## 何时拆分文件

在以下情况拆成单独文件：

- SKILL.md 超过 100 行
- 内容有不同 domains（finance vs sales schemas）
- Advanced features 很少需要

## Review Checklist

起草后确认：

- [ ] Description 包含 triggers（“用于……”）
- [ ] SKILL.md 少于 100 行
- [ ] 没有 time-sensitive info
- [ ] 术语一致
- [ ] 包含具体 examples
- [ ] References 只深一层

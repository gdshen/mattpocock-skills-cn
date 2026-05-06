---
name: prototype
description: 在正式投入前构建一次性 prototype 来逼出设计问题。分两条路线：用于 state/business-logic 问题的可运行终端应用，或同一路由上可切换的多个差异很大的 UI 变体。用于用户想 prototype、校验 data model 或 state machine、mock UI、探索设计选项，或说“prototype this”、“let me play with it”、“try a few designs”时。
---

# 原型（Prototype）

Prototype 是**用于回答一个问题的一次性代码**。问题决定形状。

## 选择分支

从用户 prompt、周围代码，或在用户在线时询问，识别正在回答哪个问题：

- **“这套 logic / state model 感觉对吗？”** → [LOGIC.md](LOGIC.md)。构建一个很小的交互式终端应用，把 state machine 推过纸面上难以推理的场景。
- **“这应该长什么样？”** → [UI.md](UI.md)。在单一路由上生成多个差异很大的 UI 变体，通过 URL search param 和底部 floating bar 切换。

两个分支会产出非常不同的 artifacts；选错会浪费整个 prototype。如果问题真的含糊且联系不上用户，就默认选择更匹配周围代码的分支（backend module → logic；page 或 component → UI），并在 prototype 顶部写明假设。

## 两个分支都适用的规则

1. **从第一天起就是一次性的，并清楚标记。** 把 prototype 代码放在接近真实使用位置的地方（放在它要验证的 module 或 page 旁边），这样上下文明显；但命名要让随手路过的读者看出这是 prototype，不是 production。一次性 UI 路由要遵守项目已有 routing convention；不要发明新的顶层结构。
2. **一个命令即可运行。** 使用项目已有 task runner 支持的方式：`pnpm <name>`、`python <path>`、`bun <path>` 等。用户必须能不费脑地启动它。
3. **默认无持久化。** State 存在内存里。Persistence 是 prototype 要*检查*的东西，不该成为依赖。如果问题明确涉及数据库，就打 scratch DB 或一个名称清楚写着 “PROTOTYPE — wipe me” 的本地文件。
4. **跳过打磨。** 不写测试，不写超出“让 prototype 可运行”所需的错误处理，不抽象。目标是快速学到东西，然后删除。
5. **暴露 state。** 每次 action（logic）或每次 variant switch（UI）之后，打印或渲染完整相关 state，让用户看到发生了什么变化。
6. **完成后删除或吸收。** 当 prototype 回答了问题，要么删除它，要么把验证后的决策折进真实代码；不要让它在 repo 里腐烂。

## 完成后

Prototype 唯一值得保留的是*答案*。把它和它回答的问题一起记录到持久位置（commit message、ADR、issue，或 prototype 旁边的 `NOTES.md`）。如果用户在线，记录过程就是一次快速对话；如果不在线，留下 placeholder，让他们（或下一轮的你）在删除 prototype 前填入结论。

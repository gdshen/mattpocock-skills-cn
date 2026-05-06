# 逻辑原型（Logic Prototype）

一个很小的交互式终端应用，让用户能手动驱动 state model。当问题涉及 **business logic、state transitions 或 data shape** 时使用：这类东西在纸面上看起来合理，但一旦推过真实场景才会感觉不对。

## 何时这是正确形状

- “我不确定这个 state machine 是否能处理先 X 后 Y 的边界情况。”
- “这个 data model 真的能表达这种情况吗……”
- “我想在正式写之前感受一下 API 应该长什么样。”
- 任何用户想**按按钮并观察 state 变化**的情况。

如果问题是“这应该长什么样”，那就是错误分支。使用 [UI.md](UI.md)。

## 流程

### 1. 说明问题

写代码前，写下你正在 prototype 哪个 state model、回答哪个问题。放在 prototype README 里，或文件顶部注释里，一段即可。回答错误问题的 logic prototype 纯属浪费；把问题显式写出来，方便之后核对，不管用户现在是否正在看，还是之后 AFK 回来。

### 2. 选择语言

使用宿主项目正在使用的语言。如果项目没有明显 runtime（例如 docs repo），就询问。

匹配项目已有 tooling 约定；不要只为了 prototype 添加新的 package manager 或 runtime。

### 3. 把 logic 隔离到可移植 module 中

把真正的 logic，也就是回答问题的部分，放到一个小而纯的 interface 后面，之后可以把它拿出来放进真实代码库。外面的 TUI 是一次性的；logic module 不该是。

正确形状取决于问题：

- **纯 reducer**：`(state, action) => state`。适合 actions 是离散 events 且 state 是单个值的场景。
- **State machine**：显式 states 和 transitions。适合“当前到底哪些 actions 合法”也是问题一部分的场景。
- **围绕普通 data type 的一小组纯函数**。适合没有隐式 current state、只有 transformations 的场景。
- **有清晰 method surface 的 class 或 module**，适合 logic 确实拥有持续内部 state 的场景。

选择最匹配问题的形状，*不是*最容易接到 TUI 的形状。保持纯净：无 I/O、无 terminal code、不要用 `console.log` 做控制流。TUI 导入它并调用它；不要反向流动。

这会让 prototype 在自己生命周期之后仍有价值。当问题被回答后，验证过的 reducer / machine / function set 可以提升到真实 module 中；TUI shell 则删除。

### 4. 构建能暴露 state 的最小 TUI

把它构建成**轻量 TUI**：每个 tick 清屏（`console.clear()` / `print("\033[2J\033[H")` / 等价方式），然后重新渲染整个 frame。用户应该始终看到一个稳定视图，而不是不断增长的 scrollback。

每个 frame 按顺序包含两部分：

1. **Current state**，美观打印且 diff-friendly（每行一个字段，或格式化 JSON）。字段名或 section headers 用 **bold**，不那么重要的上下文（timestamps、IDs、derived values）用 **dim**。原生 ANSI escape codes 就可以：`\x1b[1m` bold、`\x1b[2m` dim、`\x1b[0m` reset。除非项目已有 styling library，否则不用引入。
2. **Keyboard shortcuts**，列在底部：`[a] add user  [d] delete user  [t] tick clock  [q] quit`。可以 key 加粗、description 变暗，或反过来；以清晰为准。

行为：

1. **初始化 state**：一个内存中的 object/struct。启动时渲染第一帧。
2. **一次读取一个 keystroke（或一行）**，dispatch 到会修改 state 的 handler。
3. 每次 action 后**重新渲染**完整 frame；不要 append，要 replace。
4. **循环直到 quit。**

整个 frame 应该能放进一屏。

### 5. 让它一个命令可运行

向项目已有 task runner 添加一个 script（`package.json` scripts、`Makefile`、`justfile`、`pyproject.toml`）。用户应该运行 `pnpm run <prototype-name>` 或等价命令，永远不需要记路径。

如果宿主项目没有 task runner，就把命令放在 prototype README 顶部。

### 6. 交给用户

给用户运行命令。他们会自己驱动它；有意思的时刻通常是他们说“等等，这不应该可能”或“嗯，我以为 X 会不一样”。那些就是_想法_里的 bug，而这正是目的。如果他们想添加新的 actions，就添加。Prototypes 会演化。

### 7. 捕获答案

当 prototype 完成任务后，唯一值得保留的是问题的答案。如果用户在线，问它教会了他们什么。如果不在线，就在 prototype 旁留下 `NOTES.md`，这样删除 prototype 前可以填入答案（如果你看过会话，也可以由你填）。

## 反模式

- **不要添加测试。** 需要测试的 prototype 已经不再是 prototype。
- **不要接真实数据库。** 除非问题专门关于 persistence，否则用 in-memory store。
- **不要泛化。** 不要想“如果之后要支持 X 怎么办”。Prototype 只回答一个问题。
- **不要把 logic 和 TUI 搅在一起。** 如果 reducer / state machine 引用了 `console.log`、prompts 或 terminal escape codes，它就不再可移植。让 TUI 成为纯 module 外的一层薄 shell。
- **不要把 TUI shell 发到 production。** shell 是为从终端手动驱动优化的。它背后的 logic module 才是值得保留的部分。

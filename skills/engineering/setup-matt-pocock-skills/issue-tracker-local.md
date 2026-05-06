# Issue tracker：Local Markdown

此 repo 的 issues 和 PRDs 作为 markdown 文件存在 `.scratch/` 中。

## 约定

- 每个 feature 一个目录：`.scratch/<feature-slug>/`
- PRD 是 `.scratch/<feature-slug>/PRD.md`
- Implementation issues 是 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，从 `01` 开始编号
- Triage state 记录为每个 issue 文件顶部附近的 `Status:` 行（role strings 见 `triage-labels.md`）
- Comments 和 conversation history 追加到文件底部的 `## Comments` 标题下

## 当 skill 说“publish to the issue tracker”时

在 `.scratch/<feature-slug>/` 下创建新文件（需要时创建目录）。

## 当 skill 说“fetch the relevant ticket”时

读取引用路径处的文件。用户通常会直接传路径或 issue number。

# Issue tracker：GitHub

此 repo 的 issues 和 PRDs 存在 GitHub issues 中。所有操作都使用 `gh` CLI。

## 约定

- **创建 issue**：`gh issue create --title "..." --body "..."`。多行 body 使用 heredoc。
- **读取 issue**：`gh issue view <number> --comments`，用 `jq` 过滤 comments，同时获取 labels。
- **列出 issues**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，配合合适的 `--label` 和 `--state` filters。
- **评论 issue**：`gh issue comment <number> --body "..."`
- **应用 / 移除 labels**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **关闭**：`gh issue close <number> --comment "..."`

从 `git remote -v` 推断 repo；`gh` 在 clone 内运行时会自动完成。

## 当 skill 说“publish to the issue tracker”时

创建 GitHub issue。

## 当 skill 说“fetch the relevant ticket”时

运行 `gh issue view <number> --comments`。

# Issue tracker：GitLab

此 repo 的 issues 和 PRDs 存在 GitLab issues 中。所有操作都使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 约定

- **创建 issue**：`glab issue create --title "..." --description "..."`。多行 description 使用 heredoc。传 `--description -` 会打开编辑器。
- **读取 issue**：`glab issue view <number> --comments`。使用 `-F json` 获取机器可读输出。
- **列出 issues**：`glab issue list --state opened -F json`，配合合适的 `--label` filters。注意 GitLab 的 state 值是 `opened`，不是 `open`。
- **评论 issue**：`glab issue note <number> --message "..."`。GitLab 把 comments 称为 “notes”。
- **应用 / 移除 labels**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多个 labels 可用逗号分隔，也可以重复 flag。
- **关闭**：`glab issue close <number>`。`glab issue close` 不接受 closing comment，所以先用 `glab issue note <number> --message "..."` 发表解释，再关闭。
- **Merge requests**：GitLab 把 PRs 称为 “merge requests”。使用 `glab mr create`、`glab mr view`、`glab mr note` 等；形状和 `gh pr ...` 相同，只是用 `mr` 替代 `pr`，用 `note`/`--message` 替代 `comment`/`--body`。

从 `git remote -v` 推断 repo；`glab` 在 clone 内运行时会自动完成。

## 当 skill 说“publish to the issue tracker”时

创建 GitLab issue。

## 当 skill 说“fetch the relevant ticket”时

运行 `glab issue view <number> --comments`。

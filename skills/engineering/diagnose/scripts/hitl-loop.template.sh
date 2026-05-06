#!/usr/bin/env bash
# 人在环路中的复现循环。
# 复制此文件，编辑下面的步骤，然后运行。
# agent 运行脚本；用户按终端里的提示操作。
#
# 用法：
#   bash hitl-loop.template.sh
#
# 两个 helper：
#   step "<instruction>"          → 显示指令，等待 Enter
#   capture VAR "<question>"      → 显示问题，把回答读入 VAR
#
# 结束时，捕获值会以 KEY=VALUE 打印，方便 agent 解析。

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter when done] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 在下面编辑 ---------------------------------------------------------

step "打开 http://localhost:3000 上的应用并登录。"

capture ERRORED "点击 'Export' 按钮。是否抛错？(y/n)"

capture ERROR_MSG "粘贴错误信息（或输入 'none'）："

# --- 在上面编辑 ---------------------------------------------------------

printf '\n--- 已捕获 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"

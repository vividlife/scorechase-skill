#!/bin/bash
# Scorechase CLI 执行脚本
# 用法：./scripts/scorechase-exec.sh <command> [args...]
# 可选环境变量：SCORECHASE_CLI_DIR 指向 scorechase 项目下的 cli 目录

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
# 优先使用环境变量，否则假定与 scorechase 主仓库同目录（repo_root/../scorechase/cli）
CLI_DIR="${SCORECHASE_CLI_DIR:-$(dirname "$REPO_ROOT")/scorechase/cli}"

if [ ! -d "$CLI_DIR" ] || [ ! -f "$CLI_DIR/dist/index.js" ]; then
    echo "错误：未找到 Scorechase CLI（$CLI_DIR）"
    echo "请设置 SCORECHASE_CLI_DIR 指向 scorechase 项目下的 cli 目录，或在 scorechase 仓库旁克隆本技能仓库"
    exit 1
fi

cd "$CLI_DIR"

# 检查 .env 文件
if [ ! -f ".env" ]; then
    echo "错误：.env 文件不存在"
    echo "请运行：cp .env.example .env 并配置 DATABASE_URL"
    exit 1
fi

# 执行 CLI 命令
node dist/index.js "$@"

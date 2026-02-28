# Scorechase Skill

Claude Code 技能：中式台球追分记录。用于在对话中通过 AI 记录比赛、查询统计与历史。

## 内容

- **SKILL.md** - 技能说明与工作流程（记录大金/小金/黄金 9/黑金/普胜/犯规、查询统计与比赛记录）
- **scripts/scorechase-exec.sh** - 调用 [Scorechase](https://github.com/vividlife/scorechase) 项目下 CLI 的脚本

## 安装（Claude）

将本仓库克隆到 Claude 技能目录：

```bash
git clone https://github.com/vividlife/scorechase-skill.git ~/.claude/skills/scorechase
```

或创建符号链接（若已克隆到其他位置）：

```bash
ln -s /path/to/scorechase-skill ~/.claude/skills/scorechase
```

## 依赖

- 已克隆并构建 [scorechase](https://github.com/vividlife/scorechase) 主项目
- CLI 目录：默认取 `scorechase-skill 父目录/scorechase/cli`；或设置环境变量：

```bash
export SCORECHASE_CLI_DIR=/path/to/scorechase/cli
```

在 `scorechase` 主仓库旁克隆本仓库时，无需设置：

```
Work/
├── scorechase/       # 主项目
│   └── cli/
└── scorechase-skill/ # 本技能仓库
```

## 使用

在 Claude 对话中触发该技能后，按 SKILL.md 中的命令格式操作即可（如记录一局、查统计、查比赛、删记录等）。执行时会调用 `scripts/scorechase-exec.sh` 转发到 CLI。

## 许可

与主项目保持一致。

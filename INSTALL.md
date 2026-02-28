# 安装 Scorechase Skill

## 安装到 Claude Code

将本仓库克隆到 Claude 技能目录：

```bash
git clone https://github.com/vividlife/scorechase-skill.git ~/.claude/skills/scorechase
```

或若已克隆到其他位置，创建符号链接：

```bash
ln -s /path/to/scorechase-skill ~/.claude/skills/scorechase
```

## 依赖

- 已克隆并构建 [scorechase](https://github.com/vividlife/scorechase) 主项目（含 `cli`）
- 可选：设置 `SCORECHASE_CLI_DIR` 指向主项目下的 `cli` 目录；若将本仓库与主项目放在同一父目录下则无需设置

## 验证安装

在 Claude Code 中输入 `/help` 查看是否包含 `scorechase` skill。

## 使用方式

### 方式 1：Skill 命令（在对话中）

```
/scorechase record-nlp "司庆大金"
/scorechase stats
```

### 方式 2：本仓库脚本转发

```bash
cd /path/to/scorechase-skill
./scripts/scorechase-exec.sh record-nlp "司庆大金"
./scripts/scorechase-exec.sh stats
```

### 方式 3：直接使用主项目 CLI

```bash
cd /path/to/scorechase/cli
./scorechase record-nlp "司庆大金"
./scorechase stats
```

## 配置数据库

首次使用前，在主项目 `cli` 目录配置数据库连接：

```bash
cd /path/to/scorechase/cli
cp .env.example .env
# 编辑 .env，填入 DATABASE_URL
```

## 常见问题

**Q: Skill 没有触发？**  
A: 确保描述中包含触发关键词，如「记录比赛」「大金」「统计」等。

**Q: 命令执行失败？**  
A: 检查 `cli/.env` 是否正确配置 `DATABASE_URL`，以及 `cli` 是否已 `npm run build`。

**Q: 如何查看可用的事件类型？**  
A: 运行 `./scorechase --help` 或查看 `SKILL.md` 中的说明。

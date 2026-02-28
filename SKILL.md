---
name: scorechase
description: 中式台球追分记录技能，用于记录和管理四名玩家之间的台球比赛得分。支持自然语言输入（如"司庆大金"）、快捷命令（dajin/xiaojin/heijin 等）、查询统计数据和比赛历史。触发场景包括：记录比赛得分、查询玩家排名、查看比赛历史、删除错误记录。
---

# Scorechase - 中式台球追分记录技能

## 快速开始

以下命令需在 **scorechase 项目的 cli 目录** 下执行（`cd <scorechase>/cli`），或从本技能仓库用 `./scripts/scorechase-exec.sh <子命令> ...` 转发。

### 方式 1：自然语言命令（最直观，推荐）

```bash
./scorechase record-nlp "司庆大金"
./scorechase record-nlp "小孙小金"
./scorechase record-nlp "泰坦黄金 9"
./scorechase record-nlp "荣升黑金"
./scorechase record-nlp "司庆普胜"
./scorechase record-nlp "小孙普胜 1 号犯规"
```

### 方式 2：快捷命令（简洁）

```bash
./scorechase dajin             # 大金（自动 1 号位）
./scorechase xiaojin -s 2      # 2 号位小金
./scorechase huangjin9         # 黄金 9（自动 1 号位）
./scorechase heijin -s 3       # 3 号位黑金
./scorechase pusheng -s 4      # 4 号位普胜
```

### 方式 3：完整参数控制

```bash
./scorechase record -e <事件类型> -s <击球座次> [--foul <犯规座次>]
```

## 工作流程

### 1. 记录比赛得分

**三种方式：**

| 方式 | 命令 | 适用场景 |
|------|------|----------|
| 自然语言 | `record-nlp "司庆大金"` | AI Agent 操控，最直观 |
| 快捷命令 | `dajin` / `xiaojin -s 2` | 快速记录 |
| 完整参数 | `record -e dajin -s 1` | 精确控制 |

**事件类型说明：**
- `dajin` - 大金（+30/-10/-10/-10）→ 自动选择 1 号位
- `xiaojin` - 小金（+7/-7/0/0）
- `huangjin9` - 黄金 9（+12/-4/-4/-4）→ 自动选择 1 号位
- `heijin` - 黑金（-12/+4/+4/+4）
- `pusheng` - 普胜（+4/-4/0/0）

**自然语言识别：**
- 玩家名称 + 事件：`"司庆大金"`、`"小孙小金"`、`"司庆普胜"`（只需指定赢家，输家自动为上家）
- 座次 + 事件：`"1 号黄金 9"`、`"2 号黑金"`
- 带犯规：`"小孙普胜 1 号犯规"`、`"泰坦黑金 2 号 3 号犯规"`

**示例：**
```bash
# 自然语言方式
./scorechase record-nlp "司庆大金"
./scorechase record-nlp "小孙小金"
./scorechase record-nlp "泰坦黄金 9"
./scorechase record-nlp "荣升黑金"
./scorechase record-nlp "司庆普胜"

# 快捷命令
./scorechase dajin
./scorechase xiaojin -s 2
./scorechase huangjin9
./scorechase heijin -s 3
./scorechase pusheng -s 4

# 带犯规
./scorechase record-nlp "小孙普胜 1 号犯规"
./scorechase record -e pusheng -s 2 --foul 1
```

### 2. 查询统计数据

```bash
./scorechase stats
```

输出包含：排名、姓名、总分、胜/败场数、胜率、大金/小金/黄金 9/黑金/犯规次数。

### 3. 查询比赛记录

```bash
./scorechase matches          # 所有比赛
./scorechase matches -l 10    # 最近 10 场
./scorechase match <matchId>  # 单场详情
```

### 4. 管理玩家

```bash
./scorechase players           # 玩家列表
./scorechase player "司庆"     # 查找玩家
./scorechase add-player "新玩家"  # 添加玩家
```

### 5. 删除比赛记录

```bash
./scorechase delete-match <matchId>
```

## 座次关系

座次按 1→2→3→4→1 循环：

| 座次 | 上家 | 下家 | 对家 |
|------|------|------|------|
| 1 号 | 4 号 | 2 号 | 3 号 |
| 2 号 | 1 号 | 3 号 | 4 号 |
| 3 号 | 2 号 | 4 号 | 1 号 |
| 4 号 | 3 号 | 1 号 | 2 号 |

## 计分规则详解

| 事件 | 击球者 | 上家 | 下家 | 对家 | 零和验证 |
|------|--------|------|------|------|---------|
| 🏆 大金 | +30 | -10 | -10 | -10 | 30-30=0 ✅ |
| 🥇 小金 | +7 | -7 | 0 | 0 | 7-7=0 ✅ |
| ✨ 黄金 9 | +12 | -4 | -4 | -4 | 12-12=0 ✅ |
| 💀 黑金 | -12 | +4 | +4 | +4 | -12+12=0 ✅ |
| ✓ 普胜 | +4 | -4 | 0 | 0 | 4-4=0 ✅ |
| ⚠️ 犯规 | -1 | +1 | 0 | 0 | -1+1=0 ✅ |

## 注意事项

1. **大金和黄金 9 自动选择 1 号位** - 这两种事件一定是开球打出的
2. **零和验证** - 每局比赛所有玩家分数变化总和必须为 0
3. **犯规处理** - 每次犯规 -1 分，罚分对象（默认上家）+1 分
4. **多次犯规** - 可使用多个 `--foul` 参数记录多人犯规

## 相关资源

- 主项目与 CLI：[scorechase](https://github.com/vividlife/scorechase)
- CLI 详细文档：主项目下 `cli/README.md`、`cli/AI_AGENT.md`

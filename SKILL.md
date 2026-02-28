---
name: scorechase
description: 中式台球追分记录技能，用于记录和管理四名玩家之间的台球比赛得分。支持记录大金/小金/黄金 9/黑金/普胜/犯规等事件，查询统计数据和比赛历史。触发场景包括：记录比赛得分、查询玩家排名、查看比赛历史、删除错误记录。
---

# Scorechase - 中式台球追分记录技能

## 快速开始

记录一局比赛：
```bash
# 在 scorechase 主项目旁克隆本技能仓库时，从技能仓库执行：
./scripts/scorechase-exec.sh record -e <事件类型> -s <击球座次> [--foul <犯规座次>]
# 或进入 scorechase/cli 后：./scorechase record -e <事件> -s <座次> ...
```

## 工作流程

### 1. 记录比赛得分

**步骤：**
1. 确定事件类型（dajin|xiaojin|huangjin9|heijin|pusheng）
2. 确定击球座次（1-4 号位）
3. 可选：记录犯规座次
4. 执行命令并验证结果

**事件类型说明：**
- `dajin` - 大金（+30/-10/-10/-10）→ 自动选择 1 号位
- `xiaojin` - 小金（+7/-7/0/0）
- `huangjin9` - 黄金 9（+12/-4/-4/-4）→ 自动选择 1 号位
- `heijin` - 黑金（-12/+4/+4/+4）
- `pusheng` - 普胜（+4/-4/0/0）

**示例：**
```bash
# 大金（1 号位自动选择）
./scripts/scorechase-exec.sh record -e dajin -s 1

# 小金（3 号位击球）
./scripts/scorechase-exec.sh record -e xiaojin -s 3

# 普胜 + 犯规（2 号位普胜，1 号位犯规）
./scripts/scorechase-exec.sh record -e pusheng -s 2 --foul 1

# 多人犯规
./scripts/scorechase-exec.sh record -e pusheng -s 3 --foul 1 --foul 2
```

### 2. 查询统计数据

```bash
./scripts/scorechase-exec.sh stats
```

输出包含：排名、姓名、总分、胜/败场数、胜率、大金/小金/黄金 9/黑金/犯规次数。

### 3. 查询比赛记录

```bash
./scripts/scorechase-exec.sh matches          # 所有比赛
./scripts/scorechase-exec.sh matches -l 10    # 最近 10 场
./scripts/scorechase-exec.sh match <matchId>  # 单场详情
```

### 4. 管理玩家

```bash
./scripts/scorechase-exec.sh players           # 玩家列表
./scripts/scorechase-exec.sh player "司庆"     # 查找玩家
./scripts/scorechase-exec.sh add-player "新玩家"  # 添加玩家
```

### 5. 删除比赛记录

```bash
./scripts/scorechase-exec.sh delete-match <matchId>
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

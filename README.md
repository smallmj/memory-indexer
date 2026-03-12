# Memory Indexer 🧠

> 短期记忆关键词索引工具，为 AI Agent 提供长期记忆能力

**版本**: v1.0.4 | [English](./README_EN.md) | 中文

## 简介

Memory Indexer 是一个帮助 AI Agent 持久化记忆的工具。它能够：

- ✅ 自动提取记忆中的关键词
- ✅ 建立关键词 → 记忆文件的快速索引
- ✅ 支持多关键词精确搜索（AND/OR 模式）
- ✅ 自动发现关联记忆
- ✅ 按时间线展示记忆
- ✅ 标记和查看重要记忆
- ✅ 增量同步外部记忆目录

## 为什么需要它？

AI Agent 在每次会话结束后会丢失上下文。传统方案只能保存原始文本，检索困难。

**Memory Indexer 通过关键词索引，让记忆可搜索、可关联、可追溯。**

## 功能特性

### 1. 自动关键词提取
使用 jieba 中文分词，自动从记忆内容中提取关键词。

### 2. 多模式搜索
- **OR 模式**：任一关键词匹配即返回
- **AND 模式**：所有关键词都匹配才返回

### 3. 关联发现
自动发现哪些记忆经常一起出现，生成关联推荐。

### 4. 时间线视图
按时间顺序展示所有记忆，方便回顾。

### 5. 主动提醒
根据当前对话关键词，自动提示相关旧记忆。

### 6. 重要记忆标记
手动标记重要记忆，优先保留和展示。

### 7. 增量同步
自动扫描外部 memory/ 目录，只索引新增或修改的文件。

### 8. 失效清理
自动清理已删除记忆的索引条目。

### 9. 会话备份与精简
自动备份会话内容到索引，精简原文件避免无限膨胀（详见下方）。

## 为什么要精简 Session Memory？

OpenClaw 会话文件（.jsonl）会随着使用不断增长：

- 每次对话都保存完整的 message history
- 长期使用后，单个会话文件可达数 MB
- 加载时会占用大量内存，影响响应速度

**解决方案：**

1. **备份有价值的内容** → 提取用户消息，添加到 memory-indexer
2. **精简原文件** → 只保留会话元数据，裁剪对话内容到 ~10KB
3. **增量处理** → 每次只处理最近的 3 个会话，不影响性能

**使用方式：**

```bash
# 手动运行
cd ~/.openclaw/workspace
uv run python skills/memory-indexer/session_backup.py
```

**效果：**
- 原会话文件：634KB → 10KB（减少 98%）
- 用户消息已备份到 indexer，可通过搜索找回
- 下次加载更快 🚀

## 安装

### 方式一：运行安装脚本（推荐）

```bash
# 克隆项目
git clone https://github.com/smallmj/memory-indexer.git
cd memory-indexer

# 运行安装脚本
chmod +x install.sh
./install.sh
```

安装脚本会：
- ✅ 检查并安装依赖（jieba）
- ✅ 创建到 OpenClaw skills 目录的软链接
- ✅ 自动配置 AGENTS.md
- ✅ 可选：配置 Cron 自动同步

### 方式二：手动安装

```bash
# 1. 克隆项目
git clone https://github.com/smallmj/memory-indexer.git
cd memory-indexer

# 2. 安装依赖
pip install -r requirements.txt

# 3. 创建软链接到 OpenClaw skills 目录
ln -sf "$(pwd)" ~/.openclaw/workspace/skills/memory-indexer

# 4. 首次运行
python3 memory-indexer.py status
```

### 自动配置（安装脚本）

运行 `install.sh` 会自动完成以下配置：

| 文件 | 配置内容 | 作用 |
|------|---------|------|
| `AGENTS.md` | 检索记忆的规则 | 新会话时自动搜索相关记忆 |
| `MEMORY.md` | 强制规则：保存/新会话时调用 indexer | 自动建立索引、自动检索 |
| `HEARTBEAT.md` | 定期同步 + 会话备份 | 自动备份和精简 session memory |

**手动配置（不运行 install.sh）：**

如果你不想运行安装脚本，需要手动在 OpenClaw workspace 中添加以下配置：

1. **AGENTS.md** - 启动流程检索记忆：
```markdown
### 🧠 Memory Indexer
当需要回忆某事时，必须按以下顺序搜索：
1. 先用 memory-indexer 搜索
2. 再用 memory_search 搜索
```

2. **MEMORY.md** - 强制规则：
```markdown
## 强制规则
2. 保存记忆时 - 必须同时调用 memory-indexer 建立索引
3. 新会话开始时 - 自动调用 memory-indexer 搜索相关记忆
```

3. **HEARTBEAT.md** - 定期任务：
```markdown
### 记忆索引同步
- 命令：cd ~/.openclaw/workspace && uv run python skills/memory-indexer/memory-indexer.py sync

### 会话备份与精简
- 命令：cd ~/.openclaw/workspace && uv run python skills/memory-indexer/session_backup.py
- 频率：每次 heartbeat
```

---

### 更新

```bash
# 进入项目目录
cd memory-indexer

# 运行更新脚本
chmod +x update.sh
./update.sh
```

更新脚本会：
- ✅ 自动拉取最新代码
- ✅ 备份数据
- ✅ 检查并安装依赖
- ✅ 重新同步索引

## 快速开始

### 基本用法

```bash
# 添加一条记忆
python memory-indexer.py add "今天学习了 Python 编程"

# 搜索记忆（OR 模式）
python memory-indexer.py search "Python"

# 搜索记忆（AND 模式）
python memory-indexer.py search "Python 编程" --and

# 查看所有记忆
python memory-indexer.py list

# 查看记忆摘要
python memory-indexer.py summary
```

### 与 OpenClaw 集成

```bash
# 在 OpenClaw workspace 中使用
cd ~/.openclaw/workspace
uv pip install jieba
uv run python skills/memory-indexer/memory-indexer.py add "记忆内容"

# 会话备份与精简（可选，每次 heartbeat 自动运行）
uv run python skills/memory-indexer/session_backup.py
```

### AGENTS.md 自动加载配置

在 OpenClaw 的 `AGENTS.md` 中添加以下规则，确保每次新会话都能检索记忆：

```markdown
### 🧠 Memory Indexer (长期记忆检索)

当需要回忆某事时，必须按以下顺序搜索：

1. **先用 memory-indexer 搜索**（检索关键词索引）
   ```bash
   cd ~/.openclaw/workspace && uv run python skills/memory-indexer/memory-indexer.py search "关键词"
   ```

2. **再用 memory_search 搜索**（检索原始记忆文件）
   ```bash
   memory_search query
   ```

这样可以确保：即使短期记忆丢失，也能通过索引找回之前的记忆内容。
```

## 命令参考

| 命令 | 功能 | 示例 |
|------|------|------|
| `add` | 添加记忆 | `add "今天学习了 Python"` |
| `search` | 搜索记忆 | `search "Python"` |
| `search --and` | AND 搜索 | `search "Python AI" --and` |
| `list` | 列出所有记忆 | `list` |
| `sync` | 同步外部目录 | `sync` |
| `cleanup` | 清理失效索引 | `cleanup` |
| `related` | 关联发现 | `related` |
| `timeline` | 时间线视图 | `timeline` |
| `recall` | 主动提醒 | `recall "Python"` |
| `summary` | 记忆摘要 | `summary` |
| `star` | 标记重要 | `star 20260312.md` |
| `stars` | 查看重要记忆 | `stars` |
| `status` | 查看状态 | `status` |

## 配置

脚本会自动在以下目录创建数据文件：

```
~/.memory-indexer/
├── index.json          # 关键词索引
├── sync-state.json    # 同步状态
└── stars.json         # 重要记忆标记
```

会话备份脚本会在以下目录存储备份：

```
~/.openclaw/workspace/memory-index/session-backups/
```

可通过修改代码中的 `WORKSPACE` 变量自定义存储路径。

## 效果演示

### 搜索结果
```
$ python memory-indexer.py search "小红书 日记"

找到 2 条相关记忆 (模式: OR):

关键词: 小红书, 日记

📄 20260312_173114.md - 20260312_173114 🔥🔥
   今天测试了语音识别功能，还讨论了小红书日记的规划
```

### 记忆摘要
```
$ python memory-indexer.py summary

=== 记忆摘要 ===

📊 总记忆数: 14
📊 关键词数: 49

📅 最近活动:
   2026-03-12: 34 条
   2026-03-11: 28 条

🔥 热门关键词:
   语音识别: 5 条
   小红书: 3 条
   日记: 2 条
```

### 关联发现
```
$ python memory-indexer.py related

=== 关联记忆发现 ===

📎 语音识别测试.md ↔ openai-whisper安装.md
   共同关键词: 语音识别, whisper, 测试

📎 小红书日记.md ↔ 内容规划.md
   共同关键词: 小红书, 日记, 规划
```

---

技术栈：Python 3.8+、jieba、argparse、json

贡献：欢迎提交 Issue 和 Pull Request！
1. Fork 本仓库
2. 创建特性分支 (git checkout -b feature/xxx)
3. 提交更改 (git commit -m 'Add xxx')
4. 推送分支 (git push origin feature/xxx)
5. 创建 Pull Request

开源许可证：本项目使用 MIT 许可证。

作者：@smallmj | hexiealan007@gmail.com

---

如果这个项目对你有帮助，请 ⭐ Star 支持！

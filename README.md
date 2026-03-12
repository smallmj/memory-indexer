# Memory Indexer 🧠

> 短期记忆关键词索引工具，为 AI Agent 提供长期记忆能力

[English](./README_EN.md) | 中文

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

## 安装

### 前提条件

- Python 3.8+
- jieba（中文分词库）

### 步骤

```bash
# 1. 克隆项目
git clone https://github.com/your-username/memory-indexer.git
cd memory-indexer

# 2. 创建虚拟环境（推荐）
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# 3. 安装依赖
pip install -r requirements.txt

# 4. 运行测试
python memory-indexer.py status
```

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
```

### 心跳自动同步

在 `HEARTBEAT.md` 中添加：

```markdown
### 记忆索引同步
- 命令：`cd ~/.openclaw/workspace && uv run python skills/memory-indexer/memory-indexer.py sync`
- 频率：每次心跳
```

### Cron 定时备份

```bash
crontab -e
# 每天早上 6 点自动同步
0 6 * * * cd /home/user/.openclaw/workspace && python skills/memory-indexer/memory-indexer.py sync
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

## 技术栈

- **Python 3.8+** - 运行环境
- **jieba** - 中文分词
- **argparse** - 命令行解析
- **json** - 数据存储

## 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/xxx`)
3. 提交更改 (`git commit -m 'Add xxx'`)
4. 推送分支 (`git push origin feature/xxx`)
5. 创建 Pull Request

## 开源许可证

本项目使用 [MIT](./LICENSE) 许可证。

## 作者

- Author: Your Name
- Email: your@email.com
- GitHub: [@your-username](https://github.com/your-username)

---

如果这个项目对你有帮助，请 ⭐ Star 支持！

# Memory Indexer 🧠

> 短期记忆关键词索引工具，为 AI Agent 提供长期记忆能力

版本: v1.0.4 | English

## 简介

Memory Indexer 帮助 AI Agent 持久化记忆：

- 自动提取记忆中的关键词
- 建立关键词 → 记忆文件的快速索引
- 支持多关键词精确搜索（AND/OR 模式）
- 自动发现关联记忆
- 按时间线展示记忆
- 标记和查看重要记忆
- 增量同步外部记忆目录
- 会话备份与精简（避免 session memory 无限膨胀）

## 为什么需要它？

AI Agent 每次会话结束后会丢失上下文。传统方案只能保存原始文本，检索困难。

Memory Indexer 通过关键词索引，让记忆可搜索、可关联、可追溯。

## 功能特性

1. 自动关键词提取：使用 jieba 中文分词
2. 多模式搜索：OR（任一匹配）/ AND（全部匹配）
3. 关联发现：自动发现经常一起出现的记忆
4. 时间线视图：按时间顺序展示记忆
5. 主动提醒：根据当前关键词提示相关旧记忆
6. 重要记忆标记：手动标记优先保留
7. 增量同步：只索引新增或修改的文件
8. 失效清理：自动清理已删除记忆的索引
9. 会话备份与精简：备份用户消息到索引，精简 session 文件到 ~10KB

## 安装

### 方式一：运行安装脚本（推荐）

git clone https://github.com/smallmj/memory-indexer.git
cd memory-indexer
chmod +x install.sh
./install.sh

安装脚本会自动：
- 检查并安装依赖（jieba）
- 创建到 OpenClaw skills 目录的软链接
- 配置 AGENTS.md、MEMORY.md、HEARTBEAT.md

### 方式二：手动安装

git clone https://github.com/smallmj/memory-indexer.git
cd memory-indexer
pip install -r requirements.txt
ln -sf "$(pwd)" ~/.openclaw/workspace/skills/memory-indexer
python3 memory-indexer.py status

### 手动配置（不运行 install.sh）

在 OpenClaw workspace 中添加以下配置：

1. AGENTS.md - 检索记忆规则
2. MEMORY.md - 强制规则：保存/新会话时调用 indexer
3. HEARTBEAT.md - 定期同步 + 会话备份

详见上方自动配置表格

## 快速开始

# 添加记忆
python memory-indexer.py add "今天学习了 Python"

# 搜索（OR 模式）
python memory-indexer.py search "Python"

# 搜索（AND 模式）
python memory-indexer.py search "Python 编程" --and

# 列出所有记忆
python memory-indexer.py list

# 记忆摘要
python memory-indexer.py summary

## 与 OpenClaw 集成

cd ~/.openclaw/workspace
uv pip install jieba
uv run python skills/memory-indexer/memory-indexer.py add "记忆内容"

# 会话备份与精简（每次 heartbeat 自动运行）
uv run python skills/memory-indexer/session_backup.py

## 命令参考

add              添加记忆              add "今天学习了 Python"
search           搜索记忆              search "Python"
search --and     AND 搜索              search "Python AI" --and
list             列出所有记忆          list
sync             同步外部目录          sync
cleanup          清理失效索引          cleanup
related          关联发现              related
timeline         时间线视图            timeline
recall           主动提醒              recall "Python"
summary          记忆摘要              summary
star             标记重要              star 20260312.md
stars            查看重要记忆          stars
status           查看状态              status

## 配置

数据目录：~/.memory-indexer/
- index.json       关键词索引
- sync-state.json 同步状态
- stars.json      重要记忆标记

备份目录：~/.openclaw/workspace/memory-index/session-backups/

可通过修改代码中的 WORKSPACE 变量自定义存储路径。

## 更新

cd memory-indexer
chmod +x update.sh
./update.sh

更新脚本会自动拉取代码、备份数据、检查依赖、重新同步索引。

---

技术栈：Python 3.8+、jieba、argparse、json

贡献：欢迎提交 Issue 和 Pull Request！
1. Fork 本仓库
2. 创建特性分支 (git checkout -b feature/xxx)
3. 提交更改 (git commit -m 'Add xxx')
4. 推送分支 (git push origin feature/xxx)
5. 创建 Pull Request

开源许可证：MIT

作者：@smallmj | hexiealan007@gmail.com

---

如果这个项目对你有帮助，请 ⭐ Star 支持！

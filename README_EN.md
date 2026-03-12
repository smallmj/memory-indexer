# Memory Indexer 🧠

> Short-term memory keyword indexing tool for AI Agents

## Introduction

Memory Indexer is a tool that helps AI Agents persist their memory. It can:

- ✅ Automatically extract keywords from memory content
- ✅ Build fast keyword → memory file index
- ✅ Support multi-keyword precise search (AND/OR mode)
- ✅ Auto-discover related memories
- ✅ Display memories on a timeline
- ✅ Mark and view important memories
- ✅ Incrementally sync external memory directories

## Why Do You Need It?

AI Agents lose context after each conversation ends. Traditional solutions only save raw text, making retrieval difficult.

**Memory Indexer makes memories searchable, connectable, and traceable through keyword indexing.**

## Features

### 1. Automatic Keyword Extraction
Uses jieba for Chinese word segmentation to automatically extract keywords from memory content.

### 2. Multi-mode Search
- **OR mode**: Returns results if any keyword matches
- **AND mode**: Returns results only if all keywords match

### 3. Related Discovery
Automatically discovers which memories often appear together and generates related recommendations.

### 4. Timeline View
Displays all memories in chronological order for easy review.

### 5. Active Recall
Automatically prompts related old memories based on current conversation keywords.

### 6. Important Memory Marking
Manually mark important memories for priority retention and display.

### 7. Incremental Sync
Automatically scans external memory/ directory, only indexing new or modified files.

### 8. Stale Entry Cleanup
Automatically cleans up index entries for deleted memories.

## Installation

### Prerequisites

- Python 3.8+
- jieba (Chinese segmentation library)

### Steps

```bash
# 1. Clone the project
git clone https://github.com/your-username/memory-indexer.git
cd memory-indexer

# 2. Create virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# 3. Install dependencies
pip install -r requirements.txt

# 4. Run test
python memory-indexer.py status
```

## Quick Start

### Basic Usage

```bash
# Add a memory
python memory-indexer.py add "Today I learned Python programming"

# Search memories (OR mode)
python memory-indexer.py search "Python"

# Search memories (AND mode)
python memory-indexer.py search "Python programming" --and

# List all memories
python memory-indexer.py list

# View memory summary
python memory-indexer.py summary
```

### Integration with OpenClaw

```bash
# Use in OpenClaw workspace
cd ~/.openclaw/workspace
uv pip install jieba
uv run python skills/memory-indexer/memory-indexer.py add "memory content"
```

### Heartbeat Auto Sync

Add to `HEARTBEAT.md`:

```markdown
### Memory Index Sync
- Command: `cd ~/.openclaw/workspace && uv run python skills/memory-indexer/memory-indexer.py sync`
- Frequency: Every heartbeat
```

### Cron Scheduled Backup

```bash
crontab -e
# Auto sync every day at 6 AM
0 6 * * * cd /home/user/.openclaw/workspace && python skills/memory-indexer/memory-indexer.py sync
```

## Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `add` | Add memory | `add "I learned Python today"` |
| `search` | Search memories | `search "Python"` |
| `search --and` | AND search | `search "Python AI" --and` |
| `list` | List all memories | `list` |
| `sync` | Sync external directory | `sync` |
| `cleanup` | Clean stale indexes | `cleanup` |
| `related` | Find related memories | `related` |
| `timeline` | Show timeline | `timeline` |
| `recall` | Active recall | `recall "Python"` |
| `summary` | Memory summary | `summary` |
| `star` | Mark important | `star 20260312.md` |
| `stars` | View important memories | `stars` |
| `status` | View status | `status` |

## Configuration

The script automatically creates data files in the following directory:

```
~/.memory-indexer/
├── index.json          # Keyword index
├── sync-state.json    # Sync state
└── stars.json         # Important memory markers
```

You can customize the storage path by modifying the `WORKSPACE` variable in the code.

## Demo

### Search Results
```
$ python memory-indexer.py search "xiaohongshu diary"

Found 2 related memories (mode: OR):

Keywords: xiaohongshu, diary

📄 20260312_173114.md - 20260312_173114 🔥🔥
   Today we tested voice recognition and discussed plans for xiaohongshu diary
```

### Memory Summary
```
$ python memory-indexer.py summary

=== Memory Summary ===

📊 Total memories: 14
📊 Keyword count: 49

📅 Recent activity:
   2026-03-12: 34 entries
   2026-03-11: 28 entries

🔥 Hot keywords:
   voice recognition: 5 entries
   xiaohongshu: 3 entries
   diary: 2 entries
```

### Related Discovery
```
$ python memory-indexer.py related

=== Related Memory Discovery ===

📎 voice-recognition-test.md ↔ openai-whisper-install.md
   Common keywords: voice recognition, whisper, test

📎 xiaohongshu-diary.md ↔ content-planning.md
   Common keywords: xiaohongshu, diary, planning
```

## Tech Stack

- **Python 3.8+** - Runtime
- **jieba** - Chinese segmentation
- **argparse** - CLI parsing
- **json** - Data storage

## Contributing

Issues and Pull Requests are welcome!

1. Fork this repository
2. Create feature branch (`git checkout -b feature/xxx`)
3. Commit changes (`git commit -m 'Add xxx'`)
4. Push branch (`git push origin feature/xxx`)
5. Create Pull Request

## License

This project is licensed under the [MIT](./LICENSE) license.

## Author

- Author: Your Name
- Email: your@email.com
- GitHub: [@your-username](https://github.com/your-username)

---

If this project helps you, please ⭐ Star to show your support!

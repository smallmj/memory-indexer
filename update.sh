#!/bin/bash
#
# Memory Indexer 更新脚本
# 用法: ./update.sh
#

set -e

echo "🔄 Memory Indexer 更新程序"
echo "================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# 检查是否是 git 仓库
if [ ! -d ".git" ]; then
    echo -e "${RED}错误: 当前目录不是 Git 仓库${NC}"
    exit 1
fi

# 获取当前版本
CURRENT_VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "unknown")
echo "当前版本: $CURRENT_VERSION"

# 备份重要数据
echo ""
echo "💾 备份数据..."
BACKUP_DIR="$SCRIPT_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -f "index.json" ]; then
    cp index.json "$BACKUP_DIR/"
    echo "✅ 索引已备份"
fi
if [ -f "sync-state.json" ]; then
    cp sync-state.json "$BACKUP_DIR/"
    echo "✅ 同步状态已备份"
fi
if [ -f "stars.json" ]; then
    cp stars.json "$BACKUP_DIR/"
    echo "✅ 星星标记已备份"
fi

echo "📁 备份目录: $BACKUP_DIR"

# 拉取最新代码
echo ""
echo "📥 拉取最新代码..."
git fetch origin
git pull origin main --rebase || git pull origin master --rebase

# 获取新版本
NEW_VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "unknown")
echo "新版本: $NEW_VERSION"

# 重新安装依赖
echo ""
echo "📦 检查依赖..."
if python3 -c "import jieba" 2>/dev/null; then
    echo "✅ jieba 已安装"
else
    pip install jieba
    echo "✅ jieba 安装完成"
fi

# 运行迁移脚本（如果需要）
if [ -f "migrate.sh" ]; then
    echo ""
    echo "🔧 运行迁移脚本..."
    chmod +x migrate.sh
    ./migrate.sh
fi

# 清理并重新同步
echo ""
echo "🔄 重新同步索引..."
python3 memory-indexer.py sync

# 完成
echo ""
echo "================================"
echo -e "${GREEN}🎉 更新完成！${NC}"
echo ""
echo "📋 更新日志:"
git log --oneline -5
echo ""

# 提示备份清理
echo "💡 提示: 如果更新后一切正常，可以删除备份目录:"
echo "   rm -rf $BACKUP_DIR"

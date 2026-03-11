#!/bin/bash

# 飞书技能系列 - 更新脚本
# 用于更新已安装的技能到最新版本

set -e

echo "🔄 飞书技能系列 - 更新"
echo "========================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查是否已安装
if [ ! -d "$HOME/.openclaw/skills/send-message" ]; then
    echo -e "${RED}❌ 未检测到已安装的飞书技能${NC}"
    echo "请先运行安装脚本："
    echo "  curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills-for-openclaw/main/install-from-github.sh | bash"
    exit 1
fi

echo -e "${GREEN}✅ 检测到已安装的飞书技能${NC}"
echo ""

# 临时目录
TEMP_DIR=$(mktemp -d)
echo "临时目录: $TEMP_DIR"

# 下载最新版本
echo -e "${BLUE}📥 下载最新版本...${NC}"
if command -v git &> /dev/null; then
    git clone https://github.com/reneexiaoxiao/feishu-skills-for-openclaw.git "$TEMP_DIR/feishu-skills-for-openclaw"
else
    curl -L https://github.com/reneexiaoxiao/feishu-skills-for-openclaw/archive/refs/heads/main.zip -o "$TEMP_DIR/feishu-skills-for-openclaw.zip"
    unzip -q "$TEMP_DIR/feishu-skills-for-openclaw.zip" -d "$TEMP_DIR"
    mv "$TEMP_DIR/feishu-skills-for-openclaw-main" "$TEMP_DIR/feishu-skills-for-openclaw"
fi

echo ""

# 要更新的技能列表
skills=("send-message" "send-card" "send-image" "mention-user")

echo "将更新以下技能："
for skill in "${skills[@]}"; do
    if [ -d "$HOME/.openclaw/skills/$skill" ]; then
        echo "  - $skill (已安装)"
    fi
done
echo ""

# 确认更新
read -p "确认更新？(y/n，默认y): " confirm
confirm=${confirm:-y}
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${YELLOW}❌ 取消更新${NC}"
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo ""
echo -e "${BLUE}🚀 开始更新...${NC}"
echo ""

# 备份当前版本
BACKUP_DIR="$HOME/.openclaw/skills/feishu-skills-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "备份当前版本到: $BACKUP_DIR"

for skill in "${skills[@]}"; do
    if [ -d "$HOME/.openclaw/skills/$skill" ]; then
        cp -r "$HOME/.openclaw/skills/$skill" "$BACKUP_DIR/"
    fi
done

# 更新技能
success_count=0
for skill in "${skills[@]}"; do
    skill_dir="$TEMP_DIR/feishu-skills-for-openclaw/$skill"
    if [ -d "$skill_dir" ]; then
        # 删除旧版本
        rm -rf "$HOME/.openclaw/skills/$skill"
        # 复制新版本
        cp -r "$skill_dir" "$HOME/.openclaw/skills/"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ $skill 更新成功${NC}"
            ((success_count++))
        else
            echo -e "${RED}❌ $skill 更新失败${NC}"
        fi
    fi
done

# 清理临时文件
rm -rf "$TEMP_DIR"

echo ""
echo "========================"
echo "更新完成！"
echo -e "${GREEN}✅ 成功: $success_count 个${NC}"
echo ""
echo -e "${BLUE}📝 备份位置：${NC}$BACKUP_DIR"
echo ""

# 提示重启
echo -e "${YELLOW}🔄 请重启 OpenClaw 使更新生效${NC}"
echo ""
echo -e "${GREEN}🦞 享受使用飞书技能！${NC}"

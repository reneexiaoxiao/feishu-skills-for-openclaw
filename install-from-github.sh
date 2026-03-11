#!/bin/bash

# 飞书技能系列 - 一键安装脚本
# 适用于：从 GitHub 直接安装

set -e

echo "🦞 飞书技能系列 - 一键安装"
echo "=========================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查 OpenClaw
if [ ! -d "$HOME/.openclaw" ]; then
    echo -e "${RED}❌ 未找到 OpenClaw 目录${NC}"
    echo "请先安装 OpenClaw：https://openclaw.ai/"
    exit 1
fi

echo -e "${GREEN}✅ 找到 OpenClaw 目录${NC}"
echo ""

# 临时目录
TEMP_DIR=$(mktemp -d)
echo "临时目录: $TEMP_DIR"

# 下载项目
echo -e "${BLUE}📥 下载飞书技能系列...${NC}"
if command -v git &> /dev/null; then
    git clone https://github.com/reneexiaoxiao/feishu-skills.git "$TEMP_DIR/feishu-skills"
else
    echo -e "${YELLOW}⚠️  未安装 git，使用压缩包下载${NC}"
    curl -L https://github.com/reneexiaoxiao/feishu-skills/archive/refs/heads/main.zip -o "$TEMP_DIR/feishu-skills.zip"
    unzip -q "$TEMP_DIR/feishu-skills.zip" -d "$TEMP_DIR"
    mv "$TEMP_DIR/feishu-skills-main" "$TEMP_DIR/feishu-skills"
fi

echo ""

# 显示安装选项
echo "请选择安装方式："
echo "1. 安装所有技能（推荐）"
echo "2. 只安装即时通讯技能（消息、卡片、图片、@人）"
echo "3. 只安装文档技能（创建、更新、读取）"
echo "4. 只安装数据技能（多维表格）"
echo "5. 只安装日程技能（日历）"
echo ""
read -p "请输入选项 (1-5，默认1): " choice
choice=${choice:-1}

case $choice in
    1)
        echo -e "${GREEN}📦 安装所有技能...${NC}"
        skills=("send-message" "send-card" "send-image" "mention-user" "create-doc" "update-doc" "fetch-doc" "bitable" "calendar")
        ;;
    2)
        echo -e "${GREEN}💬 安装即时通讯技能...${NC}"
        skills=("send-message" "send-card" "send-image" "mention-user")
        ;;
    3)
        echo -e "${GREEN}📄 安装文档技能...${NC}"
        skills=("create-doc" "update-doc" "fetch-doc")
        ;;
    4)
        echo -e "${GREEN}📊 安装数据技能...${NC}"
        skills=("bitable")
        ;;
    5)
        echo -e "${GREEN}📅 安装日程技能...${NC}"
        skills=("calendar")
        ;;
    *)
        echo -e "${RED}❌ 无效的选项${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
        ;;
esac

echo ""
echo "将安装以下技能："
for skill in "${skills[@]}"; do
    echo "  - $skill"
done
echo ""

# 确认安装
read -p "确认安装？(y/n，默认y): " confirm
confirm=${confirm:-y}
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${YELLOW}❌ 取消安装${NC}"
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo ""
echo -e "${BLUE}🚀 开始安装...${NC}"
echo ""

# 创建技能目录
SKILLS_DIR="$HOME/.openclaw/skills"
mkdir -p "$SKILLS_DIR"

# 复制技能文件
success_count=0
fail_count=0

for skill in "${skills[@]}"; do
    skill_dir="$TEMP_DIR/feishu-skills/$skill"
    if [ -d "$skill_dir" ]; then
        # 删除旧版本（如果存在）
        if [ -d "$SKILLS_DIR/$skill" ]; then
            rm -rf "$SKILLS_DIR/$skill"
        fi

        # 复制新版本
        cp -r "$skill_dir" "$SKILLS_DIR/"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ $skill 安装成功${NC}"
            ((success_count++))
        else
            echo -e "${RED}❌ $skill 安装失败${NC}"
            ((fail_count++))
        fi
    else
        echo -e "${YELLOW}⚠️  $skill 目录不存在，跳过${NC}"
        ((fail_count++))
    fi
done

# 清理临时文件
rm -rf "$TEMP_DIR"

echo ""
echo "=========================="
echo "安装完成！"
echo -e "${GREEN}✅ 成功: $success_count 个${NC}"
if [ $fail_count -gt 0 ]; then
    echo -e "${RED}❌ 失败: $fail_count 个${NC}"
fi
echo ""

# 下一步操作
echo -e "${BLUE}📝 下一步操作：${NC}"
echo "1. 重启 OpenClaw"
echo "2. 测试技能："
echo "   - 给文件传输助手发消息'测试'"
echo "   - 创建一个文档"
echo "   - 查看日程"
echo ""
echo -e "${BLUE}📚 查看完整文档：${NC}"
echo "   https://github.com/reneexiaoxiao/feishu-skills"
echo ""
echo -e "${GREEN}🦞 享受使用飞书技能！${NC}"

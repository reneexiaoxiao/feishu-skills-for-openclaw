#!/bin/bash

# 飞书技能系列 - 快速安装脚本

echo "🦞 飞书技能系列 - 安装工具"
echo "================================"
echo ""

# 检查 OpenClaw 目录
if [ ! -d "$HOME/.openclaw" ]; then
    echo "❌ 未找到 OpenClaw 目录"
    echo "请先安装 OpenClaw：https://openclaw.ai/"
    exit 1
fi

echo "✅ 找到 OpenClaw 目录"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 显示安装选项
echo "请选择安装方式："
echo "1. 安装所有技能（推荐）"
echo "2. 只安装即时通讯技能（消息、卡片、图片、@人）"
echo "3. 只安装文档技能（创建、更新、读取）"
echo "4. 只安装数据技能（多维表格）"
echo "5. 只安装日程技能（日历）"
echo "6. 自定义选择"
echo ""
read -p "请输入选项 (1-6): " choice

case $choice in
    1)
        echo "📦 安装所有技能..."
        skills=("send-message" "send-card" "send-image" "mention-user" "create-doc" "update-doc" "fetch-doc" "bitable" "calendar")
        ;;
    2)
        echo "💬 安装即时通讯技能..."
        skills=("send-message" "send-card" "send-image" "mention-user")
        ;;
    3)
        echo "📄 安装文档技能..."
        skills=("create-doc" "update-doc" "fetch-doc")
        ;;
    4)
        echo "📊 安装数据技能..."
        skills=("bitable")
        ;;
    5)
        echo "📅 安装日程技能..."
        skills=("calendar")
        ;;
    6)
        echo "🔧 自定义选择..."
        echo "可用的技能："
        echo "  1) send-message    2) send-card       3) send-image"
        echo "  4) mention-user    5) create-doc      6) update-doc"
        echo "  7) fetch-doc       8) bitable         9) calendar"
        echo ""
        read -p "请输入要安装的技能编号（用空格分隔）: " skill_nums
        skills=()
        for num in $skill_nums; do
            case $num in
                1) skills+=("send-message") ;;
                2) skills+=("send-card") ;;
                3) skills+=("send-image") ;;
                4) skills+=("mention-user") ;;
                5) skills+=("create-doc") ;;
                6) skills+=("update-doc") ;;
                7) skills+=("fetch-doc") ;;
                8) skills+=("bitable") ;;
                9) skills+=("calendar") ;;
            esac
        done
        ;;
    *)
        echo "❌ 无效的选项"
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
read -p "确认安装？(y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ 取消安装"
    exit 0
fi

echo ""
echo "🚀 开始安装..."
echo ""

# 创建技能目录
SKILLS_DIR="$HOME/.openclaw/skills"
mkdir -p "$SKILLS_DIR"

# 复制技能文件
success_count=0
fail_count=0

for skill in "${skills[@]}"; do
    skill_dir="$SCRIPT_DIR/$skill"
    if [ -d "$skill_dir" ]; then
        # 复制技能目录
        cp -r "$skill_dir" "$SKILLS_DIR/"
        if [ $? -eq 0 ]; then
            echo "✅ $skill 安装成功"
            ((success_count++))
        else
            echo "❌ $skill 安装失败"
            ((fail_count++))
        fi
    else
        echo "⚠️  $skill 目录不存在，跳过"
        ((fail_count++))
    fi
done

echo ""
echo "================================"
echo "安装完成！"
echo "✅ 成功: $success_count 个"
if [ $fail_count -gt 0 ]; then
    echo "❌ 失败: $fail_count 个"
fi
echo ""

# 显示下一步操作
echo "📝 下一步操作："
echo "1. 重启 OpenClaw"
echo "2. 测试技能："
echo "   - 给文件传输助手发消息'测试'"
echo "   - 创建一个文档"
echo "   - 查看日程"
echo ""
echo "📚 查看完整文档："
echo "   cat $SCRIPT_DIR/README.md"
echo ""
echo "🦞 享受使用飞书技能！"

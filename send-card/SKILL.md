---
name: feishu-send-card
description: |
  向飞书群聊或私聊发送交互式卡片。

  **使用此技能**：用户说"发卡片"、"卡片消息"、需要结构化展示时。

  **调用工具**：feishu_im_user_message (来自 @larksuite/openclaw-lark 官方插件)

  **关键参数**：
  - receive_id: 群聊ID (oc_xxx) 或用户ID (ou_xxx)
  - receive_id_type: "chat_id" (群聊) 或 "open_id" (私聊)
  - msg_type: "interactive"
  - content: 卡片JSON字符串

  **卡片结构**：
  - header: 标题区域 (title, template颜色)
  - elements: 内容数组 (markdown, img, button, hr等)

  **常用场景**：项目进展、任务分配、会议通知
metadata:
  version: 2.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, card, interactive]
  openclaw:
    emoji: 📋
    mcp_required: feishu-openclaw-plugin
---

# 发送飞书卡片消息

调用官方插件的 `feishu_im_user_message` 工具，发送交互式卡片。

## 快速示例

**简单卡片**：
```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "interactive",
  "content": "{\"config\":{\"wide_screen_mode\":true},\"header\":{\"title\":{\"content\":\"📊 项目进展\",\"tag\":\"plain_text\"},\"template\":\"blue\"},\"elements\":[{\"tag\":\"markdown\",\"content\":\"**进度**: 80%\\n**状态**: 正常\"}]}"
}
```

## 卡片元素

| 元素 | tag | 用途 |
|------|-----|------|
| 文本 | markdown | 显示富文本内容 |
| 图片 | img | 显示图片 |
| 分割线 | hr | 分隔内容 |
| 按钮 | button | 交互操作 |
| 背景块 | column_set | 彩色背景 |

## 颜色主题

`template`: blue (默认) / green / red / yellow / grey / purple

## 卡片搭建工具

https://open.feishu.cn/tool/cardbuilder

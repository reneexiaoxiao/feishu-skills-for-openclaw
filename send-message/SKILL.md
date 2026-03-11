---
name: feishu-send-message
description: |
  向飞书群聊或私聊发送文本消息。

  **使用此技能**：用户说"发消息"、"告诉XX"、"给XX说"等。

  **调用工具**：feishu_im_user_message (来自 @larksuite/openclaw-lark 官方插件)

  **关键参数**：
  - receive_id: 群聊ID (oc_xxx) 或用户ID (ou_xxx)
  - receive_id_type: "chat_id" (群聊) 或 "open_id" (私聊)
  - msg_type: "text"
  - content: JSON字符串，格式为 {"text":"消息内容"}

  **注意**：
  - 发送卡片 → 使用 feishu-send-card
  - 发送图片 → 使用 feishu-send-image
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, message, im]
  openclaw:
    emoji: 💬
    mcp_required: feishu-openclaw-plugin
---

# 发送飞书文本消息

调用官方插件的 `feishu_im_user_message` 工具，发送文本消息。

## 快速调用

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "text",
  "content": "{\"text\":\"消息内容\"}"
}
```

## 常见场景

**给群聊发消息**：
```
用户："给产品群发消息'下午3点开会'"
```

**给个人发消息**：
```
用户："告诉张三'任务完成了'"
```

## ID 类型

| 类型 | 前缀 | receive_id_type |
|------|------|-----------------|
| 群聊 | oc_ | chat_id |
| 用户 | ou_ | open_id |

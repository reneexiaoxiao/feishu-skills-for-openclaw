---
name: feishu-send-image
description: |
  向飞书群聊或私聊发送图片。

  **使用此技能**：用户说"发图片"、"发截图"、"上传图片"时。

  **调用工具**：feishu_im_user_message (来自 @larksuite/openclaw-lark 官方插件)

  **流程**：
  1. 如果是本地图片 → 先上传获取 image_key
  2. 如果是URL → 直接使用
  3. 调用 feishu_im_user_message，msg_type="image"

  **关键参数**：
  - receive_id: 群聊ID (oc_xxx) 或用户ID (ou_xxx)
  - receive_id_type: "chat_id" (群聊) 或 "open_id" (私聊)
  - msg_type: "image"
  - content: JSON字符串，格式为 {"image_key":"img_xxx"}
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, image, im]
  openclaw:
    emoji: 🖼️
    mcp_required: feishu-openclaw-plugin
---

# 发送飞书图片

调用官方插件的 `feishu_im_user_message` 工具，发送图片。

## 快速调用

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "image",
  "content": "{\"image_key\":\"img_v3_xxx\"}"
}
```

## 图片来源

**已有 image_key**：直接发送

**本地图片**：需要先上传到飞书获取 image_key

**网络图片**：下载后上传，或直接使用URL（如果支持）

## 常见场景

```
用户："给产品群发截图"
用户："上传这张图片：/path/to/image.png"
```

---
name: feishu-send-image
description: |
  向飞书群聊或私聊发送图片。

  **核心作用（第1+2点）**：
  1. 路由：让虾知道用户想发图片时，调用官方插件的 feishu_im_user_message 工具
  2. 友好提示：本地图片需要先上传获取 image_key，引导用户使用网络图片链接

  **使用场景**：
  - "发图片"、"发截图"、"上传图片"

  **友好提示（用户友好）**：
  - 本地图片 → 提示"需要先上传到飞书，或者提供网络图片链接"
  - 网络 URL → 提示"可以直接使用图片链接"
  - 截图 → 提示"可以直接发送截图"

  **调用工具**：feishu_im_user_message (来自 @larksuite/openclaw-lark 官方插件)

  **关键参数**：
  - msg_type: "image"
  - content: JSON字符串，格式为 {"image_key":"img_xxx"}
metadata:
  version: 2.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, image, im, router]
  openclaw:
    emoji: 🖼️
    mcp_required: feishu-openclaw-plugin
---

# 发送飞书图片 - 路由技能

## 🎯 技能定位

这是官方插件的**路由技能**，帮助虾识别发送图片的意图并处理前置条件。

---

## 🚨 智能提示逻辑

### 场景1：本地图片路径

**用户输入**："发送 /path/to/image.png"

**虾的响应**：
```
我可以帮你发送图片！本地图片需要先上传到飞书。

有两种方式：
1. 上传到飞书云文档，然后分享链接（推荐）
2. 直接把图片拖到这个对话框

或者，如果图片在网络上，提供 URL 链接也可以。
```

**原因**：本地图片无法直接发送，需要先上传获取 image_key

---

### 场景2：网络图片 URL

**用户输入**："发送 https://example.com/image.png"

**虾的响应**：
```
收到！我会：
1. 上传这个网络图片到飞书
2. 获取 image_key
3. 发送到目标群聊/用户
```

**可以发送** ✅

---

### 场景3：截图（最简单）

**用户输入**：直接粘贴截图

**虾的响应**：
```
收到截图！我会直接发送。
```

**可以发送** ✅

---

### 场景4：已有 image_key

**用户输入**："发送 img_v3_xxx"

**虾的响应**：
直接调用 feishu_im_user_message 发送图片 ✅

---

## 📋 调用示例

### 示例1：发送图片（有 image_key）

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "image",
  "content": "{\"image_key\":\"img_v3_xxx\"}"
}
```

### 示例2：上传并发送（网络图片）

```javascript
// 1. 先上传图片
upload_result = upload_image_to_feishu("https://example.com/image.png")

// 2. 发送图片
feishu_im_user_message({
  action: "send",
  receive_id: "oc_xxx",
  receive_id_type: "chat_id",
  msg_type: "image",
  content: JSON.stringify({
    image_key: upload_result.image_key
  })
})
```

---

## 💡 最佳实践

**对用户说**：
- ✅ "本地图片需要先上传到飞书"
- ✅ "你可以直接粘贴截图"
- ✅ "网络图片链接可以发送"
- ✅ "拖动图片到对话框即可"

**不要说**：
- ❌ "请提供 image_key"
- ❌ "需要先调用上传 API"
- ❌ "缺少必要参数"

---

## 🎯 关键价值

1. **路由作用** - 帮助虾找到正确的官方工具
2. **友好提示** - 引导用户使用最简单的方式
3. **降低门槛** - 不需要知道技术细节，截图即可

---

## 📚 图片来源

| 来源 | 处理方式 | 难度 |
|------|---------|------|
| 截图粘贴 | 直接发送 | ⭐ 最简单 |
| 网络 URL | 上传后发送 | ⭐⭐ 简单 |
| 本地文件 | 需先上传 | ⭐⭐⭐ 复杂 |
| 已有 image_key | 直接发送 | ⭐⭐ 简单 |

**推荐**：使用截图或网络图片链接 ✅

---
name: feishu-send-image
description: |
  向飞书群聊或私聊发送图片消息。

  **当以下情况时使用此 Skill**：
  (1) 用户明确要求发送图片到群聊或私聊
  (2) 关键词："发送图片"、"发图片"、"发截图"、"上传图片"
  (3) 提供：图片路径、图片URL或图片文件

  **参数说明**：
  - receive_id: 群聊ID（oc_开头）或用户ID（ou_开头）
  - receive_id_type: "chat_id"（群聊）或 "user_id"（私聊）
  - image_type: "image"
  - image_key: 图片上传后返回的 key

  **发送流程**：
  1. 如果是本地图片或URL，先上传到飞书服务器
  2. 获取 image_key
  3. 发送图片消息

  **NOT 使用此 Skill 的情况**：
  - 发送文本消息 → 使用 feishu-send-message
  - 发送卡片 → 使用 feishu-send-card
  - 只是询问如何发送图片 → 不调用任何工具

  **API 参考**：https://open.feishu.cn/document/server-docs/im-v1/message/create
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, image, media]
  openclaw:
    emoji: 🖼️
    mcp_required: feishu-openclaw-plugin
---

# 飞书发送图片消息

## 工具调用

使用 `feishu_send_image` 工具发送图片。

### 参数结构

```json
{
  "receive_id": "oc_xxx 或 ou_xxx",
  "receive_id_type": "chat_id 或 user_id",
  "msg_type": "image",
  "content": "{\"image_key\": \"img_xxx\"}"
}
```

### 参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| receive_id | string | ✅ | 群聊ID（oc_开头）或用户ID（ou_开头） |
| receive_id_type | string | ✅ | "chat_id"（群聊）或 "user_id"（私聊） |
| msg_type | string | ✅ | 固定值 "image" |
| content | string | ✅ | JSON 字符串，包含 image_key |

## 执行流程

### 方式1：发送本地图片文件

**用户输入**：
```
给产品群发送图片：/path/to/screenshot.png
```

**执行步骤**：
1. 读取本地图片文件
2. 上传到飞书服务器获取 image_key
3. 发送图片消息

**API 调用**：
```json
{
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "image",
  "content": "{\"image_key\": \"img_xxx\"}"
}
```

### 方式2：发送图片URL

**用户输入**：
```
给张三发送图片：https://example.com/image.png
```

**执行步骤**：
1. 从 URL 下载图片
2. 上传到飞书服务器获取 image_key
3. 发送图片消息

### 方式3：使用已上传的 image_key

**用户输入**：
```
发送图片 img_xxx 到产品群
```

**执行步骤**：
1. 直接使用提供的 image_key
2. 发送图片消息

## 图片上传

### 上传工具

使用 `feishu_upload_image` 上传图片：

**请求**：
```json
{
  "image_type": "message",
  "file": "图片文件数据"
}
```

**响应**：
```json
{
  "code": 0,
  "data": {
    "image_key": "img_xxx"
  }
}
```

## 常见场景

### 场景1：发送截图

**用户输入**：
```
给产品群发这张截图：/Users/xxx/Desktop/screenshot.png
```

**执行**：
1. 读取文件：`/Users/xxx/Desktop/screenshot.png`
2. 上传获取 `image_key`
3. 发送到群聊

### 场景2：发送网络图片

**用户输入**：
```
把这个图片发给产品组：https://example.com/chart.png
```

**执行**：
1. 下载图片
2. 上传获取 `image_key`
3. 发送到群聊

### 场景3：批量发送图片

**用户输入**：
```
给产品群发送这些图片：
- /path/to/image1.png
- /path/to/image2.png
- /path/to/image3.png
```

**执行**：
依次发送每张图片

## 图片要求

### 格式支持

- ✅ PNG
- ✅ JPG / JPEG
- ✅ GIF
- ✅ WebP
- ✅ BMP

### 大小限制

- 单张图片：最大 10MB
- 建议大小：< 5MB 以确保快速发送

### 分辨率建议

- 最优：1920x1080 或以下
- 最大：4096x4096

## 错误处理

### 错误1：文件不存在

**处理**：
```
"图片文件不存在，请检查路径：
/path/to/image.png"
```

### 错误2：图片格式不支持

**处理**：
```
"图片格式不支持，请使用 PNG、JPG、GIF、WebP 或 BMP 格式"
```

### 错误3：文件过大

**处理**：
```
"图片文件过大（最大10MB），请压缩后重试"
```

### 错误4：上传失败

**处理**：
```
"图片上传失败，可能原因：
1. 网络连接问题
2. 飞书服务器错误
3. 图片文件损坏

请稍后重试"
```

### 错误5：image_key 无效

**处理**：
```
"image_key 无效或已过期，需要重新上传图片"
```

## 注意事项

1. **上传图片有有效期**：image_key 通常有效期为 30 天
2. **并发上传**：同时上传多张图片时，建议每张间隔 0.5 秒
3. **图片压缩**：大图片建议先压缩再发送
4. **路径处理**：支持绝对路径和相对路径
5. **URL 下载**：确保图片 URL 可公开访问

## 带图片说明的发送

**用户输入**：
```
给产品群发截图，并说明"这是新的UI设计"
```

**执行**：
1. 发送图片
2. 发送文本说明

或者使用文本+图片的组合消息。

## 相关 API 文档

- [发送消息 API](https://open.feishu.cn/document/server-docs/im-v1/message/create)
- [上传图片 API](https://open.feishu.cn/document/server-docs/im-v1/image/upload)
- [消息类型说明](https://open.feishu.cn/document/server-docs/im-v1/message/message_types)

## 返回结果

成功时返回：
```json
{
  "code": 0,
  "msg": "success",
  "data": {
    "message_id": "om_xxx"
  }
}
```

向用户确认：
```
✅ 图片已发送
消息ID: om_xxx
图片大小: 1.2MB
```


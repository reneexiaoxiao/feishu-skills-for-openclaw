---
name: feishu-send-message
description: |
  向飞书群聊或私聊发送文本消息。

  **当以下情况时使用此 Skill**：
  (1) 用户明确要求发送消息到群聊或私聊
  (2) 关键词："发送消息"、"发消息"、"给XX说"、"告诉XX"
  (3) 目标对象：群聊（oc_开头）或用户（ou_开头）
  (4) 消息类型：文本内容（不包括卡片、图片等复杂类型）

  **参数说明**：
  - receive_id: 群聊ID（oc_开头）或用户ID（ou_开头）
  - receive_id_type: "chat_id"（群聊）或 "user_id"（私聊）
  - content: 消息文本内容
  - msg_type: "text"

  **NOT 使用此 Skill 的情况**：
  - 发送卡片 → 使用 feishu-send-card
  - 发送图片 → 使用 feishu-send-image
  - @某人 → 使用 feishu-mention-user
  - 只是询问如何发送 → 不调用任何工具

  **API 参考**：https://open.feishu.cn/document/server-docs/im-v1/message/create
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, message, im]
  openclaw:
    emoji: 💬
    mcp_required: feishu-openclaw-plugin
---

# 飞书发送文本消息

## 工具调用

使用 `feishu_send_message` 工具发送消息。

### 参数结构

```json
{
  "receive_id": "oc_xxx 或 ou_xxx",
  "receive_id_type": "chat_id 或 user_id",
  "content": "消息文本内容",
  "msg_type": "text"
}
```

### 参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| receive_id | string | ✅ | 群聊ID（oc_开头）或用户ID（ou_开头） |
| receive_id_type | string | ✅ | "chat_id"（群聊）或 "user_id"（私聊） |
| content | string | ✅ | 消息文本内容 |
| msg_type | string | ✅ | 固定值 "text" |

## 执行流程

### 1. 识别目标

从用户输入中提取：
- 群聊名称或ID
- 用户名称或ID

**示例**：
```
用户：给产品群发消息"测试"
→ receive_id: 需要获取产品群的 ID
→ 如果用户只提供了群名，先搜索获取群ID
```

### 2. 确定消息类型

```json
receive_id_type 判断：
- oc_ 开头 → "chat_id"（群聊）
- ou_ 开头 → "user_id"（私聊）
- 只有群名 → 需要搜索获取 chat_id
- 只有人名 → 需要搜索获取 user_id
```

### 3. 构建并发送

```json
{
  "receive_id": "oc_a0553eda9014c201e6969b478895c230",
  "receive_id_type": "chat_id",
  "content": "大家好",
  "msg_type": "text"
}
```

## 常见场景

### 场景1：发送到群聊

**用户输入**：
```
给产品群发消息"下午3点开会"
```

**执行**：
1. 识别目标：产品群
2. 获取群ID：oc_xxx
3. 发送消息

**API 调用**：
```json
{
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "content": "下午3点开会",
  "msg_type": "text"
}
```

### 场景2：发送给个人

**用户输入**：
```
给张三发消息"你好"
```

**执行**：
1. 识别目标：张三
2. 获取用户ID：ou_xxx
3. 发送消息

**API 调用**：
```json
{
  "receive_id": "ou_xxx",
  "receive_id_type": "user_id",
  "content": "你好",
  "msg_type": "text"
}
```

### 场景3：使用群ID

**用户输入**：
```
给 oc_a0553eda9014c201e6969b478895c230 发消息"测试"
```

**执行**：
直接使用提供的 ID

**API 调用**：
```json
{
  "receive_id": "oc_a0553eda9014c201e6969b478895c230",
  "receive_id_type": "chat_id",
  "content": "测试",
  "msg_type": "text"
}
```

## 错误处理

### 错误1：缺少目标ID

**现象**：用户只说"发消息"，没有目标

**处理**：询问目标
```
"请问要发送到哪里？提供群聊ID或用户ID"
```

### 错误2：缺少消息内容

**现象**：用户说"给XX发消息"，但没有内容

**处理**：询问消息内容
```
"请告诉我想要发送的消息内容"
```

### 错误3：无权限访问

**错误码**：99991663 或类似权限错误

**处理**：
```
"无法访问该群聊/用户，可能原因：
1. 机器人未加入该群聊
2. 用户无权限发送消息
3. 目标ID不正确"
```

## 注意事项

1. **消息内容不要过度转义**：直接使用用户提供的文本
2. **ID 格式验证**：
   - 群聊ID：oc_ 开头
   - 用户ID：ou_ 开头
3. **内容长度**：单个消息不超过 4096 字节
4. **频率限制**：避免短时间内大量发送

## 相关 API 文档

- [发送消息 API](https://open.feishu.cn/document/server-docs/im-v1/message/create)
- [消息类型说明](https://open.feishu.cn/document/server-docs/im-v1/message/message_types)
- [错误码说明](https://open.feishu.cn/document/server-docs/im-v1/message/error_code)

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
✅ 消息已发送
消息ID: om_xxx
```

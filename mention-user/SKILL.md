---
name: feishu-mention-user
description: |
  在飞书消息中@提及用户的辅助技能。

  **核心作用**：教会虾如何在消息中使用 @ 标签提及用户。

  **使用场景**：
  - "@XX"、"艾特XX"、"提及XX"
  - 需要通知特定用户关注消息

  **配合使用**：
  - feishu-send-message: 发送带 @ 的文本消息
  - feishu-send-card: 发送带 @ 的卡片消息

  **格式说明**：
  - 文本消息：<at user_id="ou_xxx">用户名</at>
  - 卡片消息：<at user_id=\"ou_xxx\">用户名</at> (JSON转义)
  - @所有人：<at user_id="all">@所有人</at>

  **友好提示（第2点）**：
  - 当用户说"@张三"时，虾可以从 @ 标签中自动获取张三的 open_id
  - 不需要用户手动提供 ID，系统会自动解析

  **关键价值**：降低使用门槛，用 @ 替代手动输入 open_id
metadata:
  version: 2.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, mention, at, helper]
  openclaw:
    emoji: @
    mcp_required: feishu-openclaw-plugin
---

# 飞书@提及用户 - 辅助技能

## 🎯 技能定位

这是**辅助技能**，教会虾如何在消息中使用 @ 标签。

核心价值：**用 @ 替代手动输入 open_id**，降低使用门槛。

---

## 📋 @标签格式

### 文本消息中

```
<at user_id="ou_xxx">张三</at> 请查看进度
```

完整示例：
```json
{
  "msg_type": "text",
  "content": "{\"text\":\"<at user_id=\\\"ou_123\\\">张三</at> 请查看进度\"}"
}
```

### 卡片消息中

```json
{
  "content": "<at user_id=\"ou_xxx\">张三</at> 请查看"
}
```

**注意**：JSON 中需要转义引号 `\"`

### @所有人

```
<at user_id="all">@所有人</at> 请注意
```

---

## 🚨 智能场景

### 场景1：用户在对话中@某人

**用户输入**：在群里 @张三 并说"通知他开会"

**虾的处理**：
```
收到！我会：
1. 从 @张三 标签中自动获取张三的 open_id
2. 构建包含 @ 的消息内容
3. 发送到群聊
```

**关键**：系统会自动解析 @ 标签，无需手动输入 ID

---

### 场景2：@所有人

**用户输入**："@所有人 开会了"

**虾的处理**：
```
收到！我会：
1. 使用 <at user_id="all">@所有人</at> 标签
2. 构建消息内容
3. 发送到群聊
```

---

### 场景3：批量@多人

**用户输入**："@张三 @李四 @王五 来开会"

**虾的处理**：
```
收到！我会：
1. 解析所有 @ 标签
2. 构建包含多个 @ 的消息
3. 发送到群聊
```

---

## 📖 完整示例

### 示例1：文本消息中@单人

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "text",
  "content": "{\"text\":\"<at user_id=\\\"ou_123\\\">张三</at> 请查看项目进度\"}"
}
```

### 示例2：文本消息中@多人

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "text",
  "content": "{\"text\":\"<at user_id=\\\"ou_123\\\">张三</at> <at user_id=\\\"ou_456\\\">李四</at> 请确认\"}"
}
```

### 示例3：卡片中@

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "interactive",
  "content": "{\"elements\":[{\"tag\":\"markdown\",\"content\":\"<at user_id=\\\"ou_123\\\">张三</at> 请查看**项目进展**\"}]}"
}
```

---

## 💡 最佳实践

**推荐做法**：
- ✅ 让用户在对话中 @ 某人，虾自动解析
- ✅ 在卡片中使用 @ 标签提及相关人员
- ✅ 使用 @所有人 通知重要事项

**注意事项**：
- ⚠️ @所有人需要群主或管理员权限
- ⚠️ @ 标签在卡片中需要 JSON 转义
- ⚠️ open_id 格式：ou_ 开头

---

## 🎯 关键价值

1. **自动解析** - 从 @ 标签自动获取 open_id
2. **用户友好** - 不需要记住复杂的 ID 格式
3. **配合使用** - 与 send-message/send-card 配合使用

---

## 🔄 与其他技能的配合

### 与 send-message 配合

```
用户："@张三 告诉他开会"

虾的处理：
1. 解析 @张三 → 获取 open_id
2. 调用 send-message 技能
3. 在消息中包含 @张三 标签
4. 发送到群聊
```

### 与 send-card 配合

```
用户："发个卡片 @产品组 通知进度"

虾的处理：
1. 解析 @产品组 → 获取 chat_id
2. 调用 send-card 技能
3. 在卡片中包含 @产品组 标签
4. 发送到群聊
```

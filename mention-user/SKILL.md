---
name: feishu-mention-user
description: |
  在飞书消息中@提及用户。

  **使用此技能**：用户说"@XX"、"艾特"、"提及"时。

  **实现方式**：在消息内容中使用 @标签

  **格式**：
  - 文本消息：<at user_id="ou_xxx">用户名</at>
  - 卡片消息：<at user_id=\"ou_xxx\">用户名</at> (JSON转义)
  - @所有人：<at user_id="all">@所有人</at>

  **配合使用**：
  - feishu-send-message: 发送带@的文本
  - feishu-send-card: 发送带@的卡片

  **注意**：需要用户提供 user_id (ou_开头)，或通过用户名搜索获取
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, mention, at]
  openclaw:
    emoji: @
    mcp_required: feishu-openclaw-plugin
---

# 飞书@提及用户

在消息内容中使用 @标签提及用户。

## @标签格式

**文本消息中**：
```
<at user_id="ou_xxx">张三</at> 请查看进度
```

**卡片JSON中**：
```json
{"content": "<at user_id=\"ou_xxx\">张三</at> 请查看"}
```

**@所有人**：
```
<at user_id="all">@所有人</at> 请注意
```

## 常见场景

```
用户："@所有人 请开会"
用户："@张三 @李四 请回复"
```

## 使用方式

**方式1**：在发送消息时直接包含@标签

**方式2**：在发送卡片时在内容中包含@标签

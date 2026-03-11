---
name: feishu-send-card
description: |
  向飞书群聊或私聊发送交互式卡片消息。

  **当以下情况时使用此 Skill**：
  (1) 用户明确要求发送卡片到群聊或私聊
  (2) 关键词："发送卡片"、"发卡片"、"card"、"卡片消息"
  (3) 需要发送结构化信息（项目进展、任务分配、会议通知等）
  (4) 需要更丰富的展示形式（不仅是文本）

  **卡片类型判断**：
  - 项目进展 → 使用 progress 卡片模板
  - 任务分配 → 使用 task 卡片模板
  - 会议通知 → 使用 meeting 卡片模板
  - 自定义内容 → 使用 custom 卡片类型

  **参数说明**：
  - receive_id: 群聊ID（oc_开头）或用户ID（ou_开头）
  - receive_id_type: "chat_id"（群聊）或 "user_id"（私聊）
  - card: 卡片 JSON 对象（遵循飞书卡片规范）

  **NOT 使用此 Skill 的情况**：
  - 发送纯文本消息 → 使用 feishu-send-message
  - 发送图片 → 使用 feishu-send-image
  - 只是询问如何发送卡片 → 不调用任何工具

  **API 参考**：
  - https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/feishu-card-overview
  - https://open.feishu.cn/document/server-docs/im-v1/message/create
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, card, interactive]
  openclaw:
    emoji: 📋
    mcp_required: feishu-openclaw-plugin
---

# 飞书发送卡片消息

## 工具调用

使用 `feishu_send_card` 工具发送卡片。

### 参数结构

```json
{
  "receive_id": "oc_xxx 或 ou_xxx",
  "receive_id_type": "chat_id 或 user_id",
  "card": {
    "header": { ... },
    "elements": [ ... ]
  }
}
```

### 参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| receive_id | string | ✅ | 群聊ID（oc_开头）或用户ID（ou_开头） |
| receive_id_type | string | ✅ | "chat_id"（群聊）或 "user_id"（私聊） |
| card | object | ✅ | 卡片 JSON 对象 |

## 卡片模板

### 模板1：项目进展卡片

**适用场景**：项目进度汇报、工作总结

**用户输入示例**：
```
给产品群发项目进展卡片：
- 项目：飞书集成
- 进度：80%
- 状态：正常
- 更新时间：今天
```

**卡片结构**：
```json
{
  "config": {
    "wide_screen_mode": true
  },
  "header": {
    "title": {
      "content": "📊 飞书集成项目进展",
      "tag": "plain_text"
    },
    "template": "blue"
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "**进度：** 80%",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**状态：** 正常",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**更新时间：** 2026-03-11",
        "tag": "lark_md"
      }
    }
  ]
}
```

### 模板2：任务分配卡片

**适用场景**：分配任务给团队成员

**用户输入示例**：
```
给项目组发任务卡片：
- 任务：完成API开发
- 负责人：张三
- 截止日期：2026-03-15
```

**卡片结构**：
```json
{
  "header": {
    "title": {
      "content": "📋 新任务分配",
      "tag": "plain_text"
    },
    "template": "green"
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "**任务：** 完成API开发",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**负责人：** <at user_id=\"ou_xxx\">张三</at>",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**截止日期：** 2026-03-15",
        "tag": "lark_md"
      }
    }
  ]
}
```

### 模板3：会议通知卡片

**适用场景**：会议邀请和通知

**用户输入示例**：
```
给项目组发会议通知：
- 时间：明天下午2点
- 时长：1小时
- 主题：项目进度同步
- 参会人：@张三 @李四 @王五
- 地点：302会议室
```

**卡片结构**：
```json
{
  "header": {
    "title": {
      "content": "📅 会议通知",
      "tag": "plain_text"
    },
    "template": "red"
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "**会议主题：** 项目进度同步",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**时间：** 明天下午 2:00 - 3:00",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**地点：** 302会议室",
        "tag": "lark_md"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "**参会人：** <at user_id=\"ou_xxx\">张三</at> <at user_id=\"ou_yyy\">李四</at> <at user_id=\"ou_zzz\">王五</at>",
        "tag": "lark_md"
      }
    }
  ]
}
```

## 执行流程

### 1. 识别卡片类型

根据用户输入判断使用哪个模板：

| 关键词 | 卡片类型 |
|--------|---------|
| 进展、进度、项目更新 | project-progress |
| 任务、分配、todo | task-assignment |
| 会议、通知、邀请 | meeting-notice |
| 其他 | custom |

### 2. 提取卡片内容

从用户输入中提取结构化信息：

**示例输入**：
```
发项目进展卡片：
项目：飞书集成
进度：80%
状态：正常
```

**提取结果**：
```json
{
  "project": "飞书集成",
  "progress": "80%",
  "status": "正常"
}
```

### 3. 构建 JSON

使用提取的内容填充模板。

### 4. 发送卡片

调用 `feishu_send_card` 工具。

## 自定义卡片

当用户提供自定义结构时：

**用户输入**：
```
发卡片，标题是"重要通知"，内容是"明天放假"
```

**构建卡片**：
```json
{
  "header": {
    "title": {
      "content": "重要通知",
      "tag": "plain_text"
    }
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "明天放假",
        "tag": "plain_text"
      }
    }
  ]
}
```

## 卡片元素类型

### 常用元素

| 类型 | tag | 用途 |
|------|-----|------|
| 文本块 | div | 显示文本内容 |
| Markdown | div with lark_md | 支持富文本格式 |
| 分割线 | hr | 分隔内容 |
| 图片 | img | 显示图片 |
| 按钮 | action | 交互按钮 |
| 人员提及 | at user_id | @某人 |

### Markdown 格式

在 `tag: "lark_md"` 中支持：
- **粗体**：`**文本**`
- *斜体*：`*文本*`
- ~~删除线~~：`~~文本~~`
- `行内代码`
- 链接：`[文本](URL)`

## 错误处理

### 错误1：缺少必需信息

**处理**：询问用户
```
"请问卡片需要包含哪些内容？
例如：项目名称、进度、状态等"
```

### 错误2：卡片格式错误

**错误码**：99991400 或类似

**处理**：
```
"卡片格式不正确，请检查：
1. JSON 格式是否正确
2. 必需字段是否完整
3. 字段类型是否匹配"
```

### 错误3：@用户ID无效

**处理**：
```
"用户ID格式不正确，应为 ou_ 开头的字符串"
```

## 注意事项

1. **卡片大小限制**：JSON 不超过 50KB
2. **元素数量限制**：单个卡片不超过 50 个元素
3. **颜色主题**：blue, green, red, yellow, grey
4. **@人功能**：需要使用 feishu-mention-user 获取用户ID

## 相关 API 文档

- [飞书卡片概述](https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/feishu-card-overview)
- [卡片元素说明](https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/card-contents)
- [发送卡片 API](https://open.feishu.cn/document/server-docs/im-v1/message/create)
- [卡片构建工具](https://open.feishu.cn/document/tools-and-resources/message-card-builder)

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
✅ 卡片已发送
消息ID: om_xxx
```

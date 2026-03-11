---
name: feishu-mention-user
description: |
  在飞书消息中@提及用户。

  **当以下情况时使用此 Skill**：
  (1) 用户要求在消息中@某人
  (2) 关键词："@XX"、"艾特"、"提及"、"at"
  (3) 需要通知特定用户关注消息

  **参数说明**：
  - user_id: 用户的 open_id（ou_开头）
  - user_name: 用户显示名称（可选）
  - mention_type: 提及类型（"all"、"single"、"user"）

  **提及类型**：
  - "@所有人"：mention_type = "all"
  - "@某人"：mention_type = "user" + user_id

  **返回结果**：可在文本消息或卡片中使用的@标签

  **使用方式**：
  - 文本消息：直接在 content 中包含 <at user_id="ou_xxx">用户名</at>
  - 卡片消息：在 card 的元素中使用 at 标签

  **NOT 使用此 Skill 的情况**：
  - 只是发送消息不@人 → 使用 feishu-send-message
  - 只是询问如何@人 → 不调用任何工具

  **API 参考**：https://open.feishu.cn/document/server-docs/im-v1/message/create
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, mention, at]
  openclaw:
    emoji: @
    mcp_required: feishu-openclaw-plugin
---

# 飞书@提及用户

## @标签格式

### 在文本消息中使用

**格式**：
```xml
<at user_id="ou_xxx">用户名</at>
```

**完整示例**：
```
@所有人 请注意

<at user_id="ou_aaaaa">张三</at> 请查看
<at user_id="ou_bbbbb">李四</at> 请回复
```

### 在卡片消息中使用

**格式**（Markdown 类型）：
```json
{
  "tag": "div",
  "text": {
    "content": "<at user_id=\"ou_xxx\">用户名</at> 请查看",
    "tag": "lark_md"
  }
}
```

## 执行流程

### 1. 识别@请求

从用户输入中提取：
- @的对象：人名或用户ID
- @的类型：单人或所有人
- 消息内容

**示例输入**：
```
给产品群发消息"@张三 请查看进度"
```

**提取结果**：
```json
{
  "mentions": ["张三"],
  "message": "请查看进度"
}
```

### 2. 获取用户ID

如果用户提供的是人名，需要搜索获取 user_id：

**搜索工具**：
```json
{
  "query": "张三"
}
```

**返回**：
```json
{
  "user_id": "ou_xxx",
  "name": "张三"
}
```

### 3. 构建包含@的消息

将 @标签插入到消息内容中。

## 常见场景

### 场景1：@所有人

**用户输入**：
```
给产品群发消息"@所有人 明天放假"
```

**构建消息**：
```
<at user_id="all">@所有人</at> 明天放假
```

**API 调用**：
```json
{
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "content": "<at user_id=\"all\">@所有人</at> 明天放假",
  "msg_type": "text"
}
```

### 场景2：@单个用户

**用户输入**：
```
给产品群发消息"@张三 请汇报进度"
```

**执行步骤**：
1. 搜索"张三"获取 user_id：ou_xxx
2. 构建消息

**构建消息**：
```
<at user_id="ou_xxx">张三</at> 请汇报进度
```

**API 调用**：
```json
{
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "content": "<at user_id=\"ou_xxx\">张三</at> 请汇报进度",
  "msg_type": "text"
}
```

### 场景3：@多个用户

**用户输入**：
```
给产品群发消息"@张三 @李四 @王五 请开会"
```

**构建消息**：
```
<at user_id="ou_xxx">张三</at> <at user_id="ou_yyy">李四</at> <at user_id="ou_zzz">王五</at> 请开会
```

### 场景4：在卡片中@人

**用户输入**：
```
发任务卡片@张三
任务：完成API开发
截止：明天
```

**卡片结构**：
```json
{
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "**负责人：** <at user_id=\"ou_xxx\">张三</at>",
        "tag": "lark_md"
      }
    }
  ]
}
```

## 用户ID搜索

### 搜索方式

当用户提供人名时，使用搜索工具获取 user_id：

**搜索请求**：
```json
{
  "query": "张三"
}
```

**搜索响应**：
```json
{
  "data": {
    "items": [
      {
        "user_id": "ou_xxx",
        "name": "张三"
      }
    ]
  }
}
```

### 搜索失败处理

如果搜索不到用户：

**处理**：
```
"找不到用户"张三"，请提供：
1. 完整的用户名
2. 或直接提供 user_id（ou_开头）"
```

## 特殊@类型

### @所有人

**格式**：
```xml
<at user_id="all">@所有人</at>
```

**限制**：
- 每个群聊每天最多 @所有人 3 次
- 需要机器人权限

### @手机号

**格式**：
```xml
<at user_id="ou_xxx" phone="13800138000">张三</at>
```

### @邮箱

**格式**：
```xml
<at user_id="ou_xxx" email="zhangsan@example.com">张三</at>
```

## 错误处理

### 错误1：找不到用户

**处理**：
```
"找不到该用户，请检查：
1. 用户名是否正确
2. 用户是否在群聊中
3. 是否有权限获取用户信息"
```

### 错误2：user_id 格式错误

**处理**：
```
"user_id 格式错误，应为 ou_ 开头的字符串
示例：ou_aaaaa1234567890"
```

### 错误3：@所有人次数超限

**错误码**：99991402

**处理**：
```
"@所有人次数已达上限（每天3次）
请改为@具体用户"
```

### 错误4：无权限@某人

**处理**：
```
"无权限@该用户，可能原因：
1. 用户不在群聊中
2. 机器人权限不足"
```

## 注意事项

1. **user_id 必须有效**：确保用户在群聊中
2. **显示名称可选**：可以不提供显示名
3. **@所有人限制**：注意使用频率
4. **大小写敏感**：user_id 大小写必须完全匹配
5. **群聊限制**：只能在群聊中@人，私聊不需要

## 最佳实践

### 方式1：先搜索再@

```
用户：@张三 发消息"你好"

执行：
1. 搜索"张三" → ou_xxx
2. 发送消息："你好" + @张三
```

### 方式2：直接提供 user_id

```
用户：@ou_xxx 发消息"你好"

执行：
1. 直接使用 ou_xxx
2. 发送消息
```

### 方式3：批量@

```
用户：@张三 @李四 @王五 发消息"开会"

执行：
1. 依次搜索获取 user_id
2. 构建包含多个@的消息
3. 发送
```

## 相关 API 文档

- [发送消息 API（@说明）](https://open.feishu.cn/document/server-docs/im-v1/message/create)
- [搜索用户 API](https://open.feishu.cn/document/server-docs/contact/user/search)
- [获取用户信息 API](https://open.feishu.cn/document/server-docs/contact/user/get)

## 返回结果

成功时返回：
```json
{
  "code": 0,
  "msg": "success"
}
```

向用户确认：
```
✅ 消息已发送（包含@提及）
@用户：张三
消息内容：请查看进度
```


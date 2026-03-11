---
name: feishu-bitable
description: |
  飞书多维表格（Bitable）操作工具。

  **当以下情况时使用此 Skill**：
  (1) 用户明确要求操作多维表格
  (2) 关键词："多维表格"、"表格"、"bitable"、"数据表"
  (3) 操作：创建、查询、新增、更新、删除记录

  **操作类型判断**：
  - 查询记录 → list
  - 新增记录 → create
  - 更新记录 → update
  - 删除记录 → delete
  - 批量操作 → batch_create/batch_update/batch_delete

  **参数说明**：
  - app_token: 多维表格应用ID（必填）
  - table_id: 数据表ID（必填）
  - action: 操作类型（list/create/update/delete）
  - record_id: 记录ID（update/delete时必填）
  - fields: 记录字段（create/update时必填）

  **ID 获取方式**：
  - 从表格URL：https://xxx.feishu.cn/base/app_token/workspace/table_id
  - 直接提供：app_token、table_id

  **NOT 使用此 Skill 的情况**：
  - 只是询问表格功能 → 不调用任何工具
  - 创建新多维表格应用 → 使用其他工具

  **API 参考**：https://open.feishu.cn/document/server-docs/bitable-v1/app-table-record/create
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, bitable, data]
  openclaw:
    emoji: 📊
    mcp_required: feishu-openclaw-plugin
---

# 飞书多维表格操作

## 操作类型识别

| 用户意图 | 操作类型 | 必填参数 |
|---------|---------|---------|
| 查看/查询记录 | list | app_token, table_id |
| 添加/新增记录 | create | app_token, table_id, fields |
| 更新/修改记录 | update | app_token, table_id, record_id, fields |
| 删除记录 | delete | app_token, table_id, record_id |

## 工具调用

### 查询记录（list）

**用户输入**：
```
查询表格 app_token 中 table_id 的所有记录
```

**API 调用**：
```json
{
  "action": "list",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx"
}
```

### 新增记录（create）

**用户输入**：
```
在表格中添加一行：
姓名：张三
状态：进行中
```

**API 调用**：
```json
{
  "action": "create",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "fields": {
    "姓名": "张三",
    "状态": "进行中"
  }
}
```

### 更新记录（update）

**用户输入**：
```
更新记录 record_xxx，将状态改为"已完成"
```

**API 调用**：
```json
{
  "action": "update",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "record_id": "rec_xxx",
  "fields": {
    "状态": "已完成"
  }
}
```

### 删除记录（delete）

**用户输入**：
```
删除记录 record_xxx
```

**API 调用**：
```json
{
  "action": "delete",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "record_id": "rec_xxx"
}
```

## 执行流程

### 1. 提取表格信息

从用户输入或URL中提取：

**URL 示例**：
```
https://xxx.feishu.cn/base/app_token/workspace/table_id
→ app_token: app_token
→ table_id: table_id
```

### 2. 识别操作类型

根据关键词判断：

| 关键词 | 操作 |
|--------|------|
| 查询、查看、获取、列表 | list |
| 添加、新增、创建、插入 | create |
| 更新、修改、编辑、改为 | update |
| 删除、移除 | delete |

### 3. 提取字段信息

从用户输入中提取字段和值：

**用户输入**：
```
添加一行：姓名"张三"，状态"进行中"
```

**提取结果**：
```json
{
  "姓名": "张三",
  "状态": "进行中"
}
```

### 4. 构建并执行API调用

## 常见场景

### 场景1：查询所有记录

**用户输入**：
```
查询表格的所有数据
```

**执行**：
```json
{
  "action": "list",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx"
}
```

### 场景2：条件查询

**用户输入**：
```
查询状态为"进行中"的记录
```

**执行**：
```json
{
  "action": "list",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "filter": {
    "conditions": [
      {
        "field_name": "状态",
        "operator": "is",
        "value": ["进行中"]
      }
    ]
  }
}
```

### 场景3：新增单条记录

**用户输入**：
```
在表格中添加：
姓名：张三
部门：技术部
状态：进行中
```

**执行**：
```json
{
  "action": "create",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "fields": {
    "姓名": "张三",
    "部门": "技术部",
    "状态": "进行中"
  }
}
```

### 场景4：批量新增

**用户输入**：
```
批量添加3行数据：
1. 张三，技术部，进行中
2. 李四，产品部，已完成
3. 王五，设计部，进行中
```

**执行**：
```json
{
  "action": "batch_create",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "records": [
    {
      "fields": {
        "姓名": "张三",
        "部门": "技术部",
        "状态": "进行中"
      }
    },
    {
      "fields": {
        "姓名": "李四",
        "部门": "产品部",
        "状态": "已完成"
      }
    },
    {
      "fields": {
        "姓名": "王五",
        "部门": "设计部",
        "状态": "进行中"
      }
    }
  ]
}
```

### 场景5：更新记录

**用户输入**：
```
将记录 rec_xxx 的状态改为"已完成"
```

**执行**：
```json
{
  "action": "update",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "record_id": "rec_xxx",
  "fields": {
    "状态": "已完成"
  }
}
```

### 场景6：删除记录

**用户输入**：
```
删除记录 rec_xxx
```

**执行**：
```json
{
  "action": "delete",
  "app_token": "app_xxx",
  "table_id": "tbl_xxx",
  "record_id": "rec_xxx"
}
```

## 字段类型说明

### 常见字段类型

| 类型 | 值格式 | 示例 |
|------|--------|------|
| 文本 | 字符串 | "张三" |
| 数字 | 数字 | 100 |
| 单选 | 字符串 | "进行中" |
| 多选 | 字符串数组 | ["选项1", "选项2"] |
| 日期 | 毫秒时间戳 | 1674206443000 |
| 人员 | 对象数组 | [{"id": "ou_xxx"}] |
| 复选框 | 布尔值 | true/false |

### 特殊字段处理

**人员字段**：
```json
{
  "负责人": [{"id": "ou_xxx"}]
}
```

**日期字段**：
```json
{
  "截止日期": 1674206443000
}
```

**多选字段**：
```json
{
  "标签": ["重要", "紧急"]
}
```

## 错误处理

### 错误1：app_token 或 table_id 无效

**处理**：
```
"表格ID不正确
正确格式：
- app_token: app_开头
- table_id: tbl_开头"
```

### 错误2：字段不存在

**处理**：
```
"字段不存在：XXX
请检查：
1. 字段名称是否正确
2. 是否在正确的表格中"
```

### 错误3：字段值类型错误

**处理**：
```
"字段值类型错误
字段：XXX
期望类型：文本
提供值：[...]
请提供正确的值类型"
```

### 错误4：record_id 不存在

**处理**：
```
"记录不存在：rec_xxx
请检查记录ID是否正确"
```

### 错误5：批量操作超限

**处理**：
```
"批量操作数量超过限制（最大500条）
请分批操作"
```

## 注意事项

1. **ID 格式**：
   - app_token: app_ 开头
   - table_id: tbl_ 开头
   - record_id: rec_ 开头

2. **字段名称**：使用表格中定义的字段名，包括空格

3. **批量限制**：单次最多 500 条记录

4. **并发限制**：同一表格不支持并发写

5. **权限要求**：需要表格的编辑权限

## 最佳实践

### 方式1：明确指定表格

```
用户：在表格 app_xxx 的 tbl_xxx 中添加记录

执行：直接使用提供的 ID
```

### 方式2：使用 URL

```
用户提供：https://xxx.feishu.cn/base/app_xxx/workspace/tbl_xxx

执行：从 URL 提取 app_token 和 table_id
```

### 方式3：先查询后操作

```
用户：将张三的状态改为"已完成"

执行：
1. 先查询找到张三的记录
2. 获取 record_id
3. 更新记录
```

## 相关 API 文档

- [新增记录 API](https://open.feishu.cn/document/server-docs/bitable-v1/app-table-record/create)
- [查询记录 API](https://open.feishu.cn/document/server-docs/bitable-v1/app-table-record/list)
- [更新记录 API](https://open.feishu.cn/document/server-docs/bitable-v1/app-table-record/update)
- [删除记录 API](https://open.feishu.cn/document/server-docs/bitable-v1/app-table-record/delete)

## 返回结果

### 查询成功

```json
{
  "code": 0,
  "data": {
    "items": [
      {
        "record_id": "rec_xxx",
        "fields": {
          "姓名": "张三",
          "状态": "进行中"
        }
      }
    ]
  }
}
```

### 新增成功

```json
{
  "code": 0,
  "data": {
    "record": {
      "record_id": "rec_xxx"
    }
  }
}
```

向用户确认：
```
✅ 操作成功
新增记录ID: rec_xxx
```

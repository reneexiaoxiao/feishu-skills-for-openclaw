---
name: feishu-update-doc
description: |
  更新已有的飞书云文档。

  **当以下情况时使用此 Skill**：
  (1) 用户明确要求更新/修改已有文档
  (2) 关键词："更新文档"、"修改文档"、"在文档中添加"、"编辑文档"
  (3) 提供文档标识和更新内容

  **更新模式**：
  - overwrite: 覆盖整个文档
  - append: 在文档末尾追加内容
  - insert_block: 在指定位置插入内容块

  **参数说明**：
  - document_id: 文档ID（doxcn开头，必填）
  - content: 更新的内容（必填）
  - mode: 更新模式（overwrite/append，默认append）
  - block_id: 插入位置（可选，仅insert_block模式）

  **文档标识来源**：
  - 文档URL：https://xxx.feishu.cn/docx/doxcnXXX
  - 直接提供：doxcnXXX

  **NOT 使用此 Skill 的情况**：
  - 创建新文档 → 使用 feishu-create-doc
  - 只读取文档 → 使用 feishu-fetch-doc
  - 只是询问如何更新 → 不调用任何工具

  **API 参考**：https://open.feishu.cn/document/server-docs/docs/docs-update
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, doc, update]
  openclaw:
    emoji: ✏️
    mcp_required: feishu-openclaw-plugin
---

# 飞书更新文档

## 工具调用

使用 `feishu_update_doc` 工具更新文档。

### 参数结构

```json
{
  "document_id": "doxcnXXX",
  "content": "新增的 Markdown 内容",
  "mode": "append"
}
```

### 参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| document_id | string | ✅ | 文档ID（doxcn开头） |
| content | string | ✅ | Markdown 格式的更新内容 |
| mode | string | ❌ | 更新模式（append/overwrite，默认append） |
| block_id | string | ❌ | 插入位置块ID（可选） |

## 更新模式

### 模式1：追加内容（默认）

**适用场景**：在文档末尾添加内容

**用户输入**：
```
在文档 doxcnXXX 末尾添加"更新日志"
```

**API 调用**：
```json
{
  "document_id": "doxcnXXX",
  "content": "## 更新日志\n\n- 2026-03-11: 完成初步设计",
  "mode": "append"
}
```

### 模式2：覆盖文档

**适用场景**：完全替换文档内容

**用户输入**：
```
将文档 doxcnXXX 的内容替换为"新内容"
```

**API 调用**：
```json
{
  "document_id": "doxcnXXX",
  "content": "新内容",
  "mode": "overwrite"
}
```

### 模式3：插入内容块

**适用场景**：在指定位置插入内容

**用户输入**：
```
在文档 doxcnXXX 的第3段后插入内容
```

**API 调用**：
```json
{
  "document_id": "doxcnXXX",
  "content": "插入的内容",
  "mode": "insert_block",
  "block_id": "block_xxx"
}
```

## 执行流程

### 1. 提取文档ID

从用户输入中提取文档ID：

**方式1：从URL提取**
```
用户：更新文档 https://xxx.feishu.cn/docx/doxcnXXX
→ 提取：doxcnXXX
```

**方式2：直接提供**
```
用户：更新文档 doxcnXXX
→ 直接使用：doxcnXXX
```

### 2. 确定更新模式

根据用户输入判断：

| 关键词 | 模式 |
|--------|------|
| 在末尾添加、追加 | append |
| 替换、覆盖、更新全部 | overwrite |
| 在...后插入 | insert_block |
| 未明确 | append（默认） |

### 3. 构建更新内容

将用户提供的内容转换为 Markdown 格式。

### 4. 调用更新工具

## 常见场景

### 场景1：追加段落

**用户输入**：
```
在文档末尾添加：
- 2026-03-11: 完成设计
- 2026-03-12: 开始开发
```

**执行**：
```json
{
  "document_id": "doxcnXXX",
  "content": "\n- 2026-03-11: 完成设计\n- 2026-03-12: 开始开发",
  "mode": "append"
}
```

### 场景2：追加章节

**用户输入**：
```
在文档 doxcnXXX 添加"下周计划"章节
```

**执行**：
```json
{
  "document_id": "doxcnXXX",
  "content": "\n## 下周计划\n\n1. 完成开发\n2. 开始测试",
  "mode": "append"
}
```

### 场景3：完全替换

**用户输入**：
```
把文档 doxcnXXX 的内容全部替换为"新版本说明"
```

**执行**：
```json
{
  "document_id": "doxcnXXX",
  "content": "新版本说明",
  "mode": "overwrite"
}
```

### 场景4：更新指定位置

**用户输入**：
```
在文档 doxcnXXX 的标题后插入一段说明
```

**执行**：
1. 读取文档找到标题块ID
2. 在该块后插入内容

## 错误处理

### 错误1：文档ID无效

**处理**：
```
"文档ID格式错误或文档不存在
正确格式：doxcnXXX（从文档URL获取）"
```

### 错误2：无权限编辑

**错误码**：99991403

**处理**：
```
"无权限编辑此文档
可能原因：
1. 不是文档创建者
2. 没有编辑权限
3. 文档已被锁定"
```

### 错误3：内容过大

**处理**：
```
"更新内容过大
建议：
1. 分段更新
2. 删除不必要的内容
3. 压缩内容大小"
```

### 错误4：Markdown 格式错误

**处理**：
```
"Markdown 格式有误，将尝试修复
如仍失败，请检查格式是否正确"
```

## 注意事项

1. **文档ID格式**：必须是 doxcn 开头的完整 ID
2. **编辑权限**：确保有文档的编辑权限
3. **内容大小**：单次更新不超过 1MB
4. **更新频率**：避免频繁更新同一文档
5. **Markdown 语法**：使用 Lark-flavored Markdown

## 最佳实践

### 方式1：明确指定模式

```
用户：在文档末尾追加内容

执行：mode = "append"
```

### 方式2：提供完整上下文

```
用户：在文档"会议纪要"中添加"决议"章节

执行：
1. 识别文档（可能需要搜索）
2. 添加章节内容
```

### 方式3：分段更新大文档

```
用户：更新文档，添加1000字内容

执行：
分多次更新，每次不超过500字
```

## 相关 API 文档

- [更新文档 API](https://open.feishu.cn/document/server-docs/docs/docs-update)
- [批量更新块 API](https://open.feishu.cn/document/server-docs/docs/batch-update-blocks)
- [文档块操作](https://open.feishu.cn/document/server-docs/docs/document-block/batch-update-blocks)

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
✅ 文档已更新
文档ID: doxcnXXX
更新模式: append
```


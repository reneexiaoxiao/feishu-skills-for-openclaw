---
name: feishu-create-doc
description: |
  创建新的飞书云文档。

  **当以下情况时使用此 Skill**：
  (1) 用户明确要求创建飞书文档
  (2) 关键词："创建文档"、"新建文档"、"创建飞书文档"
  (3) 提供文档标题和内容

  **参数说明**：
  - title: 文档标题（必填）
  - content: 文档内容（Markdown 格式，必填）
  - folder_token: 父文件夹 token（可选）
  - wiki_id: 知识库 ID（可选）

  **文档内容格式**：Lark-flavored Markdown

  **创建位置**：
  - 不指定位置 → 用户的个人空间根目录
  - folder_token → 指定文件夹下
  - wiki_id → 指定知识库中

  **NOT 使用此 Skill 的情况**：
  - 读取已有文档 → 使用 feishu-fetch-doc
  - 更新已有文档 → 使用 feishu-update-doc
  - 只是询问如何创建文档 → 不调用任何工具

  **API 参考**：https://open.feishu.cn/document/server-docs/docs/docs-create
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, doc, create]
  openclaw:
    emoji: 📄
    mcp_required: feishu-openclaw-plugin
---

# 飞书创建文档

## 工具调用

使用 `feishu_create_doc` 工具创建文档。

### 参数结构

```json
{
  "title": "文档标题",
  "content": "# Markdown 内容",
  "folder_token": "fld_xxx（可选）"
}
```

### 参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | string | ✅ | 文档标题 |
| content | string | ✅ | Markdown 格式的文档内容 |
| folder_token | string | ❌ | 父文件夹 token（可选） |

## Lark-flavored Markdown 格式

### 基础语法

```markdown
# 一级标题
## 二级标题
### 三级标题

**粗体文本**
*斜体文本*
~~删除线~~
`行内代码`

- 无序列表项
1. 有序列表项

[链接文字](https://example.com)
```

### 飞书扩展语法

#### 高亮块

```html
<callout emoji="💡" background-color="light-blue">
重要提示内容
</callout>
```

#### 表格

```markdown
| 列1 | 列2 | 列3 |
|-----|-----|-----|
| 内容1 | 内容2 | 内容3 |
```

#### 分栏

```html
<grid cols="2">
<column>
左栏内容
</column>
<column>
右栏内容
</column>
</grid>
```

## 执行流程

### 1. 提取文档信息

从用户输入中提取：
- 文档标题
- 文档内容
- 创建位置（可选）

**示例输入**：
```
创建一个飞书文档：
标题：项目计划
内容：
1. 需求分析
2. 开发
3. 测试
```

### 2. 构建 Markdown

将用户提供的结构转换为 Markdown 格式。

**示例输出**：
```markdown
# 项目计划

1. 需求分析
2. 开发
3. 测试
```

### 3. 调用创建工具

```json
{
  "title": "项目计划",
  "content": "# 项目计划\n\n1. 需求分析\n2. 开发\n3. 测试"
}
```

## 常见场景

### 场景1：简单文档

**用户输入**：
```
创建文档，标题是"会议纪要"，内容是"今天讨论了项目进度"
```

**执行**：
```json
{
  "title": "会议纪要",
  "content": "今天讨论了项目进度"
}
```

### 场景2：结构化文档

**用户输入**：
```
创建文档：
标题：项目计划
内容：
# 项目概述
这是一个新项目

## 目标
- 目标1
- 目标2
```

**执行**：
```json
{
  "title": "项目计划",
  "content": "# 项目概述\n这是一个新项目\n\n## 目标\n- 目标1\n- 目标2"
}
```

### 场景3：指定位置创建

**用户输入**：
```
在文件夹 fld_xxx 中创建文档"测试"
```

**执行**：
```json
{
  "title": "测试",
  "content": "",
  "folder_token": "fld_xxx"
}
```

### 场景4：复杂格式文档

**用户输入**：
```
创建项目文档，包含：
- 标题：飞书集成项目
- 高亮提示：重要项目
- 表格：任务分配
```

**构建内容**：
```markdown
# 飞书集成项目

<callout emoji="⚠️" background-color="light-yellow">
这是本季度的重点项目
</callout>

## 任务分配

| 任务 | 负责人 | 状态 |
|------|--------|------|
| API开发 | 张三 | 进行中 |
| 测试 | 李四 | 待开始 |
```

## 文档内容转换

### 从用户提供的信息转换

**用户提供**：
```
标题：周报
内容：
1. 本周完成：API开发
2. 下周计划：测试
```

**转换为 Markdown**：
```markdown
# 周报

## 本周完成
- API开发

## 下周计划
- 测试
```

### 智能格式化

根据用户意图自动添加标题、列表等格式。

## 错误处理

### 错误1：缺少标题

**处理**：
```
"请提供文档标题"
```

### 错误2：缺少内容

**处理**：
```
"请提供文档内容，或说明要创建空文档"
```

### 错误3：文件夹不存在

**处理**：
```
"文件夹不存在，请检查 folder_token：
或选择不指定位置（创建到个人空间）"
```

### 错误4：Markdown 格式错误

**处理**：
```
"Markdown 格式有误，将尝试修复。
常见问题：
- 未闭合的代码块
- 错误的列表嵌套
- 不支持的语法"
```

## 注意事项

1. **标题长度**：最长 100 个字符
2. **内容大小**：建议不超过 1MB
3. **Markdown 语法**：使用 Lark-flavored Markdown
4. **图片处理**：使用 URL 方式，系统自动上传
5. **特殊字符**：需要转义：`\ * ~ ` $ [ ] < > { } | ^`

## 最佳实践

### 方式1：简洁创建

```
用户：创建文档"测试"

执行：
创建空文档或默认内容文档
```

### 方式2：完整创建

```
用户：创建文档，标题是"项目计划"，内容是...

执行：
创建包含完整内容的文档
```

### 方式3：模板创建

```
用户：创建会议纪要模板

执行：
创建预定义格式的会议纪要文档
```

## 相关 API 文档

- [创建文档 API](https://open.feishu.cn/document/server-docs/docs/docs-create)
- [Lark-flavored Markdown](https://open.feishu.cn/document/ukTMukTMukTM/uAjLw4CM/larksuite-specific-markdown)
- [文档块类型](https://open.feishu.cn/document/common-capabilities/content-block/content-block-description)

## 返回结果

成功时返回：
```json
{
  "code": 0,
  "data": {
    "document": {
      "document_id": "doxcnXXX"
    }
  }
}
```

向用户确认：
```
✅ 文档已创建
文档ID: doxcnXXX
访问链接: https://xxx.feishu.cn/docx/doxcnXXX
```

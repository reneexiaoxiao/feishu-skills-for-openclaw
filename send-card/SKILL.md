---
name: feishu-send-card
description: |
  设计和发送飞书交互式卡片（Card JSON 2.0）。

  **🚨 最重要规则（必须遵守）**：
  - **直接返回卡片 JSON 代码块**，不要调用任何工具，不要发送纯文本回复！
  - 系统会自动检测你的 JSON 代码块并用机器人身份发送卡片
  - 如果你返回纯文本而不是 JSON 代码块，卡片将无法发送

  **核心作用**：让虾学会设计美观的卡片，并直接返回卡片JSON（系统会自动用机器人身份发送）。

  **使用场景**：
  - "发卡片"、"卡片消息"、"帮我设计个卡片"
  - 需要结构化展示：项目进展、任务分配、会议通知、数据报表等
  - 需要更丰富的展示形式（不仅是文本）
  - 需要带图片的卡片（先上传获取 img_key，再设计卡片）

  **重要说明（关键）**：
  - ✅ 直接返回卡片JSON作为文本回复
  - ✅ 系统会自动检测JSON并用机器人身份发送（不需要用户授权）
  - ✅ 必须使用 Card JSON 2.0 规范（schema: "2.0"）
  - ✅ 卡片需要图片时，先调用 feishu_upload_image 获取 img_key
  - ❌ 不要调用 feishu_im_user_message 工具（需要用户授权）
  - ❌ 不要调用任何其他发送工具

  **工作原理**：
  - 虾返回卡片JSON → 系统检测到JSON → 自动用机器人身份发送卡片

  **图片处理流程**：
  - 用户提供本地图片路径 → 虾调用 feishu_upload_image → 获取 img_key → 在卡片中使用

  **友好提示**：
  - 用户想要美观卡片 → 查看下方的"卡片设计原则"和"企业养虾攻略"案例
  - 用户不知道如何设计 → 引导使用飞书卡片搭建工具
  - 用户想要带图片的卡片 → 先上传图片获取 img_key，再设计卡片
metadata:
  version: 2.1.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, card, interactive, design-guide, image-upload]
  openclaw:
    emoji: 📋
    mcp_required: feishu-openclaw-plugin
  last_updated: 2026-03-12
---

# 飞书交互式卡片 - 设计与发送指南

## 🚀 快速速查表

> **最简卡片模板（Card JSON 2.0）**：
> ```json
> {
>   "schema": "2.0",
>   "config": {"update_multi": true},
>   "header": {
>     "title": {"tag": "plain_text", "content": "标题"},
>     "template": "blue"
>   },
>   "body": {
>     "elements": [
>       {"tag": "markdown", "content": "**内容**"}
>     ]
>   }
> }
> ```

**三步发送卡片**：
1. 设计卡片（遵循 Card JSON 2.0 规范）
2. 直接返回 JSON（不调用任何工具）
3. 系统自动检测并用机器人身份发送 ✅

---

## 🎯 技能定位

官方插件支持卡片消息，但**设计门槛高**。这个技能提供：
1. **设计指南**：教会虾设计美观的卡片（基于 Card JSON 2.0）
2. **自动发送**：直接返回卡片JSON，系统自动用机器人身份发送
3. **最佳实践**：实战案例和设计原则

**核心优势**：
- ✅ 不需要用户授权（用机器人身份）
- ✅ 不需要调用任何工具
- ✅ 直接返回卡片JSON即可自动发送
- ✅ 基于 Card JSON 2.0 最新规范

**工作流程**：
1. 用户要求："帮我设计个项目进展卡片"
2. 虾根据 Card JSON 2.0 规范设计卡片
3. 虾直接返回符合 2.0 规范的 JSON（不调用工具）
4. 系统检测到JSON，自动用机器人身份发送 ✅

---

## 📋 使用场景

### ✅ 适合用卡片的场景
- 项目进展汇报（带进度条、状态标签）
- 任务分配通知（带负责人、截止时间）
- 会议通知（带时间、地点、参会人）
- 数据报表（带图表、关键指标）
- 知识分享（带目录、章节、跳转链接）
- 审批流程（带按钮、表单）
- **AI 艺术作品展示**（带图片，先上传获取 img_key）
- **图文并茂的内容展示**（图片 + 文字说明）

### ❌ 不适合用卡片的场景
- 简单文本消息 → 使用 feishu-send-message
- 只是发送单张图片（不需要文字说明）→ 直接发送图片
- 只是询问如何发送卡片 → 只生成代码，不发送

---

## ⚠️ Card JSON 2.0 关键规则（必须遵守）

> **🚨 严重警告**：虾返回的卡片 JSON **必须**符合 2.0 规范，否则会发送失败！
>
> **最常见的错误**：使用了 1.0 的 `elements` 结构，忘记用 `body.elements`

### ✅ 必须遵守的规则：
1. ✅ **必须显式声明**：`"schema": "2.0"`
2. ✅ **elements 下沉到 body**：使用 `body.elements`（不再使用顶层 `elements`）
3. ✅ **config.update_multi 固定为 true**：`"config": {"update_multi": true}`
4. ❌ **不再支持**：`i18n_elements`（改用组件级 `i18n_content`）
5. ⚠️ **不支持的属性会报错**（2.0 不再忽略无效属性）
6. ⏰ **交互有效期统一为 14 天**

---

## 🔄 Card JSON 2.0 重要变更

### ⚠️ 旧写法（已废弃，会导致错误）
```json
❌ "elements": [...]              // 1.0 顶层 elements
❌ "size": "stretch_without_padding"  // 已废弃的通栏写法
❌ "[文字](url)"                 // 已废弃的链接语法
```

### ✅ 新写法（Card JSON 2.0）
```json
✅ "body": {"elements": [...]}    // 2.0 body.elements
✅ "margin": "4px -12px"          // 负 margin 实现通栏
✅ "<link href=\"url\">文字</link>"  // 新的链接标签
```

---

## 🎨 卡片设计核心流程（5步骤）

### 第1步：先定结构
信息层级 → 标题区 / 主体区 / 行动区

### 第2步：再定布局
- **单列为主**：大部分情况用单列
- **多列规则**：必要时用 `column_set` 做多列（不超过3列）
- **分隔章节**：用 `hr` 拆分不同主题

### 第3步：再定视觉
- **重点突出**：用背景块 `background_style` 与标签
- **避免满屏高亮**：颜色克制，只在重点区域使用
- **留白与间距**：统一 `padding`/`margin`/`vertical_spacing`

### 第4步：再加交互
- **按钮为主**：主要操作用按钮
- **链接为辅**：次要操作用文字链接
- **能跳转则跳转**：简单场景用 `open_url`
- **需回传再做回传**：审批/投票/表单等需要服务端接收的场景

### 第5步：最后校验
- 移动端预览
- 链接可用性
- 按钮文案明确

---

## 📐 设计原则（代码层面）

### 层级清晰
标题 > 关键数字/结论 > 说明/细节 > 行动

### 信息密度控制
- **一屏只讲 1 个主题**
- 用 `hr` 拆分章节
- 避免信息过载

### 对齐与间距统一
统一 `padding`/`margin`/`vertical_spacing`，保持视觉一致性

### 颜色克制
只在重点区域使用 `background_style`，不要全篇彩色

### 交互明确
按钮文案用动词：**查看/提交/报名/详情**

---

## 🎨 推荐卡片模板（通用结构）

### 标准静态卡片模板（Card JSON 2.0）
```json
{
  "schema": "2.0",
  "config": {"update_multi": true},
  "header": {
    "title": {"tag": "plain_text", "content": "主标题"},
    "subtitle": {"tag": "plain_text", "content": "副标题（可选）"},
    "text_tag_list": [
      {"tag": "text_tag", "text": {"tag": "plain_text", "content": "标签"}, "color": "blue"}
    ],
    "template": "blue"
  },
  "body": {
    "elements": [
      {"tag": "markdown", "content": "## 结论\n- 要点 1\n- 要点 2"},
      {"tag": "hr"},
      {
        "tag": "column_set",
        "flex_mode": "stretch",
        "columns": [
          {
            "tag": "column",
            "width": "weighted",
            "background_style": "blue-50",
            "elements": [
              {"tag": "markdown", "content": "**重点区块**\n说明文字"}
            ]
          }
        ]
      },
      {"tag": "hr"},
      {
        "tag": "button",
        "text": {"tag": "plain_text", "content": "查看详情"},
        "type": "primary_filled",
        "behaviors": [{"type": "open_url", "default_url": "https://example.com"}]
      }
    ]
  }
}
```

**2.0 关键要点**：
- ✅ 使用 `body.elements` 结构
- ✅ 按钮直接放在 elements 里（不需要 action 包装器）
- ✅ `config.update_multi` 固定为 true

---

## 🧩 关键组件速用规范

### 1. 标题区（header）

#### 📋 基础配置
- **必须配置**：`title`（主标题）
- **可选配置**：`subtitle`（副标题）、`text_tag_list`（标签）、`template`（主题色）、`icon`（图标）

#### 🎨 Header 主题色（template 可选值）

| 颜色 | 适用场景 | 情感色彩 |
|------|----------|----------|
| `blue` | 通用、信息类 | 专业、可信 |
| `purple` | 重要通知、公告 | 高级、尊贵 |
| `red` | 紧急、错误、警告 | 紧迫、重要 |
| `green` | 成功、完成 | 积极、成功 |
| `yellow` | 提醒、注意事项 | 警示、关注 |
| `grey` | 次要信息 | 低调、中性 |

#### 💡 最佳实践
```json
{
  "header": {
    "title": {"tag": "plain_text", "content": "主标题"},
    "subtitle": {"tag": "plain_text", "content": "副标题（可选）"},
    "text_tag_list": [
      {"tag": "text_tag", "text": {"tag": "plain_text", "content": "标签"}, "color": "blue"}
    ],
    "template": "blue",
    "icon": {
      "tag": "standard_icon",
      "token": "clock"  // 可选图标
    }
  }
}
```

### 2. Markdown 文本
**只用 3 类格式**：
- 标题：`## 标题`
- 加粗：`**加粗**`
- 列表：`- 列表项`

**颜色仅用于强调**，不要全篇彩色

### 3. 分栏布局（column_set）
- **用途**：关键指标并排、图文并排
- **规则**：列数不超过 3；移动端优先纵向堆叠
- **宽度**：`width: "weighted"`（自适应）或具体数值

### 4. 背景块（background_style）
**适用场景**：重点提示 / 结论摘要

#### 🎨 颜色速查表（background_style 可选值）

| 颜色值 | 色系 | 适用场景 | 示例 |
|--------|------|----------|------|
| `blue-50` | 蓝色 | 信息提示、常规内容 | 项目进展、数据展示 |
| `purple-50` | 紫色 | 重要提示、核心信息 | 关键结论、重要通知 |
| `violet-50` | 紫罗兰色 | 警告提示 | 注意事项、风险提示 |
| `green-50` | 绿色 | 成功提示 | 任务完成、成功状态 |
| `red-50` | 红色 | 错误提示 | 失败状态、错误信息 |
| `yellow-50` | 黄色 | 注意提示 | 待办事项、提醒 |
| `grey-50` | 灰色 | 次要信息 | 辅助说明、备注 |

**使用示例**：
```json
{
  "tag": "column_set",
  "columns": [
    {
      "tag": "column",
      "width": "weighted",
      "background_style": "blue-50",  // 蓝色背景
      "elements": [
        {"tag": "markdown", "content": "**重要信息**"}
      ]
    }
  ]
}
```

### 5. 图片（Card JSON 2.0 规范）

**基础图片**（推荐）：
```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "size": "crop_center"
}
```

**通栏效果**（2.0 推荐写法）：
```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "size": "crop_center",
  "margin": "4px -12px"
}
```

**2.0 重要变更**：
- ❌ 不再支持 `size: "stretch_without_padding"`（已废弃）
- ✅ 使用负 margin `"margin": "4px -12px"` 实现通栏视觉

**图片规范**：
- 建议尺寸：1500×3000 px 内
- 文件大小：< 10M
- 高宽比：不超过 16:9
- 圆角：`"corner_radius": "8px"`（可选）

#### 📤 如何获取 img_key

**重要**：卡片的 `img` 组件必须使用 `img_key`，不能直接使用图片 URL。

##### 方法 1：使用上传图片工具（推荐）

虾可以直接调用 `feishu_upload_image` 工具上传图片并获取 `img_key`。

**工作流程**：
```
1. 虾调用 feishu_upload_image 上传本地图片
2. 获取返回的 image_key（img_xxx 格式）
3. 在卡片的 img 组件中使用这个 image_key
4. 返回完整的卡片 JSON
```

**工具调用示例**：
```json
{
  "action": "upload",
  "image_path": "/path/to/local/image.png"
}
```

**返回结果**：
```json
{
  "image_key": "img_v3_0423xxxxx",
  "usage": "在卡片的 img 组件中使用此 image_key",
  "example": "{\"tag\":\"img\",\"img_key\":\"img_v3_0423xxxxx\",\"size\":\"crop_center\"}"
}
```

**完整示例**（先上传图片，再设计卡片）：
```json
// 步骤 1：上传图片
{
  "action": "upload",
  "image_path": "/Users/xxx/Downloads/ai-artwork.png"
}
// 返回：{"image_key": "img_v3_abc123"}

// 步骤 2：在卡片中使用 img_key
{
  "schema": "2.0",
  "config": {"update_multi": true},
  "header": {
    "title": {"tag": "plain_text", "content": "🎨 AI 艺术作品"},
    "template": "purple"
  },
  "body": {
    "elements": [
      {
        "tag": "img",
        "img_key": "img_v3_abc123",  // 使用上传后获取的 img_key
        "size": "crop_center"
      },
      {
        "tag": "markdown",
        "content": "**Gemini 生成的视觉艺术作品**\n\n- 抽象表现主义风格\n- 色彩大胆运用"
      }
    ]
  }
}
```

##### 方法 2：用户手动提供 img_key

如果用户已经在飞书中上传了图片，可以直接提供 `img_key`。

**获取方式**：
- 用户在飞书客户端发送图片
- 通过飞书开发者工具或 API 获取 `img_key`
- 用户把 `img_key` 告诉虾

##### ⚠️ 注意事项

- ❌ **不要**使用 URL 作为 `img_key` 的值（如 `"img_key": "https://example.com/image.jpg"`）
- ❌ **不要**编造 `img_key`（如 `"img_key": "img_fake_123"`）
- ✅ **必须**先上传图片获取真实的 `img_key`，再在卡片中使用
- ✅ 图片必须在本地文件系统中才能上传（虾不能直接从网络下载图片并上传）

---

### 6. 按钮（交互）

#### 🎨 按钮样式速查表

| 样式值 | 外观 | 适用场景 | 示例 |
|--------|------|----------|------|
| `primary_filled` | 蓝色填充 | 主要操作 | "提交"、"确认"、"查看详情" |
| `default` | 白色边框 | 次要操作 | "取消"、"返回"、"了解更多" |
| `danger` | 红色 | 危险操作 | "删除"、"拒绝"、"取消" |
| `primary_light` | 浅蓝色 | 辅助确认 | "标记为已读" |

#### 🔗 按钮跳转方式

**单端跳转**（PC 和移动端同一链接）：
```json
{
  "tag": "button",
  "text": {"tag": "plain_text", "content": "查看详情"},
  "type": "primary_filled",
  "behaviors": [{
    "type": "open_url",
    "default_url": "https://example.com"  // 所有端同一链接
  }]
}
```

**多端跳转**（PC、Android、iOS 不同链接）：
```json
{
  "tag": "button",
  "text": {"tag": "plain_text", "content": "打开应用"},
  "type": "primary_filled",
  "behaviors": [{
    "type": "open_url",
    "multi_url": {
      "pc": "https://pc.example.com",
      "android": "https://android.example.com",
      "ios": "https://ios.example.com"
    }
  }]
}
```

#### 💡 最佳实践
- 一个卡片不超过 3 个按钮
- 主要操作用 `primary_filled`
- 按钮文案用动词：**查看/提交/报名/详情**

---

## 🏗️ 卡片结构详解

### Header（标题区域）
```json
{
  "header": {
    "title": {
      "tag": "plain_text",
      "content": "卡片标题"
    },
    "subtitle": {
      "tag": "plain_text",
      "content": "副标题（可选）"
    },
    "text_tag_list": [
      {
        "tag": "text_tag",
        "text": {
          "tag": "plain_text",
          "content": "标签文字"
        },
        "color": "blue"
      }
    ],
    "template": "blue",
    "padding": "12px 12px 12px 12px"
  }
}
```

**说明：**
- `title`：主标题（必填）
- `subtitle`：副标题（可选）
- `text_tag_list`：标签列表（可选）
- `template`：颜色主题（blue/purple/red/green/yellow/grey）

---

### Body（内容区域）元素

#### 1. 图片元素
```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "scale_type": "fit_horizontal",
  "corner_radius": "8px"
}
```

#### 2. Markdown 文本
```json
{
  "tag": "markdown",
  "content": "## 标题\n\n正文内容"
}
```

**支持的 Markdown 语法：**
- 标题：`## 标题`
- 加粗：`**加粗**`
- 颜色：`<font color='blue'>蓝色文字</font>`
- 列表：`- 列表项`
- 引用：`> 引用内容`

**Card JSON 2.0 链接语法变更**：
- ❌ 旧写法：`[文字](url)` 差异化跳转（已废弃）
- ✅ 新写法：使用 `<link></link>` 标签
```json
{"tag": "markdown", "content": "请查看 <link href=\"https://example.com\">详情</link>"}
```

#### 3. 彩色背景块
```json
{
  "tag": "column_set",
  "columns": [
    {
      "tag": "column",
      "width": "weighted",
      "background_style": "blue-50",
      "elements": [
        {
          "tag": "markdown",
          "content": "**重点内容**"
        }
      ]
    }
  ]
}
```

#### 4. 按钮
```json
{
  "tag": "button",
  "text": {
    "tag": "plain_text",
    "content": "按钮文字"
  },
  "type": "primary_filled",
  "behaviors": [
    {
      "type": "open_url",
      "default_url": "https://example.com"
    }
  ]
}
```

**按钮样式：**
- `primary_filled`：主要按钮（蓝色填充）
- `default`：默认按钮（白色边框）
- `danger`：危险按钮（红色）

---

## 📚 快速示例

### 简单卡片示例（Card JSON 2.0）
```json
{
  "schema": "2.0",
  "config": {"update_multi": true},
  "header": {
    "title": {"tag": "plain_text", "content": "📊 项目进展"},
    "template": "blue"
  },
  "body": {
    "elements": [
      {
        "tag": "markdown",
        "content": "**进度**: 80%\\n**状态**: 正常"
      }
    ]
  }
}
```

**说明**：
- ✅ 必须声明 `"schema": "2.0"`
- ✅ 使用 `body.elements` 结构
- ✅ `config.update_multi` 固定为 `true`

---

## ❌ 常见错误与解决方案

### 错误 1：忘记声明 schema
```json
❌ {
  "config": {"update_multi": true},
  "header": {...}
}
```

**问题**：系统默认按 1.0 处理，可能导致发送失败

**解决方案**：
```json
✅ {
  "schema": "2.0",  // 必须显式声明
  "config": {"update_multi": true},
  "header": {...}
}
```

---

### 错误 2：使用顶层 elements
```json
❌ {
  "schema": "2.0",
  "elements": [...]  // 1.0 写法，会报错
}
```

**问题**：Card JSON 2.0 不再支持顶层 `elements`

**解决方案**：
```json
✅ {
  "schema": "2.0",
  "body": {
    "elements": [...]  // 2.0 正确写法
  }
}
```

---

### 错误 3：使用已废弃的图片通栏写法
```json
❌ {
  "tag": "img",
  "img_key": "img_v3_xxx",
  "size": "stretch_without_padding"  // 已废弃
}
```

**问题**：`stretch_without_padding` 在 2.0 中已移除

**解决方案**：
```json
✅ {
  "tag": "img",
  "img_key": "img_v3_xxx",
  "size": "crop_center",
  "margin": "4px -12px"  // 用负 margin 实现通栏
}
```

---

### 错误 4：使用旧的 Markdown 链接语法
```json
❌ {"tag": "markdown", "content": "请查看[详情](https://example.com)"}
```

**问题**：差异化跳转语法已废弃

**解决方案**：
```json
✅ {"tag": "markdown", "content": "请查看<link href=\"https://example.com\">详情</link>"}
```

---

### 错误 5：过度使用颜色
```json
❌ {
  "tag": "markdown",
  "content": "<font color='red'>红色</font><font color='blue'>蓝色</font><font color='green'>绿色</font>"
}
```

**问题**：颜色过多，视觉混乱

**解决方案**：
```json
✅ {
  "tag": "column_set",
  "columns": [{
    "tag": "column",
    "width": "weighted",
    "background_style": "red-50",  // 用背景块整体强调
    "elements": [
      {"tag": "markdown", "content": "**重要提示**\n只在重点区域使用颜色"}
    ]
  }]
}
```

---

## 🏆 实战案例：企业养虾攻略卡片

**来源**：`/Users/bytedance/Downloads/企业养虾攻略：从白虾到好虾的新手村指南.card`

### 卡片亮点

✅ **顶部图片** - 吸引注意力  
✅ **彩色背景块** - blue-50、violet-50、purple-50 分层突出重点  
✅ **清晰章节** - 使用 hr 分割线分隔 5 个大章节  
✅ **丰富内容** - markdown、引用块、代码块、清单、FAQ  
✅ **多按钮** - 两个按钮引导用户查看完整攻略和加群  
✅ **视觉一致** - 统一的蓝色主题，渐进式信息呈现  

### 设计要点

**1. 信息层次**
- 顶部图片 → 背景提示 → 核心章节 → 实践清单 → 常见问题 → 行动按钮

**2. 视觉节奏**
- 图片吸引 → 蓝色强调 → 紫色警告 → 内容展示 → 分割线分隔

**3. 内容密度**
- 每个章节聚焦一个主题
- 使用清单、引用、代码块打破大段文字
- 重要信息放在彩色背景块中

**4. 行动引导**
- 底部两个按钮：查看完整攻略 + 加入交流群

**5. 实用性**
- 基于 OpenClaw 实战经验总结
- 包含具体操作步骤和配置示例
- 清单形式便于执行检查

---

## 🔗 交互设计（必须区分）

### 跳转交互（简单场景）
**按钮/文字链 → URL**

**适用场景**：
- 查看详情
- 打开文档
- 跳转网页

**实现方式**：
```json
{
  "tag": "button",
  "text": {"tag": "plain_text", "content": "查看详情"},
  "type": "primary_filled",
  "behaviors": [{"type": "open_url", "default_url": "https://example.com"}]
}
```

### 回传交互（复杂场景）
**需要服务端接收回调**

**适用场景**：
- 审批流程
- 投票问卷
- 表单提交
- 状态更新

**注意**：回传交互需要服务端支持，不适合直接返回 JSON 的场景

---

## ✅ 代码质检清单（发送前必查）

> **在返回卡片 JSON 之前，请逐项检查以下内容**：

### 🔴 Card JSON 2.0 核心检查（必须全部通过）

| 检查项 | 要求 | 检查方法 |
|--------|------|----------|
| Schema 声明 | `"schema": "2.0"` 必须存在 | 搜索 `"schema"` |
| Body 结构 | 使用 `body.elements`，不是顶层 `elements` | 搜索 `"elements"` 位置 |
| Config 配置 | `"config": {"update_multi": true}` | 搜索 `"config"` |
| 废弃属性 | 不使用 `i18n_elements`、`stretch_without_padding` | 全文搜索废弃属性 |

### 🟡 设计质量检查（推荐通过）

| 检查项 | 标准 | 检查方法 |
|--------|------|----------|
| 标题清晰 | 一目了然，1屏1主题 | 读取 `header.title.content` |
| 信息层次 | 结论先行，长文分段 | 查看 markdown 内容结构 |
| 颜色克制 | 主色不超过2种 | 统计 `background_style` 使用次数 |
| 按钮文案 | 动词+目标（"查看详情"、"提交申请"） | 检查所有 `button.text.content` |
| 链接可用 | URL可访问，移动端可读 | 测试 `open_url.default_url` |
| 间距统一 | padding/margin/vertical_spacing 一致 | 检查样式属性 |
| 移动端友好 | 考虑小屏幕显示效果 | 思考移动端展示效果 |

### 🟢 发送前最后确认
- [ ] JSON 格式正确（无语法错误）
- [ ] 所有必需字段都已填写
- [ ] 没有使用废弃的 1.0 语法
- [ ] 链接都已测试可用
- [ ] 按钮文案清晰明确

---

## 🛠️ 卡片搭建工具

**官方工具**：https://open.feishu.cn/tool/cardbuilder

可视化搭建卡片，支持：
- 拖拽式设计
- 实时预览
- JSON 导出
- 多种模板

---

## 💡 最佳实践与实操建议

### 1. 内容优先
- 先确定要传达的信息
- 再选择合适的卡片样式
- 不要为了炫技而过度设计

### 2. 保持简洁
- 一个卡片聚焦一个主题
- 避免信息过载
- 重要信息放在前面

### 3. 视觉一致
- 同类卡片使用统一风格
- 颜色使用有规律
- 排版保持一致

### 4. 测试验证
- 在不同设备上测试（PC、手机）
- 检查链接是否有效
- 确认文字是否清晰

### 5. 实操建议
- **优先用可视化工具**：用飞书卡片搭建工具（https://open.feishu.cn/tool/cardbuilder）拖拽设计后复制 JSON
- **需要高一致性时**：统一用模板卡片 + 变量
- **渐进式设计**：先做基础版本，再逐步优化视觉和交互

---

## 📖 学习资源

### 官方文档
- 飞书卡片搭建工具：https://open.feishu.cn/tool/cardbuilder
- 卡片开发指南：https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/feishu-card-overview

### 参考案例
- 企业养虾攻略卡片（见 `/Users/bytedance/Downloads/企业养虾攻略：从白虾到好虾的新手村指南.card`）

---

**最后更新：** 2026-03-12
**下次审查：** 2026-04-12

---
name: feishu-send-card
description: |
  设计和发送飞书交互式卡片（Card JSON 1.0）。

  **核心作用**：让虾学会设计美观的卡片，并直接返回卡片JSON（系统会自动用机器人身份发送）。

  **使用场景**：
  - "发卡片"、"卡片消息"、"帮我设计个卡片"
  - 需要结构化展示：项目进展、任务分配、会议通知、数据报表等
  - 需要更丰富的展示形式（不仅是文本）
  - 需要带图片的卡片（先上传获取 img_key，再设计卡片）

  **重要说明（关键）**：
  - ✅ 使用 **Card JSON 1.0** 格式（顶层 `elements`）
  - ✅ 直接返回卡片 JSON 代码块，不要调用任何工具
  - ✅ 系统会自动检测 JSON 并用机器人身份发送卡片
  - ✅ 卡片需要图片时，先调用 feishu_upload_image 获取 img_key
  - ❌ 不要调用 feishu_im_user_message 工具（需要用户授权）
  - ❌ 不要调用任何其他发送工具

  **工作原理**：
  - 虾返回卡片 JSON → 系统检测到 JSON → 自动用机器人身份发送卡片

  **图片处理流程**：
  - 用户提供本地图片路径 → 虾调用 feishu_upload_image → 获取 img_key → 在卡片中使用

  **友好提示**：
  - 用户想要美观卡片 → 查看下方的"卡片设计原则"和"企业养虾攻略"案例
  - 用户不知道如何设计 → 引导使用飞书卡片搭建工具
metadata:
  version: 1.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, card, interactive, design-guide]
  openclaw:
    emoji: 📋
    mcp_required: feishu-openclaw-plugin
  last_updated: 2026-03-12
---

# 飞书交互式卡片 - 设计与发送指南（Card JSON 1.0）

## 🎯 技能定位

官方插件支持卡片消息，但**设计门槛高**。这个技能提供：
1. **设计指南**：教会虾设计美观的卡片（基于 Card JSON 1.0）
2. **自动发送**：直接返回卡片JSON，系统自动用机器人身份发送
3. **最佳实践**：实战案例和设计原则

**核心优势**：
- ✅ 不需要用户授权（用机器人身份）
- ✅ 不需要调用任何工具
- ✅ 直接返回卡片JSON即可自动发送
- ✅ 基于 Card JSON 1.0（更灵活、布局可控）

**为什么用 1.0 而不是 2.0**：
- ✅ 1.0 支持 `column_set` 的 `padding` 和 `vertical_spacing`（内容不挤在一起）
- ✅ 1.0 图片用 `scale_type`（更可靠）
- ✅ 1.0 布局更灵活、可控
- ❌ 2.0 对 `column_set` 限制太多，容易导致内容挤在一起

**工作流程**：
1. 用户要求："帮我设计个项目进展卡片"
2. 虾根据 Card JSON 1.0 规范设计卡片
3. 虾直接返回符合 1.0 规范的 JSON（不调用工具）
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

## 🎨 卡片设计核心流程（5步骤）

### 第1步：先定结构
信息层级 → 标题区 / 主体区 / 行动区

### 第2步：再定布局
- **单列为主**：大部分情况用单列
- **多列规则**：必要时用 `column_set` 做多列（不超过3列）
  - ✅ 必须设置 `flex_mode: "stretch"`（让列占满宽度）
  - ✅ `column` 必须设置 `padding`（避免内容挤在一起）
  - ✅ `column` 可以设置 `vertical_spacing`（元素间距）
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

## 🎨 推荐卡片模板（Card JSON 1.0）

### 标准卡片模板

```json
{
  "config": {
    "wide_screen_mode": true
  },
  "header": {
    "title": {
      "tag": "plain_text",
      "content": "主标题"
    },
    "subtitle": {
      "tag": "plain_text",
      "content": "副标题（可选）"
    },
    "template": "blue"
  },
  "elements": [
    {
      "tag": "markdown",
      "content": "## 结论\n- 要点 1\n- 要点 2"
    },
    {
      "tag": "hr"
    },
    {
      "tag": "column_set",
      "flex_mode": "stretch",
      "horizontal_spacing": "12px",
      "columns": [
        {
          "tag": "column",
          "width": "weighted",
          "padding": "12px 12px 12px 12px",
          "vertical_spacing": "8px",
          "background_style": "blue-50",
          "elements": [
            {
              "tag": "markdown",
              "content": "**重点区块**\n说明文字"
            }
          ]
        }
      ]
    },
    {
      "tag": "hr"
    },
    {
      "tag": "action",
      "actions": [
        {
          "tag": "button",
          "text": {
            "tag": "plain_text",
            "content": "查看详情"
          },
          "type": "primary",
          "url": "https://example.com"
        }
      ]
    }
  ]
}
```

**1.0 关键要点**：
- ✅ 使用顶层 `elements` 结构
- ✅ `column_set` 可以设置 `padding` 和 `vertical_spacing`
- ✅ 图片用 `scale_type` 而不是 `size`
- ✅ 按钮放在 `action` 容器的 `actions` 数组里

---

## 🧩 关键组件速用规范

### 1. 标题区（header）

**建议配置**：主标题 + 副标题 + 主题色（template）

**可选配置**：
- `template`：颜色主题（blue/purple/red/green/yellow/grey）
- `icon`：图标（`standard_icon` 或 `img_key`）

**颜色主题**：
- `blue` - 通用、信息类
- `purple` - 重要通知、公告
- `red` - 紧急、错误、警告
- `green` - 成功、完成
- `yellow` - 提醒、注意事项
- `grey` - 次要信息

### 2. Markdown 文本

**只用 3 类格式**：
- 标题：`## 标题`
- 加粗：`**加粗**`
- 列表：`- 列表项`

**颜色仅用于强调**，不要全篇彩色

### 3. 分栏布局（column_set）

**用途**：关键指标并排、图文并排

**关键规则**（防止内容挤在一起）：
1. ✅ **必须设置** `flex_mode: "stretch"`（让列占满宽度）
2. ✅ **`column` 必须设置** `padding`（如 `"12px 12px 12px 12px"`）
3. ✅ **`column` 可以设置** `vertical_spacing`（如 `"8px"`）
4. ✅ `column_set` 可以设置 `horizontal_spacing`（两栏间距）

**完整示例**：
```json
{
  "tag": "column_set",
  "flex_mode": "stretch",
  "horizontal_spacing": "12px",
  "columns": [
    {
      "tag": "column",
      "width": "weighted",
      "padding": "12px 12px 12px 12px",
      "vertical_spacing": "8px",
      "background_style": "blue-50",
      "elements": [
        {"tag": "markdown", "content": "**左侧**\n内容"}
      ]
    },
    {
      "tag": "column",
      "width": "weighted",
      "padding": "12px 12px 12px 12px",
      "vertical_spacing": "8px",
      "background_style": "purple-50",
      "elements": [
        {"tag": "markdown", "content": "**右侧**\n内容"}
      ]
    }
  ]
}
```

### 4. 背景块（background_style）

**适用场景**：重点提示 / 结论摘要

**可选值**：
- `blue-50` - 蓝色（信息提示）
- `purple-50` - 紫色（重要提示）
- `violet-50` - 紫罗兰色（警告提示）
- `green-50` - 绿色（成功提示）
- `red-50` - 红色（错误提示）
- `yellow-50` - 黄色（注意提示）
- `grey-50` - 灰色（次要信息）

### 5. 图片（Card JSON 1.0）

**基础图片**：
```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "scale_type": "fit_horizontal"
}
```

**通栏效果**：
```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "scale_type": "fit_horizontal",
  "mode": "fit_horizontal"
}
```

**图片规范**：
- 建议尺寸：1500×3000 px 内
- 文件大小：< 10M
- 高宽比：不超过 16:9

### 6. 按钮（交互）

**样式**：
- `primary` - 主要按钮（蓝色）
- `default` - 默认按钮（白色）
- `danger` - 危险按钮（红色）

**跳转**：
- `url`：单端跳转
- `multi_url`：多端跳转（pc/android/ios 分别配置）

**示例**：
```json
{
  "tag": "action",
  "actions": [
    {
      "tag": "button",
      "text": {
        "tag": "plain_text",
        "content": "查看详情"
      },
      "type": "primary",
      "url": "https://example.com"
    }
  ]
}
```

---

## 📚 快速示例

### 简单卡片

```json
{
  "config": {"wide_screen_mode": true},
  "header": {
    "title": {"content": "📊 项目进展", "tag": "plain_text"},
    "template": "blue"
  },
  "elements": [
    {
      "tag": "markdown",
      "content": "**进度**: 80%\n\n**状态**: 正常"
    }
  ]
}
```

---

## 🏆 实战案例：企业养虾攻略卡片

**来源**：`/Users/bytedance/Downloads/企业养虾攻略：从白虾到好虾的新手村指南.card`

### 卡片亮点

✅ **顶部图片** - 吸引注意力
✅ **彩色背景块** - blue-50、violet-50、purple-50 分层突出重点
✅ **清晰章节** - 使用 hr 分割线分隔多个大章节
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

## 📤 如何获取 img_key

### 场景 1：图片已经在消息里（推荐方式）

**用户操作**：直接在对话中发送图片

**虾的处理流程**：
```
1. 检查对话上下文是否有图片消息
2. 从消息体中提取 img_key
3. 在卡片的 img 组件中使用这个 img_key
4. 返回完整的卡片 JSON
```

**获取方式**：
- 消息体本身包含 `img_key`
- 可以通过读取消息内容直接获取
- 格式：`message.content` 或消息的 `msg_type: "image"` 字段

**完整示例**：
```
用户：[发送一张图片]

用户：用这张图片发个卡片

虾的内部处理：
1. 检测到对话中的图片消息
2. 提取 img_key: "img_v3_abc123"
3. 设计卡片并使用这个 img_key
4. 返回：
{
  "config": {"wide_screen_mode": true},
  "header": {
    "title": {"tag": "plain_text", "content": "图片展示"},
    "template": "blue"
  },
  "elements": [
    {
      "tag": "img",
      "img_key": "img_v3_abc123",
      "scale_type": "fit_horizontal"
    },
    {
      "tag": "markdown",
      "content": "**说明文字**"
    }
  ]
}
```

---

### 场景 2：图片不在消息里（需要用户提供）

**情况 A：用户提供了本地文件路径**

**虾的处理流程**：
```
1. 调用 feishu_upload_image 工具上传图片
2. 获取返回的 image_key
3. 在卡片中使用这个 img_key
```

**工具调用**：
```json
{
  "action": "upload",
  "image_path": "/Users/xxx/Downloads/image.png"
}
```

**返回结果**：
```json
{
  "image_key": "img_v3_xxx",
  "usage": "在卡片的 img 组件中使用此 image_key"
}
```

---

**情况 B：用户没有提供图片**

**虾的友好提示**：
```
我需要图片才能发送带图片的卡片。请：

**方式 1（推荐）**：直接在对话中发送图片
- 在这个聊天里直接上传图片
- 然后告诉我"用这张图片发个卡片"

**方式 2**：提供本地图片路径
- 确保图片在本地文件系统中
- 告诉我图片的完整路径，如：/Users/xxx/Downloads/image.png
```

**为什么推荐直接发图片？**
- ✅ 不需要手动查找文件路径
- ✅ 不需要关心图片在哪里
- ✅ 系统自动提取 img_key
- ✅ 用户体验最好

---

### 📸 图片处理完整流程

#### 流程图

```
用户说"用图片发个卡片"
  ↓
虾检查：对话中是否有图片？
  ↓
  ├─ 有图片 → 提取 img_key → 设计卡片 → 返回 JSON ✅
  │
  └─ 没有图片 → 提示用户：
                  "请先发送图片，或提供图片路径"
      ↓
  用户发送图片
      ↓
  虾提取 img_key → 设计卡片 → 返回 JSON ✅
```

---

### ⚠️ 重要注意事项

**不要做的事情**：
- ❌ 不要使用图片 URL 作为 `img_key`
- ❌ 不要编造 `img_key`（如 `img_fake_123`）
- ❌ 不要在用户没提供图片时自己假设图片路径

**应该做的事情**：
- ✅ 检查对话中是否有图片消息
- ✅ 从消息体中提取真实的 `img_key`
- ✅ 如果没有图片，友好地提示用户提供
- ✅ 提示用户"直接在对话中发送图片"（最简单）

---

## 📝 实战经验教训（2026-03-12）

### 关键规则：padding 和 vertical_spacing 的正确位置

**❌ 错误：在 column_set 上设置**
```json
{
  "tag": "column_set",
  "padding": "12px 12px",  // ❌ column_set 不支持
  "vertical_spacing": "8px",  // ❌ column_set 不支持
  "horizontal_spacing": "12px"  // ✅ column_set 支持
}
```

**✅ 正确：在 column 上设置**
```json
{
  "tag": "column_set",
  "flex_mode": "stretch",
  "horizontal_spacing": "12px",
  "columns": [
    {
      "tag": "column",
      "width": "weighted",
      "padding": "12px 12px 12px 12px",  // ✅ column 支持
      "vertical_spacing": "8px",  // ✅ column 支持
      "background_style": "blue-50",
      "elements": [...]
    }
  ]
}
```

**防止内容挤在一起的三个关键**：
1. ✅ `column_set.flex_mode = "stretch"` - 让列占满宽度
2. ✅ `column.padding` - 设置内边距（如 `"12px 12px 12px 12px"`）
3. ✅ `column.vertical_spacing` - 设置元素间距（如 `"8px"`）

### markdown 换行规则

**关键规则**：
- 单个 `\n` = 软换行（可能被压缩）
- 双个 `\n\n` = 硬换行（段落分隔）
- 要让内容不挤，必须用 `\n\n` 分段

**正确示例**：
```json
{
  "tag": "markdown",
  "content": "**部署方式**\n\n本地部署\n\n**运维成本**\n\n需自行运维"
}
```

### 图片的 scale_type vs size

**Card JSON 1.0 使用**：
- ✅ `scale_type`: "fit_horizontal"（推荐）
- ✅ `scale_type`: "crop_center"
- ✅ `scale_type`: "stretch"

**Card JSON 2.0 使用**：
- ✅ `size`: "crop_center"
- ❌ `size`: "stretch_without_padding"（已废弃）

**推荐**：使用 Card JSON 1.0 的 `scale_type`

---

## ✅ 代码质检清单（发送前必查）

在返回卡片 JSON 之前，确保：

### Card JSON 1.0 核心检查（必须通过）
- [ ] **顶层 elements 结构**：使用 `elements`，不是 `body.elements`
- [ ] **column_set 配置**：设置 `flex_mode: "stretch"`
- [ ] **column 配置**：设置 `padding` 和 `vertical_spacing`
- [ ] **图片使用** `scale_type` 而不是 `size`

### 设计质量检查
- [ ] **标题清晰**：一目了然，1屏1主题
- [ ] **重要信息在前**：结论先行，长文分段
- [ ] **颜色克制**：主色不超过2种
- [ ] **按钮文案明确**：动词+目标（如"查看详情"、"提交申请"）
- [ ] **链接可用**：URL可访问，移动端可读
- [ ] **间距统一**：padding/margin/vertical_spacing 一致
- [ ] **移动端友好**：考虑小屏幕显示效果

---

**最后更新：** 2026-03-12
**下次审查：** 遇到新的卡片问题时补充

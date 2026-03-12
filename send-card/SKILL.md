---
name: feishu-send-card
description: |
  向飞书群聊或私聊发送交互式卡片。

  **核心作用（第3点）**：官方插件支持但门槛较高，让虾学会发送美观的卡片并获取设计指南。

  **使用场景**：
  - "发卡片"、"卡片消息"
  - 需要结构化展示：项目进展、任务分配、会议通知、数据报表等
  - 需要更丰富的展示形式（不仅是文本）

  **调用工具**：feishu_im_user_message (来自 @larksuite/openclaw-lark 官方插件)
  **关键参数**：msg_type="interactive"，content 为卡片 JSON

  **友好提示**：
  - 用户想要美观卡片 → 查看下方的"卡片设计原则"和"企业养虾攻略"案例
  - 用户不知道如何设计 → 引导使用飞书卡片搭建工具

  **特殊说明**：这是高门槛能力，skill 中包含完整的设计指南和实战案例
metadata:
  version: 2.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, card, interactive, design-guide]
  openclaw:
    emoji: 📋
    mcp_required: feishu-openclaw-plugin
  last_updated: 2026-03-12
---

# 飞书发送卡片消息 - 设计指南

## 🎯 技能定位

官方插件支持发送卡片，但**设计门槛高**。这个技能提供：
1. 路由：识别用户想发卡片的意图
2. 设计指南：教会虾发送美观的卡片
3. 最佳实践：实战案例和设计原则

---

## 📋 使用场景

### ✅ 适合用卡片的场景
- 项目进展汇报（带进度条、状态标签）
- 任务分配通知（带负责人、截止时间）
- 会议通知（带时间、地点、参会人）
- 数据报表（带图表、关键指标）
- 知识分享（带目录、章节、跳转链接）
- 审批流程（带按钮、表单）

### ❌ 不适合用卡片的场景
- 简单文本消息 → 使用 feishu-send-message
- 纯图片 → 使用 feishu-send-image
- 只是询问如何发送卡片 → 不调用任何工具

---

## 🎨 卡片设计原则

### 1. 视觉层次清晰
- **顶部图片**：吸引注意力（可选）
- **标题区域**：Header 部分，包含标题、副标题、标签
- **内容区域**：Body 部分，分章节展示
- **行动区域**：底部按钮，引导用户操作

### 2. 颜色使用规范
飞书卡片支持的背景色：
- `blue-50` - 蓝色（信息提示）
- `purple-50` - 紫色（重要提示）
- `violet-50` - 紫罗兰色（警告提示）
- `green-50` - 绿色（成功提示）
- `red-50` - 红色（错误提示）
- `yellow-50` - 黄色（注意提示）
- `grey-50` - 灰色（次要信息）

### 3. 排版技巧
- **分割线**：用 `{"tag": "hr"}` 分隔章节
- **多列布局**：用 `column_set` + `column` 创建并列内容
- **背景块**：用 `background_style` 突出重点内容
- **间距控制**：用 `margin`、`padding`、`vertical_spacing` 调整间距

### 4. 内容组织
- **先说结论**：重要信息放在前面
- **分层展示**：用标题、列表、引用等结构化内容
- **适度留白**：不要塞太满，保持呼吸感
- **行动明确**：底部按钮清晰指引下一步

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

### 简单卡片
```json
{
  "config": {"update_multi": true},
  "header": {
    "title": {"content": "📊 项目进展", "tag": "plain_text"},
    "template": "blue"
  },
  "elements": [
    {
      "tag": "markdown",
      "content": "**进度**: 80%\\n**状态**: 正常"
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

## 🛠️ 卡片搭建工具

**官方工具**：https://open.feishu.cn/tool/cardbuilder

可视化搭建卡片，支持：
- 拖拽式设计
- 实时预览
- JSON 导出
- 多种模板

---

## 💡 最佳实践

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

---
name: feishu-send-card
description: |
  向飞书群聊或私聊发送交互式卡片消息。
  
  **当以下情况时使用此 Skill**：
  (1) 用户明确要求发送卡片到群聊或私聊
  (2) 关键词："发送卡片"、"发卡片"、"card"、"卡片消息"
  (3) 需要发送结构化信息（项目进展、任务分配、会议通知等）
  (4) 需要更丰富的展示形式（不仅是文本）
  
metadata:
  version: 2.0.0
  author: 晓晓 (Xiaoxiao)
  tags: [feishu, card, interactive]
  openclaw:
    emoji: 📋
    mcp_required: feishu-openclaw-plugin
  last_updated: 2026-03-12
---

# 飞书发送卡片消息 Skill

## 概述

向飞书群聊或私聊发送交互式卡片消息。使用 `feishu_im_user_message` 工具，设置 `msg_type="interactive"`。

---

## 使用场景

### ✅ 适合用卡片的场景
- 项目进展汇报（带进度条、状态标签）
- 任务分配通知（带负责人、截止时间）
- 会议通知（带时间、地点、参会人）
- 数据报表（带图表、关键指标）
- 知识分享（带目录、章节、跳转链接）
- 审批流程（带按钮、表单）

### ❌ 不适合用卡片的场景
- 简单文本消息 → 使用 `feishu-send-message`
- 纯图片 → 使用 `feishu-send-image`
- 只是询问如何发送卡片 → 不调用任何工具

---

## 卡片设计原则

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

## 卡片结构详解

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

### Body（内容区域）

## 1. 图片元素
```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "scale_type": "fit_horizontal",
  "corner_radius": "8px",
  "margin": "0px 0px 0px 0px"
}
```

**说明：**
- `img_key`：图片 key（需先上传到飞书）
- `scale_type`：缩放方式（fit_horizontal/crop_center）
- `corner_radius`：圆角大小

---

#### 2. Markdown 文本
```json
{
  "tag": "markdown",
  "content": "## 标题\n\n正文内容",
  "text_size": "normal"
}
```

**支持的 Markdown 语法：**
- 标题：`## 标题`
- 加粗：`**加粗**`
- 颜色：`<font color='blue'>蓝色文字</font>`
- 列表：`- 列表项`
- 引用：`> 引用内容`
- 代码块：` ```Plain Text\n代码\n``` `

---

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
      ],
      "padding": "12px 12px 12px 12px",
      "weight": 1
    }
  ]
}
```

**说明：**
- `background_style`：背景颜色
- `padding`：内边距
- `weight`：列宽权重

---

#### 4. 分割线
```json
{
  "tag": "hr",
  "margin": "0px 0px 0px 0px"
}
```

---

#### 5. 按钮
```json
{
  "tag": "button",
  "text": {
    "tag": "plain_text",
    "content": "按钮文字"
  },
  "type": "primary_filled",
  "width": "default",
  "size": "medium",
  "behaviors": [
    {
      "type": "open_url",
      "default_url": "https://example.com",
    "pc_url": "https://example.com",
      "ios_url": "https://example.com",
      "android_url": "https://example.com"
    }
  ]
}
```

**按钮样式：**
- `primary_filled`：主要按钮（蓝色填充）
- `default`：默认按钮（白色边框）
- `danger`：危险按钮（红色）

---

## 完整示例
### 示例 1：项目进展卡片
```json
{
  "config": {
    "update_multi": true
  },
  "header": {
    "title": {
      "tag": "plain_text",
      "content": "项目进展周报"
    },
    "text_tag_list": [
      {
        "tag": "text_tag",
        "text": {
          "tag": "plain_text",
          "content": "进行中"
        },
      "color": "blue"
      }
    ],
    "template": "blue"
  },
  "elements": [
    {
      "tag": "markdown",
      "content": "## 本周完成\n- ✅ 完成需求评审\n- ✅ 完成技术方案设计\n- ✅ 完成原型设计"
    },
    {
    "tag": "hr"
    },
    {
      "tag": "markdown",
      "content": "## 下周计划\n\n- 🔄 开发核心功能\n- 🔄 编写单元测试\n- 🔄 准备演示环境"
    },
    {
      "tag": "hr"
    },
    {
      "tag": "column_set",
    "columns": [
        {
          "tag": "column",
       "width": "weighted",
          "background_style": "red-50",
          "elements": [
            {
         "tag": "markdown",
          "content": "**⚠️ 风险提示**\n第三方 API 对接存在延期风险，需要提前准备备选方案。"
          }
     ],
          "padding": "12px 12px 12px 12px",
          "weight": 1
        }
      ]
    },
    {
      "tag": "column_set",
      "columns": [
        {
          "tag": "column",
          "width": "auto",
       "elements": [
            {
              "tag": "button",
        "text": {
            "tag": "plain_text",
                "content": "查看详细进度"
              },
              "type": "primary_filled",
              "behaviors": [
          {
                  "type": "open_url",
         "default_url": "https://example.com/project"
                }
              ]
          }
          ]
        }
      ]
    }
  ]
}
```

---

### 示例 2：会议通知卡片
```json
{
  "config": {
    "update_multi": true
  },
  "header": {
    "title": {
      "tag": "plain_text",
      "content": "产品评审会议"
    },
    "text_tag_list": [
      {
        "tag": "text_tag",
        "text": {
          "tag": "plain_text",
          "content": "明天 14:00"
        },
        "color": "blue"
      }
    ],
    "template": "blue"
  },
  "elements": [
    {
      "tag": "markdown",
      "content": "**📅 时间**：2026-03-13 14:00-15:30\n\n**📍 地点**：会议室 A\n\n**👥 参会人**：@张三 @李四 @王五"
    },
    {
      "tag": "hr"
    },
    {
      "tag": "markdown",
      "content": "## 会议议程\n\n1. 产品需求评审（30 分钟）\n2. 技术方案讨论（30 分钟）\n3. 排期确认（30 分钟）"
    },
    {
      "tag": "hr"
    },
    {
      "tag": "column_set",
      "columns": [
        {
          "tag": "column",
          "width": "weighted",
          "background_style": "yellow-50",
          "elements": [
            {
           "tag": "markdown",
              "content": "**📝 会前准备**\n\n请提前阅读需求文档，准备好问题和建议。"
          }
          ],
          "padding": "12px 12px 12px 12px",
          "weight": 1
        }
      ]
    },
    {
      "tag": "column_set",
      "columns": [
        {
          "tag": "column",
          "width": "auto",
          "elements": [
            {
              "tag": "button",
         "text": {
                "tag": "plain_text",
                "content": "查看需求文档"
              },
              "type": "primary_filled",
              "behaviors": [
           {
              "type": "open_url",
               "default_url": "https://example.com/doc"
                }
              ]
            },
       {
              "tag": "button",
              "text": {
                "tag": "plain_text",
           "content": "加入日历"
              },
              "type": "default",
              "behaviors": [
                {
             "type": "open_url",
         "default_url": "https://example.com/calendar"
          }
           ]
            }
          ],
          "direction": "horizontal"
        }
      ]
    }
  ]
}
```

---

## 发送卡片的步骤

### 1. 构建卡片 JSON
按照上面的结构，构建完整的卡片 JSON。

### 2. 调用工具发送
```javascript
feishu_im_user_message({
  action: "send",
  receive_id: "oc_xxx", // 群聊 ID 或用户 ID
  receive_id_type: "chat_id", // 或 "open_id"
  msg_type: "interactive",
  content: JSON.stringify({
    config: { update_multi: true },
    header: { ... },
    elements: [ ... ]
  })
})
```

### 3. 验证结果
- 检查卡片是否正常显示
- 确认按钮跳转链接有效
- 确认颜色和排版符合预期

---

## 常见问题

### Q1: 图片如何上传？
**A:** 需要先使用飞书 API 上传图片，获取 `img_key`，然后在卡片中引用。

### Q2: 卡片发送失败怎么办？
**A:** 检查：
1. JSON 格式是否正确
2. 是否有 OAuth 授权
3. 接收者 ID 是否正确
4. 卡片结构是否符合规范

### Q3: 如何调试卡片样式？
**A:** 可以使用飞书开放平台的卡片搭建工具：
https://open.feishu.cn/tool/cardbuilder

### Q4: 卡片可以交互吗？
**A:** 可以！支持：
- 按钮点击跳转
- 表单提交
- 回调处理
（需要配置回调接口）

---

## 最佳实践

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

## 学习资源

### 官方文档
- 飞书卡片搭建工具：https://open.feishu.cn/tool/cardbuilder
- 卡片开发指南：https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/feishu-card-overview

### 参考案例
- 企业养虾攻略卡片（见 `/Users/bytedance/Downloads/企业养虾攻略：从白虾到好虾的新手村指南.card`）

---

**最后更新：** 2026-03-12
**下次审查：** 2026-04-12

---

## 实战案例：企业养虾攻略卡片

**来源**：`/Users/bytedance/Downloads/企业养虾攻略：从白虾到好虾的新手村指南.card`

这个案例展示了**高质量飞书卡片**的完整设计：

### 卡片亮点

✅ **顶部图片** - 吸引注意力  
✅ **彩色背景块** - blue-50、violet-50、purple-50 分层突出重点  
✅ **清晰章节** - 使用 hr 分割线分隔 5 个大章节  
✅ **丰富内容** - markdown、引用块、代码块、清单、FAQ  
✅ **多按钮** - 两个按钮引导用户查看完整攻略和加群  
✅ **视觉一致** - 统一的蓝色主题，渐进式信息呈现  

### 卡片结构

```json
{
  "config": {"update_multi": true},
  "header": {
    "title": {"content": "企业养虾攻略：从白虾到好虾的新手村指南"},
    "text_tag_list": [
      {"text": {"content": "AI助手使用指南"}, "color": "blue"}
    ],
    "template": "blue"
  },
  "elements": [
    // 1. 顶部图片
    {"tag": "img", "img_key": "img_v3_xxx", "corner_radius": "8px"},
    
    // 2. 蓝色背景块（核心提示）
    {
      "tag": "column_set",
      "columns": [{
        "background_style": "blue-50",
        "elements": [
          {"tag": "markdown", "content": "**<font color='blue'>写给刚接入飞书 AI 助手的企业团队</font>**"}
        ]
      }]
    },
    
    // 3. 分割线
    {"tag": "hr"},
    
    // 4. 多个章节（每个章节都有标题、内容、示例）
    {"tag": "markdown", "content": "## 先搞清楚：虾是什么？"},
    {"tag": "markdown", "content": "> **一句话：虾 = 豆包/大模型 + 技能 + 飞书 + 你的业务知识**"},
    
    // ... 更多内容 ...
    
    // 5. 底部双按钮
    {
      "tag": "column_set",
      "columns": [
        {
          "elements": [
            {
              "tag": "button",
              "text": {"content": "查看完整养虾攻略"},
              "type": "primary_filled",
              "behaviors": [{"type": "open_url", "default_url": "https://..."}]
            }
          ]
        }
      ],
      "direction": "horizontal"
    }
  ]
}
```

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
- 使用 primary_filled 突出主要行动

**5. 实用性**
- 基于 OpenClaw 实战经验总结
- 包含具体操作步骤和配置示例
- 提供常见问题和解决方案
- 清单形式便于执行检查

---

**这个卡片是学习飞书卡片设计的绝佳参考！** 🦞

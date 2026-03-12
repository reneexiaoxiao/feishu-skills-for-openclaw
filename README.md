# 飞虾补习班｜OpenClaw 飞书技能包 🦞

> **官方插件给 Agent 能力，飞虾补习班教 Agent 什么时候用、怎么用得体、以及用官方还没覆盖的能力。**

---

![Layer](https://img.shields.io/badge/Layer-Intent_Routing-brightgreen)
![Layer](https://img.shields.io/badge/Layer-UX_Optimization-blue)
![Layer](https://img.shields.io/badge/Layer-Capability_Extension-purple)
![Version](https://img.shields.io/badge/version-2.1.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![OpenClaw](https://img.shields.io/badge/OpenClaw-Skills-orange.svg)

---

## 🎯 项目定位

基于飞书官方 OpenClaw 插件的**增强技能包**。不是替代，而是三层增强：

### 🟢 意图路由（Intent Routing）
官方插件已支持但 Agent **不知道何时调用**的能力，通过自然语言意图路由自动匹配。

**示例**：用户说"给张三发消息" → Agent 自动知道该调用 `feishu_im_user_message` 工具

### 🔵 体验优化（UX Optimization）
将「请提供 open_id」类的**反人类交互**优化为 @mention 自动解析等用户友好方式。

**示例**：用户说"@产品群开会了" → Agent 自动解析群 ID → 无需用户手动查找

### 🟣 能力扩展（Capability Extension）
官方插件尚未覆盖的高级能力（如**消息卡片发送 + 内置设计指南**），直接补齐。

**示例**：用户说"发个美观的项目进展卡片" → Agent 返回 Card JSON 2.0 → 系统自动发送

---

> **💡 核心理念**：官方插件是引擎，飞虾补习班是驾驶手册 + 涡轮增压。

---

## ✨ 为什么需要这个技能包？

### 官方插件的三大痛点

| 痛点 | 官方插件 | 飞虾补习班 |
|------|---------|-----------|
| **不知道何时用** | ✅ 提供了能力，但 Agent 不会主动调用 | 🟢 意图路由让 Agent 知道何时用 |
| **交互不友好** | ❌ 要求用户提供 `open_id`、`chat_id` | 🔵 自动解析 @mention，用户无感知 |
| **能力缺失** | ❌ 没有卡片发送、图片上传等 | 🟣 直接补齐缺失能力 |

---

## 🚀 快速开始

### 前置要求

1. **安装 OpenClaw**：https://openclaw.ai
2. **安装官方插件**：`@larksuite/openclaw-lark`

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills-for-openclaw/main/install-from-github.sh | bash
```

### 手动安装

```bash
git clone https://github.com/reneexiaoxiao/feishu-skills-for-openclaw.git
cd feishu-skills-for-openclaw
bash install.sh
```

---

## 📦 技能清单

### 核心技能

| 技能 | 定位 | 功能 | 触发词 |
|------|------|------|--------|
| **send-message** | 🟢 意图路由 | 发送文本消息（自动解析 @） | "发消息"、"告诉XX" |
| **send-card** | 🟣 能力扩展 | 发送交互式卡片（Card JSON 2.0） | "发卡片"、"卡片消息" |
| **send-image** | 🟣 能力扩展 | 发送图片消息 | "发图片"、"发截图" |

### 工作原理

```
用户："给产品群发个项目进展卡片"
  ↓
🟢 意图路由：识别"发卡片"意图
  ↓
🟣 能力扩展：调用 send-card 技能
  ↓
Agent 设计 Card JSON 2.0
  ↓
系统自动检测 JSON → 用机器人身份发送 ✅
```

---

## 💡 使用示例

### 示例 1：发送文本消息

```
你：给产品群发消息"下午3点开会"
```

**虾的内部处理**：
1. 🟢 识别意图：`send-message` 技能
2. 🔵 解析 @：自动获取"产品群"的 chat_id
3. 调用工具：`feishu_im_user_message`
4. 发送成功 ✅

---

### 示例 2：发送美观卡片

```
你：发个卡片，标题是项目进展，内容是进度80%，状态正常
```

**虾的内部处理**：
1. 🟢 识别意图：`send-card` 技能
2. 🟣 设计卡片：根据 Card JSON 2.0 规范
3. 返回 JSON（不调用工具）
4. 系统自动检测并发送 ✅

**返回的卡片 JSON**：
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
        "content": "**进度**：80%\n\n**状态**：正常"
      }
    ]
  }
}
```

---

### 示例 3：发送带图片的卡片

```
你：用这张图片发个卡片：/path/to/artwork.png
```

**虾的内部处理**：
1. 🟢 识别意图：`send-card` 技能
2. 🟣 上传图片：调用 `feishu_upload_image` 获取 img_key
3. 设计卡片：使用 img_key
4. 返回 JSON → 系统自动发送 ✅

---

## 🔧 技术架构

### 与官方插件的关系

```
@larksuite/openclaw-lark (官方插件)
├── ✅ 文档操作
├── ✅ 多维表格
├── ✅ 日程管理
├── ✅ 读取消息
├── ✅ 基础工具 (feishu_im_user_message)
└── ❌ 不知道何时用 / 体验差 / 能力缺失
    ↓
feishu-skills-for-openclaw (飞虾补习班)
├── 🟢 意图路由 (让 Agent 知道何时用)
├── 🔵 体验优化 (@mention 自动解析)
└── 🟣 能力扩展 (卡片、图片上传等)
```

### Scope 权限说明

**官方插件**：
- 提供飞书 API 的底层工具
- 需要用户授权某些敏感权限（如 `im:message.send_as_user`）
- 工具调用方式：`feishu_im_user_message`

**飞虾补习班**：
- **不直接调用飞书 API**
- **不请求任何权限**
- 只是告诉 Agent："这个时候应该用官方的哪个工具"
- 或返回 JSON，让系统自动发送

---

## 🎨 卡片设计指南

`send-card` 技能内置了完整的 Card JSON 2.0 设计指南，包括：

- ✅ Card JSON 2.0 规范（必须使用 `body.elements`）
- ✅ 设计原则（层级清晰、信息密度控制、颜色克制）
- ✅ 常见错误与解决方案
- ✅ 实战案例（企业养虾攻略卡片）
- ✅ 图片上传流程

**Agent 会自动应用这些原则**，设计出美观的卡片。

---

## 🛠️ 故障排查

### 问题 1：Agent 不发送卡片，只返回文本

**原因**：Agent 可能返回了纯文本而不是 JSON 代码块

**解决方案**：
1. 确认技能文件已正确安装：`~/.openclaw/skills/send-card/SKILL.md`
2. 重启 OpenClaw：`launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway`
3. 再次尝试

---

### 问题 2：卡片发送失败

**原因**：Card JSON 格式错误或不符合 2.0 规范

**常见错误**：
- ❌ 使用了顶层 `elements` 而不是 `body.elements`
- ❌ 忘记声明 `"schema": "2.0"`
- ❌ 使用了已废弃的 `size: "stretch_without_padding"`

**解决方案**：检查 Card JSON 是否符合 2.0 规范，参考技能文件中的示例

---

### 问题 3：图片无法显示

**原因**：使用了图片 URL 而不是 `img_key`

**正确流程**：
1. 先调用 `feishu_upload_image` 上传图片
2. 获取返回的 `image_key`
3. 在卡片中使用：`{"tag": "img", "img_key": "img_v3_xxx"}`

---

## 📚 学习资源

- [OpenClaw 官网](https://openclaw.ai)
- [飞书开放平台](https://open.feishu.cn)
- [飞书卡片搭建工具](https://open.feishu.cn/tool/cardbuilder)
- [Card JSON 2.0 文档](https://open.feishu.cn/document/feishu-cards/feishu-card-overview)
- [官方插件 GitHub](https://github.com/larksuite/openclaw-lark)

---

## 🤝 贡献

欢迎提 Issue 和 PR！

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/amazing-skill`
3. 提交更改：`git commit -m 'Add amazing skill'`
4. 推送分支：`git push origin feature/amazing-skill`
5. 提交 Pull Request

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## 🔗 相关链接

- [OpenClaw 官网](https://openclaw.ai)
- [飞书开放平台](https://open.feishu.cn)
- [官方插件 GitHub](https://github.com/larksuite/openclaw-lark)
- [飞书卡片搭建工具](https://open.feishu.cn/tool/cardbuilder)

---

<div align="center">

**Made with ❤️ by Xiaoxiao**

官方插件是引擎，飞虾补习班是驾驶手册 + 涡轮增压 🚗💨

</div>

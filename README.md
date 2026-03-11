# 🦞 飞书技能系列

> 独立的、可直接执行的飞书操作 Skill 集合

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/reneexiaoxiao/feishu-skills)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Skills-orange.svg)](https://openclaw.ai)

## ✨ 特点

- **完全独立** - 每个 Skill 职责单一，易于维护
- **直接执行** - 识别意图立即执行，不教学
- **可排查** - 问题定位准确，易于调试
- **可组合** - 多个 Skill 协同完成复杂任务

## 📁 包含的技能

### 即时通讯（IM）

| 技能 | 功能 | 触发词 |
|------|------|--------|
| `send-message` | 发送文本消息 | 发送消息、发消息、给XX说 |
| `send-card` | 发送卡片 | 发送卡片、发卡片 |
| `send-image` | 发送图片 | 发送图片、发截图 |
| `mention-user` | @提及用户 | @XX、艾特、提及 |

### 文档操作

| 技能 | 功能 | 触发词 |
|------|------|--------|
| `create-doc` | 创建文档 | 创建文档、新建文档 |
| `update-doc` | 更新文档 | 更新文档、修改文档 |
| `fetch-doc` | 读取文档 | 读取文档、获取文档 |

### 数据管理

| 技能 | 功能 | 触发词 |
|------|------|--------|
| `bitable` | 多维表格操作 | 表格、多维表格、数据表 |

### 日程管理

| 技能 | 功能 | 触发词 |
|------|------|--------|
| `calendar` | 日程管理 | 日程、日历、会议 |

## 🚀 快速安装

### 方式1：一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills/main/install.sh | bash
```

### 方式2：使用安装脚本

```bash
# 克隆或下载项目
git clone https://github.com/reneexiaoxiao/feishu-skills.git
cd feishu-skills

# 运行安装脚本
bash install.sh
```

### 方式3：手动安装

```bash
# 复制所有技能到 OpenClaw skills 目录
cp -r feishu-skills/* ~/.openclaw/skills/

# 重启 OpenClaw
```

## 📋 前置要求

### 必须安装飞书官方 MCP 插件

```bash
npx -y https://sf3-cn.feishucdn.com/obj/open-platform-opendoc/8ab6e7a04c17db1becfcbda8ca35f091_1rCCFRWlRV.tgz install
```

验证安装：
```bash
openclaw plugins list
# 应该看到 feishu-openclaw-plugin 的 Status 为 loaded
```

## 🧪 测试

安装完成后，测试技能是否正常工作：

### 基础测试

```
# 测试1：发送消息
给文件传输助手发消息"测试飞书技能"

# 测试2：创建文档
创建文档，标题是"测试"

# 测试3：查看日程
查看这周的日程
```

### 完整测试指南

查看 [TEST-GUIDE.md](TEST-GUIDE.md) 获取完整的测试用例。

## 💡 使用示例

### 发送消息

```
用户：给产品群发消息"下午3点开会"
AI：✅ 消息已发送
```

### 发送卡片

```
用户：给项目组发项目进展卡片：
项目：飞书集成
进度：80%
状态：正常

AI：✅ 卡片已发送
```

### 创建文档

```
用户：创建文档，标题是"项目计划"
AI：✅ 文档已创建
文档链接：https://xxx.feishu.cn/docx/doxcnXXX
```

### 操作表格

```
用户：在表格中添加一行：
姓名：张三
状态：进行中

AI：✅ 记录已添加
```

### 创建日程

```
用户：创建明天下午2点的日程，主题"项目会议"
AI：✅ 日程已创建
```

## 📊 项目结构

```
feishu-skills/
├── send-message/       💬 发送文本消息
├── send-card/          📋 发送卡片
├── send-image/         🖼️ 发送图片
├── mention-user/       @提及用户
├── create-doc/         📄 创建文档
├── update-doc/         ✏️ 更新文档
├── fetch-doc/          📖 读取文档
├── bitable/            📊 多维表格
├── calendar/           📅 日程管理
├── install.sh          安装脚本
├── package.json        项目配置
├── README.md           本文件
└── TEST-GUIDE.md       测试指南
```

## 🔧 开发参考

### 飞书开放平台

- [API 文档首页](https://open.feishu.cn/document/home/index)
- [发送消息 API](https://open.feishu.cn/document/server-docs/im-v1/message/create)
- [文档操作 API](https://open.feishu.cn/document/server-docs/docs/docs-create)
- [多维表格 API](https://open.feishu.cn/document/server-docs/bitable-v1/app-table-record/create)

### 飞书卡片

- [卡片概述](https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/feishu-card-overview)
- [卡片元素](https://open.feishu.cn/document/uAjLw4CM/ukzMukzMukzM/feishu-cards/card-contents)
- [卡片构建工具](https://open.feishu.cn/document/tools-and-resources/message-card-builder)

## 🤝 贡献

欢迎贡献代码、报告问题或提出建议！

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingSkill`)
3. 提交更改 (`git commit -m 'Add some AmazingSkill'`)
4. 推送到分支 (`git push origin feature/AmazingSkill`)
5. 开启 Pull Request

## 📝 开发规范

### 添加新技能

1. 在 `skills/` 目录创建新文件夹
2. 创建 `SKILL.md` 文件
3. 参考现有技能的格式
4. 在 `package.json` 中注册新技能
5. 更新 README.md
6. 添加测试用例

### SKILL.md 结构

```markdown
---
name: feishu-xxx
description: |
  触发条件
  参数说明
  NOT 使用条件
---

# 功能说明

## 工具调用
## 参数结构
## 执行流程
## 常见场景
## 错误处理
## API 参考
## 返回结果
```

## 📦 发布

### 更新版本

```bash
# 更新版本号
npm version patch  # 1.0.0 -> 1.0.1
npm version minor  # 1.0.0 -> 1.1.0
npm version major  # 1.0.0 -> 2.0.0

# 推送到 GitHub
git push origin main --tags
```

### 发布到 npm（可选）

```bash
npm publish
```

## 📄 License

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- 感谢飞书开放平台提供的强大 API
- 感谢 OpenClaw 团队的支持
- 感谢所有使用和贡献的用户

## 📞 联系方式

- 项目主页：[https://github.com/reneexiaoxiao/feishu-skills](https://github.com/reneexiaoxiao/feishu-skills)
- 问题反馈：[GitHub Issues](https://github.com/reneexiaoxiao/feishu-skills/issues)

---

**让所有龙虾都能轻松使用飞书自动化！** 🦞

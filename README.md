# 🦞 飞书技能系列 for OpenClaw

> **补充 OpenClaw 官方飞书插件缺失的即时通讯技能**

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/reneexiaoxiao/feishu-skills-for-openclaw)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Skills-orange.svg)](https://openclaw.ai)

## 🎯 项目定位

本项目**不重复**官方插件 [@larksuite/openclaw-lark](https://github.com/larksuite/openclaw-lark) 已有的功能，只补充**缺失的即时通讯技能**。

### ✅ 我们提供（官方插件没有）

| 技能 | 功能 | 官方工具 |
|------|------|---------|
| `send-message` | 发送文本消息 | feishu_im_user_message |
| `send-card` | 发送卡片消息 | feishu_im_user_message |
| `send-image` | 发送图片 | feishu_im_user_message |
| `mention-user` | @提及用户 | 消息内容中的@标签 |

### 📦 官方插件已有（使用官方的）

- `feishu-create-doc` - 创建文档
- `feishu-update-doc` - 更新文档
- `feishu-fetch-doc` - 读取文档
- `feishu-bitable` - 多维表格
- `feishu-calendar` - 日程管理
- `feishu-task` - 任务管理
- `feishu-im-read` - 读取消息

## ✨ 特点

- **精简专注** - 只做官方没做的，不重复造轮
- **直接调用** - 告诉 OpenClaw 何时调用官方工具
- **轻量级** - 每个技能只包含核心说明

## 🚀 快速安装

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills-for-openclaw/main/install-from-github.sh | bash
```

### 手动安装

```bash
# 克隆项目
git clone https://github.com/reneexiaoxiao/feishu-skills-for-openclaw.git
cd feishu-skills-for-openclaw

# 运行安装脚本
bash install.sh
```

## 📋 技能说明

### send-message（发送文本消息）

**触发**："发消息"、"告诉XX"、"给XX说"

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "text",
  "content": "{\"text\":\"消息内容\"}"
}
```

### send-card（发送卡片）

**触发**："发卡片"、"卡片消息"

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "interactive",
  "content": "{\"header\":{...},\"elements\":[...]}"
}
```

### send-image（发送图片）

**触发**："发图片"、"发截图"

```json
{
  "action": "send",
  "receive_id": "oc_xxx",
  "receive_id_type": "chat_id",
  "msg_type": "image",
  "content": "{\"image_key\":\"img_xxx\"}"
}
```

### mention-user（@提及）

**触发**："@XX"、"艾特"

在消息内容中使用：
```
<at user_id="ou_xxx">张三</at> 请查看
```

## 🔧 前置要求

### OpenClaw

确保已安装 OpenClaw：https://openclaw.ai

### 飞书官方插件

确保已安装 [@larksuite/openclaw-lark](https://github.com/larksuite/openclaw-lark)：

```bash
npx -y https://sf3-cn.feishucdn.com/obj/open-platform-opendoc/8ab6e7a04c17db1becfcbda8ca35f091_1rCCFRWlRV.tgz install
```

## 📝 使用示例

安装后，直接对 OpenClaw 说：

```
"给文件传输助手发消息'测试飞书技能'"
"发个卡片给产品群，标题是项目进展，内容是进度80%"
"@所有人 下午3点开会"
```

## 🆚 与官方插件的关系

```
@larksuite/openclaw-lark (官方)
├── 文档操作 ✅
├── 多维表格 ✅
├── 日程管理 ✅
├── 读取消息 ✅
└── 发送消息 ❌ ← 我们补充这个

feishu-skills-for-openclaw (我们)
├── send-message ✅
├── send-card ✅
├── send-image ✅
└── mention-user ✅
```

## 🤝 贡献

欢迎提 Issue 和 PR！

## 📄 许可证

MIT License

## 🔗 相关链接

- [OpenClaw 官网](https://openclaw.ai)
- [飞书开放平台](https://open.feishu.cn)
- [官方插件 GitHub](https://github.com/larksuite/openclaw-lark)
- [飞书卡片搭建工具](https://open.feishu.cn/tool/cardbuilder)

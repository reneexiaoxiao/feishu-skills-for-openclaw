# 飞书技能系列 - 安装指南

## 🚀 快速安装

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills-for-openclaw/main/install-from-github.sh | bash
```

### 手动安装

1. 下载或克隆项目
```bash
git clone https://github.com/reneexiaoxiao/feishu-skills-for-openclaw.git
cd feishu-skills
```

2. 运行安装脚本
```bash
bash install.sh
```

3. 选择要安装的技能

## 📋 前置要求

### OpenClaw

确保已安装 OpenClaw：
```bash
openclaw --version
```

### 飞书 MCP 插件

必须安装飞书官方 MCP 插件：
```bash
npx -y https://sf3-cn.feishucdn.com/obj/open-platform-opendoc/8ab6e7a04c17db1becfcbda8ca35f091_1rCCFRWlRV.tgz install
```

验证安装：
```bash
openclaw plugins list
# 应该看到 feishu-openclaw-plugin 的 Status 为 loaded
```

## 🔧 安装选项

### 选项1：安装所有技能（推荐）

安装所有 9 个技能：
- 即时通讯（4个）
- 文档操作（3个）
- 数据管理（1个）
- 日程管理（1个）

### 选项2：按分类安装

- **即时通讯**：消息、卡片、图片、@人
- **文档操作**：创建、更新、读取
- **数据管理**：多维表格
- **日程管理**：日历

### 选项3：自定义选择

选择需要的单个技能进行安装。

## 📁 安装位置

技能将被安装到：
```
~/.openclaw/skills/
├── send-message/
├── send-card/
├── send-image/
├── mention-user/
├── create-doc/
├── update-doc/
├── fetch-doc/
├── bitable/
└── calendar/
```

## ✅ 验证安装

### 检查文件

```bash
ls ~/.openclaw/skills/
# 应该看到安装的技能目录
```

### 重启 OpenClaw

重启后，技能将自动加载。

### 测试技能

```
# 测试1：发送消息
给文件传输助手发消息"测试"

# 测试2：创建文档
创建文档，标题是"测试"

# 测试3：查看日程
查看这周的日程
```

## 🔄 更新技能

### 更新到最新版本

```bash
cd feishu-skills
git pull origin main
bash install.sh
```

### 更新单个技能

删除旧版本并重新安装：
```bash
rm -rf ~/.openclaw/skills/skill-name
cp -r feishu-skills/skill-name ~/.openclaw/skills/
```

## 🗑️ 卸载技能

### 卸载所有技能

```bash
rm -rf ~/.openclaw/skills/send-message
rm -rf ~/.openclaw/skills/send-card
rm -rf ~/.openclaw/skills/send-image
rm -rf ~/.openclaw/skills/mention-user
rm -rf ~/.openclaw/skills/create-doc
rm -rf ~/.openclaw/skills/update-doc
rm -rf ~/.openclaw/skills/fetch-doc
rm -rf ~/.openclaw/skills/bitable
rm -rf ~/.openclaw/skills/calendar
```

### 卸载单个技能

```bash
rm -rf ~/.openclaw/skills/skill-name
```

## ❓ 常见问题

### Q: 技能未被调用？

A: 检查以下几点：
1. 技能是否正确安装到 `~/.openclaw/skills/`
2. 是否重启了 OpenClaw
3. 是否使用了正确的触发词

### Q: API 调用失败？

A: 确认：
1. 飞书 MCP 插件是否已安装
2. 是否有相应的权限
3. ID 格式是否正确

### Q: 如何只安装部分技能？

A: 运行 `install.sh` 时选择选项2-5，或手动复制需要的技能目录。

### Q: 技能之间会冲突吗？

A: 不会。每个技能独立，通过触发条件区分。

## 📞 获取帮助

- 查看 [README.md](README.md)
- 查看 [TEST-GUIDE.md](TEST-GUIDE.md)
- 在 [GitHub Issues](https://github.com/reneexiaoxiao/feishu-skills-for-openclaw/issues) 提问

---

**安装完成后，重启 OpenClaw 即可开始使用！** 🦞

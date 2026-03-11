# 🚀 飞书技能系列 - 发布指南

## 准备工作

### 1. 更新配置

在 `package.json` 中更新你的 GitHub 信息：

```json
{
  "repository": {
    "type": "git",
    "url": "https://github.com/reneexiaoxiao/feishu-skills.git"
  },
  "homepage": "https://github.com/reneexiaoxiao/feishu-skills#readme",
  "bugs": {
    "url": "https://github.com/reneexiaoxiao/feishu-skills/issues"
  }
}
```

### 2. 全局替换

将所有文件中的 `reneexiaoxiao` 替换为你的 GitHub 用户名：

```bash
cd /Users/bytedance/Downloads/feishu-skills

# 替换 README.md
sed -i '' 's/reneexiaoxiao/你的用户名/g' README.md

# 替换 install-from-github.sh
sed -i '' 's/reneexiaoxiao/你的用户名/g' install-from-github.sh
```

## 发布步骤

### 步骤1：创建 GitHub 仓库

1. 访问 [GitHub](https://github.com)
2. 点击右上角 `+` → `New repository`
3. 填写仓库信息：
   - **Repository name**: `feishu-skills`
   - **Description**: `飞书技能系列 - 独立的、可直接执行的飞书操作 Skill 集合`
   - **Public**: ✅ 公开
4. **不要**勾选 "Add a README file"
5. 点击 "Create repository"

### 步骤2：推送代码

```bash
cd /Users/bytedance/Downloads/feishu-skills

# 初始化 Git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "🎉 首次发布飞书技能系列

- 9 个独立的飞书操作技能
- 一键安装脚本
- 完整的文档和测试指南

🦞 让所有龙虾都能轻松使用飞书自动化！"

# 添加远程仓库
git remote add origin https://github.com/reneexiaoxiao/feishu-skills.git

# 推送到 GitHub
git push -u origin main
```

### 步骤3：创建 GitHub Release

1. 访问你的仓库页面
2. 点击 `Releases` → `Create a new release`
3. 填写信息：
   - **Tag version**: `v1.0.0`
   - **Release title**: `🦞 飞书技能系列 v1.0.0`
   - **Description**: 复制 `CHANGELOG.md` 中的 v1.0.0 内容
4. 点击 `Publish release`

### 步骤4：启用 GitHub Pages（可选）

如果想要项目网页：

1. 访问仓库 `Settings` → `Pages`
2. Source 选择 `Deploy from a branch`
3. Branch 选择 `main`，文件夹选择 `/root`
4. 点击 `Save`

## 分享方式

### 方式1：一键安装命令（推荐）

**分享这个命令**：
```bash
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills/main/install-from-github.sh | bash
```

用户只需复制粘贴这个命令，就能自动安装所有技能！

### 方式2：项目链接

**分享 GitHub 仓库链接**：
```
https://github.com/reneexiaoxiao/feishu-skills
```

### 方式3：安装说明

**复制以下内容分享**：

```markdown
# 飞书技能系列

独立的、可直接执行的飞书操作 Skill 集合。

## 快速安装

```bash
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills/main/install-from-github.sh | bash
```

## 包含的技能

- 💬 发送消息
- 📋 发送卡片
- 🖼️ 发送图片
- @ 提及用户
- 📄 创建文档
- ✏️ 更新文档
- 📖 读取文档
- 📊 多维表格
- 📅 日程管理

## 详细信息

访问：https://github.com/reneexiaoxiao/feishu-skills
```

### 方式4：发布到 ClawHub（如果有的话）

如果 OpenClaw 有技能市场，可以：

1. 打包项目
```bash
cd /Users/bytedance/Downloads/feishu-skills
tar -czf feishu-skills.tar.gz *
```

2. 上传到 ClawHub

## 宣传建议

### 在飞书社区分享

```
🦞 飞书技能系列发布！

我创建了一套独立的、可直接执行的飞书操作 Skill，包含：
- 发送消息、卡片、图片
- 文档操作（创建、更新、读取）
- 多维表格操作
- 日程管理

一键安装：
curl -fsSL https://raw.githubusercontent.com/reneexiaoxiao/feishu-skills/main/install-from-github.sh | bash

GitHub：https://github.com/reneexiaoxiao/feishu-skills

欢迎试用和反馈！
```

### 在 OpenClaw 社区分享

在 OpenClaw 相关的论坛、群组分享：

```
【分享】飞书技能系列 v1.0

我做了 9 个飞书操作的 Skill，特点是：
1. 完全独立，每个职责单一
2. 识别意图立即执行，不教学
3. 易于排查和维护

一键安装命令见 GitHub：
https://github.com/reneexiaoxiao/feishu-skills

欢迎试用、反馈和贡献！
```

## 维护更新

### 收到反馈

1. 在 GitHub Issues 中查看反馈
2. 修复问题或添加新功能
3. 更新版本号：
```bash
npm version patch  # 修复：1.0.0 -> 1.0.1
npm version minor  # 新功能：1.0.0 -> 1.1.0
```
4. 提交并推送：
```bash
git add .
git commit -m "chore: 发布 v1.0.1"
git push origin main
```
5. 创建新的 GitHub Release

### 添加新技能

1. 在 `skills/` 目录创建新技能
2. 更新文档
3. 测试验证
4. 发布新版本

## 许可证

项目使用 MIT 许可证，用户可以：
- ✅ 自由使用
- ✅ 修改
- ✅ 分发
- ✅ 私人使用

## 统计和反馈

### 查看克隆数

访问 GitHub 仓库页面，查看：
- Stars（⭐）
- Forks（🔱）
- Clones

### 用户反馈

通过以下方式收集反馈：
- GitHub Issues
- GitHub Discussions
- 社区分享

---

**发布后，记得在各个社区分享！让更多龙虾受益！** 🦞

# Contributing to 飞书技能系列

感谢你有兴趣贡献飞书技能系列！

## 如何贡献

### 报告问题

如果你发现了 bug 或有功能建议：

1. 在 [GitHub Issues](https://github.com/reneexiaoxiao/feishu-skills/issues) 搜索是否已有类似问题
2. 如果没有，创建新 Issue，提供：
   - 清晰的标题和描述
   - 重现步骤
   - 预期行为和实际行为
   - 环境信息（OpenClaw 版本等）

### 提交代码

1. **Fork 项目**
   ```bash
   # 在 GitHub 上点击 Fork 按钮
   ```

2. **克隆你的 Fork**
   ```bash
   git clone https://github.com/reneexiaoxiao/feishu-skills.git
   cd feishu-skills
   ```

3. **创建特性分支**
   ```bash
   git checkout -b feature/your-skill-name
   ```

4. **添加新技能**

   在 `skills/` 目录创建新文件夹：
   ```
   skills/
   └── your-skill/
       └── SKILL.md
   ```

   参考 [开发规范](README.md#开发规范) 创建 SKILL.md

5. **更新文档**

   - 在 `README.md` 中添加新技能说明
   - 在 `package.json` 中注册新技能
   - 在 `TEST-GUIDE.md` 中添加测试用例

6. **提交更改**
   ```bash
   git add .
   git commit -m "Add: 添加新技能 your-skill"
   ```

7. **推送到 Fork**
   ```bash
   git push origin feature/your-skill-name
   ```

8. **创建 Pull Request**
   - 访问你的 Fork 页面
   - 点击 "Compare & pull request"
   - 提供清晰的 PR 描述

## 开发规范

### SKILL.md 结构

每个技能必须包含：

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
## 注意事项
## API 参考
## 返回结果
```

### 代码风格

- 使用清晰的中文描述
- 提供具体的使用示例
- 包含错误处理说明
- 参考 API 文档链接

### 测试

添加新技能时，在 `TEST-GUIDE.md` 中添加测试用例：

```markdown
#### 你的新技能

```
测试：你的测试描述
预期：✅ 期望的结果
```
```

## 技能分类

我们欢迎以下类型的技能贡献：

### 即时通讯（IM）
- 消息相关
- 互动功能

### 文档操作
- 创建、读取、更新文档

### 数据管理
- 多维表格操作

### 协作功能
- 日程、任务等

### 新类别
- 如果你有新的想法，欢迎提出！

## PR 审查流程

1. **自动检查**
   - SKILL.md 格式验证
   - 必需字段完整性

2. **人工审查**
   - 功能完整性
   - 代码风格
   - 文档质量

3. **测试**
   - 在实际环境中测试
   - 确保不影响现有技能

4. **合并**
   - 审查通过后合并
   - 更新版本号

## 发布流程

1. 版本更新
2. 更新 CHANGELOG
3. 创建 GitHub Release
4. 通知用户

## 获取帮助

- 查看 [README.md](README.md)
- 查看 [TEST-GUIDE.md](TEST-GUIDE.md)
- 在 Issues 中提问
- 在 Discussions 中讨论

## 行为准则

- 尊重所有贡献者
- 建设性反馈
- 专注于改进
- 共同学习成长

---

再次感谢你的贡献！🦞

name: Bug report
description: 报告问题帮助我们改进
title: '[Bug]: '
labels: ['bug']
body:
  - type: markdown
    attributes:
      value: |
        感谢报告问题！请填写以下信息帮助我们定位和解决问题。
  - type: textarea
    id: description
    attributes:
      label: 问题描述
      description: 清楚地描述你遇到的问题
      placeholder: |
        当我...时，发生了...
        我期望...，但实际...
    validations:
      required: true
  - type: textarea
    id: steps
    attributes:
      label: 重现步骤
      description: 如何重现这个问题
      placeholder: |
        1. 使用技能：...
        2. 输入：...
        3. 期望结果：...
        4. 实际结果：...
    validations:
      required: true
  - type: textarea
    id: environment
    attributes:
      label: 环境信息
      description: 运行环境信息
      placeholder: |
        - OpenClaw 版本：
        - 飞书 MCP 插件版本：
        - 操作系统：
        - 其他相关信息：
    validations:
      required: true
  - type: textarea
    id: logs
    attributes:
      label: 错误日志
      description: 粘贴相关的错误日志
      render: shell
  - type: checkboxes
    id: terms
    attributes:
      label: 确认
      options:
        - label: 我已经搜索过已有的 Issues
          required: true
        - label: 我已经使用最新版本
          required: true

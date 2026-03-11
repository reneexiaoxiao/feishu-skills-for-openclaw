name: Feature request
description: 建议新功能或改进
title: '[Feature]: '
labels: ['enhancement']
body:
  - type: markdown
    attributes:
      value: |
        感谢建议新功能！请详细描述你的想法。
  - type: textarea
    id: problem
    attributes:
      label: 问题或需求
      description: 这个功能解决什么问题？
      placeholder: |
        当我使用...时，我需要...
    validations:
      required: true
  - type: textarea
    id: solution
    attributes:
      label: 建议的解决方案
      description: 你希望如何实现这个功能？
      placeholder: |
        我建议添加一个新的技能...
        或修改现有技能以支持...
    validations:
      required: true
  - type: textarea
    id: alternatives
    attributes:
      label: 替代方案
      description: 你考虑过哪些替代方案？
      placeholder: |
        方案1：...
        方案2：...
  - type: textarea
    id: additional
    attributes:
      label: 其他信息
      description: 其他相关的截图、链接或信息

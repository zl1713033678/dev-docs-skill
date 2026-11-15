# AGENTS.md · 研发与 AI 编程协作宪章

> 任何开发者或 AI Agent 在阅读、修改本项目代码前，**必须先阅读本文档与 [`docs/STATUS.md`](./docs/STATUS.md)**，严守以下领域不变量与协作门禁。

## 1. 核心代码地图

```text
{{SOURCE_TREE_SUMMARY}}
```

## 2. 不可违背的领域与工程红线（Hard Invariants）

1. **{{INVARIANT_1_TITLE}}**：{{INVARIANT_1_RULE}}
2. **{{INVARIANT_2_TITLE}}**：{{INVARIANT_2_RULE}}
3. **{{INVARIANT_3_TITLE}}**：{{INVARIANT_3_RULE}}

## 3. 文档、排障与特性孵化流规

1. **特性孵化禁令（Spec Gate）**：`docs/specs/` 下的 `PLANNED` 文档仅作设计储备，**未经明确指令严禁擅自编写业务代码**；获准落地后必须同步回写 `docs/specs/README.md` 完成时间戳并刷新 `docs/STATUS.md`。
2. **科学排障闭环（Bug Fix Gate）**：
   - 发现新缺陷先登记至 [`docs/BUGS.md`](./docs/BUGS.md)（标注 `S0~S3` 与精确 `file:line`）；
   - 修复时坚持 **先写失败测试复现（Red）→ 单一职责最小修复（Green）→ 全量回归**，严禁搭车重构无关模块；
   - 验收通过后将该条目从 `docs/BUGS.md` 移除并归档至 [`CHANGELOG.md`](./CHANGELOG.md)。
3. **禁止补丁式追加过期说明**：`docs/STATUS.md` 采用**覆写式更新**（始终 ≤80 行，只反映当前真实横截面），严禁保留前后矛盾的旧状态描述。

## 4. 构建与验证必跑命令

- **自动化回归测试**：`{{TEST_COMMAND}}`
- **构建与静态校验**：`{{BUILD_COMMAND}}`

# {{PROJECT_NAME}} 当前工程状态快照 (Single Source of Truth)

> **最后更新**：`{{YYYY-MM-DD}}` ｜ **当前基线**：`{{VERSION}}` ｜ **版本库**：`{{GIT_BRANCH_INFO}}` ｜ **自动化测试**：`{{TEST_SUMMARY}}`
> **维护规则**：本文件采用**覆写式更新**（上限 80 行），始终真实反映当下代码库的成熟度边界与下一步焦点。

---

## 1. 模块成熟度真伪矩阵 (Truth Matrix)

> **成熟度定义**：`L1 [Demo模拟]` ｜ `L1.5 [混合原型]` ｜ `L2 [真实逻辑闭环]` ｜ `L3 [自动化测试与并发锁加固]` ｜ `L4 [生产就绪]`

| 模块 | 等级 | 已真实落地并验证的能力 (Real & Verified) | 仍属演示模拟或待补齐缺口 (Mock / Gap) |
| :--- | :---: | :--- | :--- |
| `{{MODULE_01}}` | **L2** | {{REAL_CAPABILITY_01}} | {{MOCK_OR_GAP_01}} |
| `{{MODULE_02}}` | **L1.5** | {{REAL_CAPABILITY_02}} | {{MOCK_OR_GAP_02}} |

---

## 2. 质量、底座与孵化池状态

- **数据与运行底座**：{{INFRA_HEALTH_NOTE}}
- **活跃缺陷单**：`S0 = 0`、`S1 = 0`（未修项详见 [`docs/BUGS.md`](./BUGS.md)）。
- **待孵化特性池**：共 `{{SPEC_COUNT}}` 项处于 `📝 PLANNED` 待命态（详见 [`docs/specs/README.md`](./specs/README.md)）。

---

## 3. 下一步高优行动清单 (Next 3 Priorities)

1. **[P0 止血/加固]**：{{NEXT_ACTION_1}}
2. **[P1 核心演进]**：{{NEXT_ACTION_2}}
3. **[按需特性孵化]**：{{NEXT_ACTION_3}}

---
name: dev-docs
description: Use this skill whenever creating, auditing, reorganizing, or maintaining project documentation, architecture decision records (ADR), feature specs/RFCs, bug tracking ledgers, changelogs, or project progress handoffs (STATUS/HANDOFF). Applies Docs-as-Code, Code-First Truth Matrix (L1-L4), Spec Gate, and Red-Green Bug lifecycle rules.
license: MIT
---

# 专业开发文档编制与防膨胀治理 (Docs-as-Code Workflow)

本技能提供一套面向真实软件工程与人机协作的**防腐烂、防膨胀文档治理标准工作流**。核心铁律：**永远不要用“只追加不重构的长篇流水账”对抗代码演化；代码能表达的绝不重复手抄，文档只记录「为什么（ADR）」、「真伪成熟度横截面（Truth Matrix）」、「活跃未修缺陷（BUGS）」与「待孵化方案（Specs）」。**

当执行文档新建、旧文档重构、Bug 记录修复或进度交接更新时，按以下对应模式操作。详细反模式拆解参阅 `references/anti-rot-principles.md`，存量重构步骤参阅 `references/migration-playbook.md`，标准模板位于 `templates/`。

---

## 一、 目标五层文档标准结构与行数红线

```text
<project-root>/
├── README.md                                  # [入口契约 | ≤100行] 5分钟跑通：定位、架构速览、启停命令、环境变量、文档导航地图
├── AGENTS.md                                  # [研发与AI宪章 | ≤100行] 领域硬红线(Invariants)、核心代码地图、协作门禁、必跑验证命令
├── CHANGELOG.md                               # [历史归档层 | 只增不改] 已完成特性里程碑与已闭环 Bug 记录（从日常交接上下文剥离）
└── docs/
    ├── STATUS.md                              # [实时交接快照 | ≤80行·覆写更新] 唯一交接入口：模块真实度矩阵(L1~L4) + 下一步3项焦点
    ├── BUGS.md                                # [活跃缺陷台账 | 动态清零] 仅保留当前 OPEN/WIP 的 S0~S3 缺陷；修完验通即移入 CHANGELOG
    ├── adr/                                   # [架构决策库 | 每篇≤70行] 一决策一文件，固化核心选型的 Context -> Decision -> Consequences
    │   └── 0001-<decision-slug>.md
    ├── specs/                                 # [特性孵化器 | 一特性一文件] 只记设计、未经指令不写代码；落地后强制回写时间戳
    │   ├── README.md                          # 特性总览索引表 (编号 / 状态 PLANNED|WIP|COMPLETED / 提出与完成时间戳)
    │   └── SPEC-001-<feature-slug>.md
    └── guides/                                # [使用运维与业务手册 | 低频按需查阅] 用户手册、部署切换清单、产品愿景/竞品对比
```

---

## 二、 四大标准作业模式 (Operational Modes)

### 模式 A：全新项目建档 (Bootstrap)
1. 检查项目是否已初始化 Git 与 `.gitignore`（确保运行态数据库 `*.db*`、构建产物 `dist/`、依赖目录 `node_modules/`、`__pycache__/` 与敏感配置 `.env` 被物理隔离，并提供 `.env.example`）。
2. 读取 `templates/` 下对应模板，结合真实源码结构生成 `README.md`、`AGENTS.md`、`CHANGELOG.md`、`docs/STATUS.md`、`docs/BUGS.md` 与 `docs/specs/README.md`。
3. 仅在确实存在重要技术取舍或外部使用说明需求时创建 `docs/adr/` 与 `docs/guides/`，**严禁生成无实质内容的空壳占位文档**。

### 模式 B：存量旧文档审计与无损拆分重构 (Audit & Reorganize)
当项目存在臃肿的 `HANDOFF.md`、`NOTES.md` 或与代码脱节的旧文档时，严格按 `references/migration-playbook.md` 执行：
1. **代码事实先行（Code-First Audit）**：先审计真实源码（路由、ORM 模型、配置、测试与数据库状态），再通读旧文档，识别三类典型腐烂：
   - *内部时空穿越*：前文列为“待办风险”，后文补丁却写“已修复”；
   - *真伪边界失真*：将硬编码模拟返回（Mock/Demo）描述成“已实装生产能力”；
   - *架构描述过期*：旧 `README` 模块数量或布局与最新前端代码不一致。
2. **安全备份原稿**：先将原有旧文档完整移存至备份目录（如 `旧文档/` 或 `docs/_archive/`，并加入 `.gitignore`），确保用户历史文字零丢失。
3. **按生命周期无损拆解清洗**：
   - 最新架构速览与启动方式 → 刷新合并至 `README.md`；
   - 不可违背的领域不变量与协作流规 → 浓缩至 `AGENTS.md`；
   - 各模块真实代码成熟度（区分真逻辑与 Mock 缺口）→ 建立 `docs/STATUS.md`；
   - 审计发现的真实未修缺陷 → 编号立项至 `docs/BUGS.md`；
   - 重大架构选型理由（Why A over B）→ 提炼为独立 `docs/adr/000X-*.md`；
   - 尚未落地的特性构想（剔除已过期段落后）→ 拆分为独立 `docs/specs/SPEC-00X-*.md` 并登记索引；
   - 已完成的功能与历史修复流水 → 全部转为过去式归档至 `CHANGELOG.md`；
   - 终端用户操作指南、运维部署清单与产品优劣势对比 → 归入 `docs/guides/`。

### 模式 C：缺陷检查、修复与文档同步闭环 (Red-Green Bug Gate)
1. **定级入账**：发现缺陷先写入 `docs/BUGS.md`，标注级别（`S0` 越权/资损/数据损坏、`S1` 主流程算错/并发丢更新、`S2` 边缘逻辑偏差、`S3` 体验瑕疵）、精确 `file:line` 坐标与复现证据。
2. **先红后绿**：改业务代码前**必须先写最小失败测试复现（Red）** → 执行单一职责最小修复（Green，严禁搭车重构无关模块）→ 跑通全量回归。
3. **清零归档**：验收通过后，将该缺陷从 `docs/BUGS.md` 移除，归档至 `CHANGELOG.md` 的 `Fixed / Security` 小节，并同步更新 `docs/STATUS.md` 的测试计数与成熟度等级。

### 模式 D：新想法孵化与进度横截面维护 (Spec Gate & Status Sync)
1. **特性孵化禁令（Spec Gate）**：用户提出规划性新想法时，在 `docs/specs/` 下新建独立 `SPEC-00X-*.md` 并在 `docs/specs/README.md` 登记为 `📝 PLANNED`。**未经用户明确开发指令，严禁修改业务代码。**
2. **真实度矩阵（Truth Matrix）诚实分级**：在 `docs/STATUS.md` 中严禁笼统填写“已完成”，必须按四级标注并写明 Mock 缺口：
   - `L1 [Demo模拟]`：仅 UI 与硬编码模拟返回；
   - `L1.5 [混合原型]`：数据库/账务已通，但核心算法或外部通道仍为模拟；
   - `L2 [逻辑闭环]`：前后端真实业务逻辑与权限校验闭环；
   - `L3 [测试加固]`：具备自动化回归/属性测试覆盖与并发锁保护；
   - `L4 [生产就绪]`：完成真实外部对接、安全加固、压测与监控。
3. **覆写而非追加**：每次阶段交付后，直接**覆写刷新** `docs/STATUS.md`（保持 ≤80 行），并在对应 Spec 完成后回填精确时间戳 `YYYY-MM-DD HH:mm:ss+08:00`。

---

## 三、 自动化文档体检收尾 (Mandatory Verification)

每次完成文档编制或重构后，运行本技能自带的校验脚本检查断链与行数膨胀：

```bash
python "<skill-base-dir>/scripts/verify_docs.py" "<project-root>"
```

确保输出 `0 broken links` 且核心高频文件（`README.md`、`AGENTS.md`、`docs/STATUS.md`）均未超出预算行数上限后再提交 Git。

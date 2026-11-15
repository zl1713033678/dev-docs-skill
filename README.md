# dev-docs-skill · 专业开发文档编制与防膨胀治理 Skill

一套适用于 **OpenCode V2**、**Claude Code** 及通用 **Agent Skills (`SKILL.md`)** 生态的工业级软件工程文档治理技能包（Skill ID：`dev-docs`）。

核心目标：**终结“只追加不重构的巨石 `HANDOFF.md`”、“代码与文档三天脱节”以及“把模拟 Demo 标成已完成”三大研发痛点**，建立轻量、诚实、可自动体检的 **Docs-as-Code 五层文档体系**。

---

## 一、 核心治理能力

1. **五层读写分离文档架构（严格控制上下文体积）**
   - `README.md`（≤100 行）：5 分钟跑通契约、最新模块地图与环境变量速查。
   - `AGENTS.md`（≤100 行）：领域硬红线（Invariants）、Spec 孵化禁令、Bug 修复门禁与必跑命令。
   - `docs/STATUS.md`（≤80 行 · **覆写更新**）：唯一实时交接横截面，基于纯代码审计维护 **`L1 Demo ~ L4 生产就绪` 真实度矩阵（Truth Matrix）**。
   - `docs/BUGS.md`（动态清零）：仅保留未修复的 `S0~S3` 真实缺陷；修完验通立即移入 `CHANGELOG.md`。
   - `docs/adr/` + `docs/specs/` + `docs/guides/`：架构决策记录（Why）、一特性一文件的按需孵化器（未经指令不写代码）与低频使用手册。
2. **四大标准作业流**
   - **全新立项建档（Bootstrap）**：一键建立标准五层文档与 `.gitignore` 隔离基线。
   - **存量旧文档无损重构（Audit & Reorganize）**：先审计真实源码，再比对旧文档清洗时空矛盾，原稿字节级备份后无损拆解。
   - **科学排障同步（Red-Green Bug Gate）**：建单定级 → 先写失败测试复现（Red）→ 最小原子化修复（Green）→ `BUGS.md` 清零归档 `CHANGELOG.md`。
   - **特性孵化与进度横截面同步（Spec Gate & Truth Matrix）**：新点子先落 `SPEC-XXX.md` 标 `PLANNED`，完成后回填精确时间戳并覆写刷新 `STATUS.md`。
3. **内置自动化体检脚本（`verify_docs.py`）**
   - 自动扫描全仓 Markdown 相对路径断链（剥离代码块干扰）并核查核心文档防膨胀行数预算。

---

## 二、 安装与接入方式

### 方式 1：OpenCode V2 零克隆远程挂载（HTTP Catalog）
直接在全局 `~/.config/opencode/opencode.json`（或项目 `opencode.json`）中添加本仓库的 Catalog 地址，无需手动下载文件：

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "skills": [
    "https://raw.githubusercontent.com/zl1713033678/dev-docs-skill/main/skills/"
  ]
}
```

### 方式 2：本地克隆并实时联动挂载（适合二次定制）
克隆仓库后，将本地 `skills` 目录加入 `~/.config/opencode/opencode.json`，修改本地模板即刻热重载生效：

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "skills": [
    "D:/Code/开发文档编制skill/skills"
  ]
}
```

### 方式 3：一键安装脚本（支持 OpenCode / Claude Code / `.agents`）
```powershell
# Windows PowerShell（可选参数: opencode | claude | agents | all）
pwsh -NoProfile -File .\scripts\install.ps1 -Target all
```
```bash
# macOS / Linux
bash ./scripts/install.sh all
```

---

## 三、 使用示例

安装或挂载后，Agent 会在涉及文档编制、交接整理、Bug 记录与进度更新时自动加载 `dev-docs`；你也可以在对话中显式通过 `@dev-docs` 调用：

- `@dev-docs 审计当前项目代码与现有文档，备份旧文档后按五层规范无损拆分重构`
- `@dev-docs 为这个新项目初始化标准文档体系与 AGENTS.md 工程红线`
- `@dev-docs 把刚才讨论的后台巡检方案写入 specs 孵化器（暂不写代码）`
- `@dev-docs 按先红后绿流程修复 BUGS.md 中的 S0 问题并同步更新文档`

---

## 四、 仓库目录结构

```text
dev-docs-skill/
├── scripts/{install.ps1, install.sh}        # Windows / macOS / Linux 一键安装脚本
└── skills/
    ├── index.json                           # OpenCode V2 HTTP Catalog 索引清单
    └── dev-docs/                            # Skill ID: dev-docs
        ├── SKILL.md                         # 核心工作流指令与五层规范
        ├── references/                      # 防腐烂原则详解与存量迁移 6 步手册
        ├── scripts/verify_docs.py           # 零依赖 Python 文档体检脚本（断链 + 行数红线）
        └── templates/                       # 8 份标准 Markdown 骨架模板 (README/AGENTS/STATUS/BUGS/ADR/SPEC...)
```

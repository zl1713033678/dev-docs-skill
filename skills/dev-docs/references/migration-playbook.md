# 存量旧文档审计与无损重构操作手册 (Migration Playbook)

当接手一个已有 `README.md`、`HANDOFF.md`、`NOTES.md`、`TODO.md` 或 `BRANCH_IDEAS.md` 的存量项目并执行文档治理重构时，严格按以下 6 步 SOP 执行：

## Step 1：纯代码基线扫描（先看代码，后看旧文档）
- 扫描目录结构、依赖清单（`package.json` / `requirements.txt` / `pyproject.toml`）、数据库模型、API 路由、启停脚本以及测试覆盖情况。
- 检查是否已初始化 Git 仓库及 `.gitignore` 是否漏排运行态文件（如 `*.db`、`dist/`、`node_modules/`、`.env`）。
- 区分每个模块的**真实代码实现**与**硬编码模拟（Mock/Demo）边界**，记录客观发现的真实未修缺陷。

## Step 2：旧文档交叉比对与病灶提取
通读全部现有 `.md` 文档，逐条核对以下冲突清单：
1. **布局/模块数量漂移**：旧 `README` 描述的模块数、目录路径、端口或启动命令是否已被最新代码淘汰？
2. **待办 vs 已修冲突**：同一文档或跨文档中，是否有前文标为“待解决风险”、后文却写“已完成修复”的段落？
3. **夸大承诺失真**：文档是否把尚未接通真实 SDK/硬件的模拟逻辑写成了已上线能力？
4. **单文件膨胀风险**：是否存在把多个待孵化分支构想堆砌在单个文件（如 `BRANCH_IDEAS.md`）的趋势？

## Step 3：向用户展示《拆解与清洗映射表》（若用户尚未确认方案）
用清晰表格交代原文档每一章节的去向（合并刷新 / 清洗迁出 / 提炼 ADR / 下沉 CHANGELOG / 独立成册），明确指出哪些过期冲突句子将被剔除，确保有据可查。

## Step 4：字节级原样备份旧文档
- 创建归档备份目录（如 `<project-root>/旧文档/` 或 `docs/_archive/`，并将其加入 `.gitignore`）。
- 将原有的旧文档原封不动复制/移入备份目录，验证文件字节数完整无损后，再清理根目录下的冗余旧交接单。

## Step 5：生成五层标准文档树
1. 编写最新 `README.md`（附完整文档导航表）与 `AGENTS.md`（固化领域不变量、Spec Gate 与 Bug Fix Gate）。
2. 建立 `docs/STATUS.md`（填入客观的 `L1~L4` 模块真实度矩阵与 Next 3 Priorities）和 `docs/BUGS.md`（登记代码审计确认的真实未修缺陷）。
3. 将宝贵的架构取舍背景提炼至 `docs/adr/000X-*.md`。
4. 将尚未落地的特性方案拆分至 `docs/specs/SPEC-00X-*.md`（清洗掉已被修复的旧背景），并在 `docs/specs/README.md` 建立总览索引表。
5. 将所有已完成的历史功能与过往修复记录按版本整理至 `CHANGELOG.md`。
6. 将面向终端用户、运维部署与商业汇报的长文迁入 `docs/guides/`。

## Step 6：运行自动化校验与约定式提交
- 执行 `python "<skill-dir>/scripts/verify_docs.py" "<project-root>"` 验证 **零断链（0 broken links）** 且各核心文件行数达标。
- 若项目启用了 Git，使用 `docs(reorg): ...` 或 `chore(repo): ...` 约定式提交固化新基线。

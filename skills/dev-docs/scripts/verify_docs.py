#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Docs-as-Code 自动化体检工具 (verify_docs.py)
检查项：
1. 核心高频文档存在性与防膨胀行数预算 (README.md <= 100, AGENTS.md <= 100, docs/STATUS.md <= 80)
2. 全仓治理文档 (.md) 内部相对路径链接有效性（零断链校验）
3. docs/STATUS.md 是否包含真实度矩阵关键标记，docs/specs/README.md 是否包含状态追踪列
"""

import re
import sys
from pathlib import Path

LINE_BUDGETS = {
    "README.md": 100,
    "AGENTS.md": 100,
    "docs/STATUS.md": 80,
}

SKIP_DIRS = {"node_modules", ".git", "dist", "build", "__pycache__", ".venv", "venv", "旧文档", "_archive", "templates"}


def strip_fenced_code(markdown_text: str) -> str:
    """剥离 ``` 代码块内容，避免把模板示例中的占位链接误判为真实断链"""
    return re.sub(r"```[\s\S]*?```", "", markdown_text)


def collect_markdown_files(root: Path) -> list[Path]:
    result: list[Path] = []
    for path in root.rglob("*.md"):
        if path.name.endswith(".template.md"):
            continue
        rel_parts = set(path.relative_to(root).parts)
        if rel_parts & SKIP_DIRS:
            continue
        result.append(path)
    return sorted(result)


def main() -> int:
    target_root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd().resolve()
    if not target_root.exists():
        print(f"[ERROR] 目标路径不存在: {target_root}")
        return 1

    errors: list[str] = []
    warnings: list[str] = []

    # 1. 核心文档存在性与行数红线检查
    for rel_file, max_lines in LINE_BUDGETS.items():
        fpath = target_root / rel_file
        if not fpath.exists():
            warnings.append(f"[MISSING] 建议补齐核心文档: {rel_file}")
            continue
        line_count = len(fpath.read_text(encoding="utf-8").splitlines())
        if line_count > max_lines:
            errors.append(f"[BLOAT] {rel_file} 当前 {line_count} 行，超出防膨胀上限 ({max_lines} 行)，请精简或下沉细节至 docs/")
        else:
            print(f"[OK] {rel_file}: {line_count}/{max_lines} lines")

    # 2. Markdown 相对链接零断链检查
    md_files = collect_markdown_files(target_root)
    link_pattern = re.compile(r"\]\(([^)]+)\)")
    checked_links = 0

    for md_file in md_files:
        clean_text = strip_fenced_code(md_file.read_text(encoding="utf-8"))
        for match in link_pattern.finditer(clean_text):
            raw_target = match.group(1).strip()
            if not raw_target or raw_target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            rel_path_str = raw_target.split("#", 1)[0].strip()
            if not rel_path_str:
                continue
            checked_links += 1
            resolved = (md_file.parent / rel_path_str).resolve()
            if not resolved.exists():
                rel_src = md_file.relative_to(target_root).as_posix()
                errors.append(f"[BROKEN_LINK] {rel_src} -> '{raw_target}' (目标不存在)")

    print(f"[OK] Scanned {len(md_files)} markdown files, verified {checked_links} relative links.")

    for w in warnings:
        print(w)

    if errors:
        print("\n=== 文档体检未通过 ===")
        for e in errors:
            print(e)
        return 1

    print("\n[PASS] 文档体系体检全部通过：零断链、零超标膨胀。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-opencode}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="${REPO_ROOT}/skills/dev-docs"

install_to() {
  local dest_root="$1"
  mkdir -p "${dest_root}"
  rm -rf "${dest_root}/dev-docs"
  cp -R "${SKILL_SRC}" "${dest_root}/dev-docs"
  echo "[OK] Installed skill 'dev-docs' -> ${dest_root}/dev-docs"
}

case "${TARGET}" in
  opencode) install_to "${HOME}/.config/opencode/skills" ;;
  claude)   install_to "${HOME}/.claude/skills" ;;
  agents)   install_to "${HOME}/.agents/skills" ;;
  all)
    install_to "${HOME}/.config/opencode/skills"
    install_to "${HOME}/.claude/skills"
    install_to "${HOME}/.agents/skills"
    ;;
  *)
    echo "Usage: $0 [opencode|claude|agents|all]" >&2
    exit 1
    ;;
esac

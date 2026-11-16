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

install_antigravity() {
  local plugin_dest="${HOME}/.gemini/config/plugins/dev-docs-skill"
  mkdir -p "${plugin_dest}/assets"
  cp "${REPO_ROOT}/plugin.json" "${plugin_dest}/plugin.json"
  cp "${REPO_ROOT}/assets/logo.svg" "${plugin_dest}/assets/logo.svg"
  install_to "${plugin_dest}/skills"
  echo "[OK] Installed Antigravity plugin 'dev-docs-skill' -> ${plugin_dest}"
}

case "${TARGET}" in
  opencode)    install_to "${HOME}/.config/opencode/skills" ;;
  claude)      install_to "${HOME}/.claude/skills" ;;
  agents)      install_to "${HOME}/.agents/skills" ;;
  antigravity) install_antigravity ;;
  all)
    install_to "${HOME}/.config/opencode/skills"
    install_to "${HOME}/.claude/skills"
    install_to "${HOME}/.agents/skills"
    install_antigravity
    ;;
  *)
    echo "Usage: $0 [opencode|claude|agents|antigravity|all]" >&2
    exit 1
    ;;
esac

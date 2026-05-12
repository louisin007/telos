#!/usr/bin/env bash
#
# Telos installer — Cybersecurity Services Practice CLI
# Run: curl -fsSL https://raw.githubusercontent.com/louisin007/telos/main/install.sh | bash
#

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────────────
TELOS_REPO="${TELOS_REPO:-https://github.com/louisin007/telos.git}"
TELOS_BRANCH="${TELOS_BRANCH:-main}"
UPSTREAM_SKILLS_REPO="https://github.com/mukul975/Anthropic-Cybersecurity-Skills.git"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.telos}"
SHELL_RC=""

# ──────────────────────────────────────────────────────────────────────
# Colours
# ──────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

say()  { echo -e "${GREEN}▶${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
die()  { echo -e "${RED}✗${NC} $*" >&2; exit 1; }

# ──────────────────────────────────────────────────────────────────────
# Banner
# ──────────────────────────────────────────────────────────────────────
cat <<'EOF'

  ┌─────────────────────────────────────────────────┐
  │   TELOS — Cybersecurity Services Practice CLI   │
  │   Installer v1.0                                │
  └─────────────────────────────────────────────────┘

EOF

# ──────────────────────────────────────────────────────────────────────
# Detect shell and rc file
# ──────────────────────────────────────────────────────────────────────
detect_shell() {
  if [[ -n "${ZSH_VERSION:-}" ]] || [[ "${SHELL:-}" == *"zsh" ]]; then
    SHELL_RC="$HOME/.zshrc"
  elif [[ -n "${BASH_VERSION:-}" ]] || [[ "${SHELL:-}" == *"bash" ]]; then
    SHELL_RC="$HOME/.bashrc"
  else
    SHELL_RC="$HOME/.profile"
    warn "Unrecognised shell — using $SHELL_RC"
  fi
  say "Shell config: $SHELL_RC"
}

# ──────────────────────────────────────────────────────────────────────
# Prerequisite checks
# ──────────────────────────────────────────────────────────────────────
check_prerequisites() {
  say "Checking prerequisites..."

  local missing=()
  command -v git >/dev/null || missing+=("git")
  command -v python3 >/dev/null || missing+=("python3")
  command -v claude >/dev/null || missing+=("claude-code")

  if [[ ${#missing[@]} -gt 0 ]]; then
    warn "Missing dependencies: ${missing[*]}"
    echo
    echo "Install instructions:"
    for dep in "${missing[@]}"; do
      case "$dep" in
        git)         echo "  - git:         sudo apt install git -y" ;;
        python3)     echo "  - python3:     sudo apt install python3 -y" ;;
        claude-code) echo "  - claude-code: see https://docs.claude.com/claude-code" ;;
      esac
    done
    echo
    die "Please install missing prerequisites and re-run this installer."
  fi

  say "All prerequisites present (git, python3, claude)"
}

# ──────────────────────────────────────────────────────────────────────
# Install telos
# ──────────────────────────────────────────────────────────────────────
install_telos() {
  if [[ -d "$INSTALL_DIR" ]]; then
    warn "$INSTALL_DIR already exists."
    read -p "Remove and reinstall? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      die "Aborted by user."
    fi
    rm -rf "$INSTALL_DIR"
  fi

  say "Cloning Telos to $INSTALL_DIR ..."
  git clone --depth 1 --branch "$TELOS_BRANCH" "$TELOS_REPO" "$INSTALL_DIR" >/dev/null 2>&1 \
    || die "Failed to clone $TELOS_REPO (private repo? check auth)"

  say "Cloning upstream cybersecurity skill library (754 skills) ..."
  git clone --depth 1 "$UPSTREAM_SKILLS_REPO" "$INSTALL_DIR/.agents/cybersecurity-skills" >/dev/null 2>&1 \
    || die "Failed to clone upstream skills"

  if [[ -d "$INSTALL_DIR/.agents/cybersecurity-skills/skills" ]]; then
    ln -s "$INSTALL_DIR/.agents/cybersecurity-skills/skills" "$INSTALL_DIR/.agents/skills"
  fi

  say "Building upstream skill index ..."
  python3 "$INSTALL_DIR/scripts/generate-upstream-index.py" >/dev/null

  say "Building combined skill index ..."
  python3 "$INSTALL_DIR/scripts/build-combined-index.py"

  chmod +x "$INSTALL_DIR/bin/telos"
}

# ──────────────────────────────────────────────────────────────────────
# Update PATH
# ──────────────────────────────────────────────────────────────────────
update_path() {
  local path_line="export PATH=\"\$PATH:$INSTALL_DIR/bin\""

  if grep -Fxq "$path_line" "$SHELL_RC" 2>/dev/null; then
    say "PATH already configured in $SHELL_RC"
    return
  fi

  echo "" >> "$SHELL_RC"
  echo "# Telos CLI" >> "$SHELL_RC"
  echo "$path_line" >> "$SHELL_RC"
  say "Added Telos to PATH in $SHELL_RC"
}

# ──────────────────────────────────────────────────────────────────────
# Post-install message
# ──────────────────────────────────────────────────────────────────────
post_install() {
  cat <<EOF

${GREEN}✓ Telos installed successfully!${NC}

Next steps:

  ${BOLD}1.${NC} Reload your shell:
       source $SHELL_RC

  ${BOLD}2.${NC} Verify install:
       telos version

  ${BOLD}3.${NC} List engagement types:
       telos list-types

  ${BOLD}4.${NC} Start your first engagement:
       telos scope "your target description here"

Documentation: $INSTALL_DIR/README.md
Output goes to: \$PWD/output/ (wherever you run telos from)

${YELLOW}⚠ Make sure Claude Code is configured with a valid model:${NC}
   Run 'claude' once interactively to confirm.

EOF
}

# ──────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────
main() {
  detect_shell
  check_prerequisites
  install_telos
  update_path
  post_install
}

main

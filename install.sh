#!/usr/bin/env bash
# install.sh — Symlink ai-skills into Cursor and/or Claude Code skills folders.
#
# Usage:
#   bash install.sh           # prompts which agent to install for
#   bash install.sh --cursor  # Cursor only
#   bash install.sh --claude  # Claude Code only
#   bash install.sh --both    # both at once

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

CURSOR_DIR="$HOME/.cursor/skills"
CLAUDE_DIR="$HOME/.claude/skills"

# ── Counters ────────────────────────────────────────────────────────────────
linked=0
already_ok=0
replaced_broken=0
skipped_conflict=0

# ── Helper: install one skill into one target folder ────────────────────────
install_skill() {
  local skill_path="$1"   # absolute path to skill folder in repo
  local target_dir="$2"   # e.g. ~/.cursor/skills
  local name
  name=$(basename "$skill_path")
  local link="$target_dir/$name"

  if [ -L "$link" ]; then
    local current_target
    current_target=$(readlink "$link")
    if [ "$current_target" = "$skill_path" ] && [ -d "$skill_path" ]; then
      # Already linked and valid
      already_ok=$((already_ok + 1))
      return
    else
      # Broken or stale symlink — replace it
      rm "$link"
      ln -s "$skill_path" "$link"
      echo "  replaced  $name  (was pointing to: $current_target)"
      replaced_broken=$((replaced_broken + 1))
      return
    fi
  fi

  if [ -e "$link" ]; then
    # Real folder or file — do not overwrite
    echo "  SKIPPED   $name  (a non-symlink folder already exists at $link — remove it manually to re-link)"
    skipped_conflict=$((skipped_conflict + 1))
    return
  fi

  ln -s "$skill_path" "$link"
  echo "  linked    $name"
  linked=$((linked + 1))
}

# ── Helper: install all skills into one target folder ───────────────────────
install_all() {
  local target_dir="$1"
  mkdir -p "$target_dir"

  while IFS= read -r skill_md; do
    local skill_path
    skill_path=$(dirname "$skill_md")
    install_skill "$skill_path" "$target_dir"
  done < <(find "$SKILLS_DIR" \
    -mindepth 2 -maxdepth 3 \
    -not -path "*/archive/*" \
    -name "SKILL.md")
}

# ── Argument parsing / prompt ────────────────────────────────────────────────
MODE="${1:-}"

if [ -z "$MODE" ]; then
  echo ""
  echo "Where do you want to install the skills?"
  echo "  1) Cursor"
  echo "  2) Claude Code"
  echo "  3) Both"
  echo ""
  read -rp "Enter 1, 2, or 3: " choice
  case "$choice" in
    1) MODE="--cursor" ;;
    2) MODE="--claude" ;;
    3) MODE="--both"   ;;
    *) echo "Invalid choice. Run the script again and enter 1, 2, or 3."; exit 1 ;;
  esac
fi

# ── Run ──────────────────────────────────────────────────────────────────────
echo ""
case "$MODE" in
  --cursor)
    echo "Installing into $CURSOR_DIR ..."
    echo ""
    install_all "$CURSOR_DIR"
    echo ""
    echo "Done. Restart Cursor to pick up the new skills."
    ;;
  --claude)
    echo "Installing into $CLAUDE_DIR ..."
    echo ""
    install_all "$CLAUDE_DIR"
    echo ""
    echo "Done. Skills will be discovered automatically on next Claude Code invocation."
    ;;
  --both)
    echo "Installing into $CURSOR_DIR ..."
    echo ""
    install_all "$CURSOR_DIR"
    echo ""
    echo "Installing into $CLAUDE_DIR ..."
    echo ""
    install_all "$CLAUDE_DIR"
    echo ""
    echo "Done. Restart Cursor and re-invoke Claude Code to pick up the new skills."
    ;;
  *)
    echo "Unknown option: $MODE"
    echo "Usage: bash install.sh [--cursor | --claude | --both]"
    exit 1
    ;;
esac

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────"
echo "  Linked:          $linked"
echo "  Already up to date: $already_ok"
echo "  Replaced (broken):  $replaced_broken"
if [ "$skipped_conflict" -gt 0 ]; then
  echo "  Skipped (conflict): $skipped_conflict  ← action needed (see above)"
fi
echo "────────────────────────────────"

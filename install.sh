#!/usr/bin/env bash
# install.sh — Symlink ai-skills into Cursor and/or Claude Code skills folders.
#              Also packages Cowork plugins directly from source — no intermediate copies.
#
# Usage:
#   bash install.sh                   # prompts which agent to install for
#   bash install.sh --cursor          # Cursor only
#   bash install.sh --claude          # Claude Code only
#   bash install.sh --both            # both at once
#   bash install.sh --package-cowork  # package Cowork plugins as .zip files for upload

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
PLUGINS_DIR="$REPO_DIR/cowork-plugins"
DIST_DIR="$PLUGINS_DIR/dist"

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
      already_ok=$((already_ok + 1))
      return
    else
      rm "$link"
      ln -s "$skill_path" "$link"
      echo "  replaced  $name  (was pointing to: $current_target)"
      replaced_broken=$((replaced_broken + 1))
      return
    fi
  fi

  if [ -e "$link" ]; then
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

# ── Rsync excludes applied to every skill copy ──────────────────────────────
RSYNC_EXCLUDES=(
  --exclude="archive/"
  --exclude="update-workspace/"
  --exclude="one-time-fix-prompt.md"
  --exclude="INSTALL.md"
  --exclude="Eval-Scenarios.md"
)

# ── Helper: package one Cowork plugin as a .zip directly from skills/ ───────
package_plugin() {
  local plugin="$1"
  local manifest_dir="$PLUGINS_DIR/$plugin"
  local zip_path="$DIST_DIR/$plugin.zip"
  local tmp_dir
  tmp_dir=$(mktemp -d)
  local plugin_tmp="$tmp_dir/$plugin"

  mkdir -p "$plugin_tmp/skills"

  # Copy plugin manifest and README
  cp -r "$manifest_dir/.claude-plugin" "$plugin_tmp/.claude-plugin"
  [ -f "$manifest_dir/README.md" ] && cp "$manifest_dir/README.md" "$plugin_tmp/README.md"

  # Copy skills directly from source — no intermediate copies
  case "$plugin" in
    pm-requirements)
      rsync -a "${RSYNC_EXCLUDES[@]}" "$SKILLS_DIR/requirements/" "$plugin_tmp/skills/"
      ;;
    pm-planning)
      rsync -a "${RSYNC_EXCLUDES[@]}" "$SKILLS_DIR/planning/" "$plugin_tmp/skills/"
      ;;
    pm-epics-stories)
      rsync -a "${RSYNC_EXCLUDES[@]}" "$SKILLS_DIR/epics-and-user-stories/" "$plugin_tmp/skills/"
      ;;
    pm-tools)
      for skill in design-to-context figjam-diagram-generator transcript-to-meeting-notes; do
        if [ -d "$SKILLS_DIR/$skill" ]; then
          rsync -a "${RSYNC_EXCLUDES[@]}" "$SKILLS_DIR/$skill/" "$plugin_tmp/skills/$skill/"
        else
          echo "  WARNING   $plugin/$skill — source not found at $SKILLS_DIR/$skill, skipping"
        fi
      done
      ;;
    *)
      echo "  SKIPPED   $plugin  (unknown plugin — no source mapping)"
      rm -rf "$tmp_dir"
      return
      ;;
  esac

  # Create zip
  rm -f "$zip_path"
  (cd "$tmp_dir" && zip -r "$zip_path" "$plugin" \
    --exclude "*.DS_Store" \
    --exclude "*/__pycache__/*" \
    -q)

  rm -rf "$tmp_dir"

  local size
  size=$(du -sh "$zip_path" | cut -f1)
  echo "  packaged  $plugin.zip  ($size)"
}

# ── Helper: package all Cowork plugins ──────────────────────────────────────
package_cowork_all() {
  mkdir -p "$DIST_DIR"

  echo "Packaging Cowork plugins from source ..."
  echo ""

  for plugin in pm-requirements pm-planning pm-epics-stories pm-tools; do
    package_plugin "$plugin"
  done

  echo ""
  echo "Zip files are in: $DIST_DIR"
  echo "Upload each .zip via Cowork → Customize → Personal plugins → +"
}

# ── Argument parsing / prompt ────────────────────────────────────────────────
MODE="${1:-}"

if [ -z "$MODE" ]; then
  echo ""
  echo "What would you like to do?"
  echo "  1) Install for Cursor"
  echo "  2) Install for Claude Code"
  echo "  3) Install for both"
  echo "  4) Package Cowork plugins as .zip files for upload"
  echo ""
  read -rp "Enter 1, 2, 3, or 4: " choice
  case "$choice" in
    1) MODE="--cursor" ;;
    2) MODE="--claude" ;;
    3) MODE="--both"   ;;
    4) MODE="--package-cowork" ;;
    *) echo "Invalid choice. Run the script again and enter 1–4."; exit 1 ;;
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
  --package-cowork)
    package_cowork_all
    echo ""
    echo "────────────────────────────────"
    exit 0
    ;;
  *)
    echo "Unknown option: $MODE"
    echo "Usage: bash install.sh [--cursor | --claude | --both | --package-cowork]"
    exit 1
    ;;
esac

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────"
echo "  Linked:             $linked"
echo "  Already up to date: $already_ok"
echo "  Replaced (broken):  $replaced_broken"
if [ "$skipped_conflict" -gt 0 ]; then
  echo "  Skipped (conflict): $skipped_conflict  ← action needed (see above)"
fi
echo "────────────────────────────────"

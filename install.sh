#!/usr/bin/env bash
# install.sh — Symlink ai-skills into Cursor and/or Claude Code skills folders.
#              Also syncs skill files into Cowork plugins.
#
# Usage:
#   bash install.sh                # prompts which agent to install for
#   bash install.sh --cursor       # Cursor only
#   bash install.sh --claude       # Claude Code only
#   bash install.sh --both         # both at once
#   bash install.sh --sync-cowork  # sync updated skills into Cowork plugins only

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
PLUGINS_DIR="$REPO_DIR/cowork-plugins"

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

# ── Helper: sync source skills into a Cowork plugin's skills/ folder ────────
sync_plugin() {
  local plugin="$1"          # e.g. pm-requirements
  local plugin_dir="$PLUGINS_DIR/$plugin/skills"

  if [ ! -d "$plugin_dir" ]; then
    echo "  SKIPPED   $plugin  (plugin folder not found at $plugin_dir)"
    return
  fi

  # Mapping: plugin name → source category folder
  local src_dir
  case "$plugin" in
    pm-requirements)   src_dir="$SKILLS_DIR/requirements" ;;
    pm-planning)       src_dir="$SKILLS_DIR/planning" ;;
    pm-epics-stories)  src_dir="$SKILLS_DIR/epics-and-user-stories" ;;
    *) echo "  SKIPPED   $plugin  (unknown plugin — no source mapping)"; return ;;
  esac

  local synced=0
  local unchanged=0

  # Sync each skill subfolder that already exists in the plugin
  for skill_dest in "$plugin_dir"/*/; do
    local skill_name
    skill_name=$(basename "$skill_dest")

    # shared/ is a special case — lives directly in planning source
    local skill_src
    if [ "$skill_name" = "shared" ]; then
      skill_src="$src_dir/shared"
    else
      skill_src="$src_dir/$skill_name"
    fi

    if [ ! -d "$skill_src" ]; then
      echo "  WARNING   $plugin/$skill_name — source not found at $skill_src, skipping"
      continue
    fi

    local before after
    before=$(find "$skill_dest" -type f | sort | xargs md5 -q 2>/dev/null | md5 -q 2>/dev/null || echo "")
    rsync -a \
      --exclude="archive/" \
      --exclude="update-workspace/" \
      --exclude="one-time-fix-prompt.md" \
      --exclude="INSTALL.md" \
      --exclude="Eval-Scenarios.md" \
      "$skill_src/" "$skill_dest"
    after=$(find "$skill_dest" -type f | sort | xargs md5 -q 2>/dev/null | md5 -q 2>/dev/null || echo "")

    if [ "$before" != "$after" ]; then
      echo "  updated   $plugin/$skill_name"
      synced=$((synced + 1))
    else
      unchanged=$((unchanged + 1))
    fi
  done

  echo "  ── $plugin: $synced updated, $unchanged unchanged"
}

# ── Helper: sync all Cowork plugins ─────────────────────────────────────────
sync_cowork_all() {
  echo "Syncing skill files into Cowork plugins ..."
  echo ""
  for plugin in pm-requirements pm-planning pm-epics-stories; do
    sync_plugin "$plugin"
  done
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
  echo "What would you like to do?"
  echo "  1) Install for Cursor"
  echo "  2) Install for Claude Code"
  echo "  3) Install for both"
  echo "  4) Sync Cowork plugins only"
  echo ""
  read -rp "Enter 1, 2, 3, or 4: " choice
  case "$choice" in
    1) MODE="--cursor" ;;
    2) MODE="--claude" ;;
    3) MODE="--both"   ;;
    4) MODE="--sync-cowork" ;;
    *) echo "Invalid choice. Run the script again and enter 1, 2, 3, or 4."; exit 1 ;;
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
  --sync-cowork)
    sync_cowork_all
    echo ""
    echo "Done. Reload the plugins in Cowork to pick up the changes."
    echo ""
    echo "────────────────────────────────"
    exit 0
    ;;
  *)
    echo "Unknown option: $MODE"
    echo "Usage: bash install.sh [--cursor | --claude | --both | --sync-cowork]"
    exit 1
    ;;
esac

# ── Sync Cowork plugins after any agent install ──────────────────────────────
echo ""
sync_cowork_all

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

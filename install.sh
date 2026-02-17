#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# iron-scrolls — installer
# Sets up all Claude Code custom slash commands on this machine.
# Usage: bash install.sh
# ─────────────────────────────────────────────────────────────────────────────

set -e

COMMANDS_DIR="$HOME/.claude/commands"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/commands" && pwd)"
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

echo ""
echo -e "${BOLD}${CYAN}⚔  Iron Scrolls — Claude Command Installer${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Create destination if it doesn't exist
if [ ! -d "$COMMANDS_DIR" ]; then
  echo -e "${YELLOW}Creating${RESET} $COMMANDS_DIR"
  mkdir -p "$COMMANDS_DIR"
fi

# Copy all .md files from commands/ into ~/.claude/commands/
installed=0
skipped=0

for file in "$SOURCE_DIR"/*.md; do
  [ -f "$file" ] || continue
  filename=$(basename "$file")
  dest="$COMMANDS_DIR/$filename"

  if [ -f "$dest" ]; then
    # Overwrite and note it
    cp "$file" "$dest"
    echo -e "  ${YELLOW}↻  Updated${RESET}  /$( echo "$filename" | sed 's/\.md$//' )"
  else
    cp "$file" "$dest"
    echo -e "  ${GREEN}✓  Installed${RESET} /$( echo "$filename" | sed 's/\.md$//' )"
  fi
  installed=$((installed + 1))
done

echo ""
echo -e "${GREEN}${BOLD}Done.${RESET} ${installed} command(s) installed to ${COMMANDS_DIR}"
echo ""
echo -e "Use them in any Claude Code session by typing ${BOLD}/<command-name>${RESET}"
echo ""

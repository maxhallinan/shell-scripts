#!/usr/bin/env bash
# Creates a new git worktree with automatic setup of local config files

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <path> <branch-name> [base-branch]"
  echo "Example: $0 ../feature-x feature-x master"
  exit 1
fi

WORKTREE_PATH="$1"
BRANCH_NAME="$2"
BASE_BRANCH="${3:-master}"

# Get the main repository path (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_REPO="$(dirname "$SCRIPT_DIR")"

echo "Creating worktree at: $WORKTREE_PATH"
echo "Branch: $BRANCH_NAME (from $BASE_BRANCH)"

# Create the worktree
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "$BASE_BRANCH"

cd "$WORKTREE_PATH"

echo "Setting up local configuration files..."

# Files to symlink from main repo
FILES_TO_LINK=(
  ".envrc"
  ".claude/settings.local.json"
)

for file in "${FILES_TO_LINK[@]}"; do
  source_file="$MAIN_REPO/$file"

  if [ -e "$source_file" ]; then
    # Create parent directory if needed
    mkdir -p "$(dirname "$file")"

    # Create symlink (remove existing file/link first)
    rm -rf "$file"
    ln -sf "$source_file" "$file"

    echo "  ✓ Linked $file"
  else
    echo "  ⚠ Skipped $file (not found in main repo)"
  fi
done

echo ""
echo "✓ Worktree created and configured at: $WORKTREE_PATH"
echo ""
echo "Next steps:"
echo "  cd $WORKTREE_PATH"
echo "  direnv allow  # If using direnv"

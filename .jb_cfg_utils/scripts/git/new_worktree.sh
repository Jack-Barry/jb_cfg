#!/usr/bin/env bash
###
### Creates a worktree for TICKET_ID at $TICKETS_DIR/<TICKET_ID>/<repo>.
### Run this from within the repo that you want to create the worktree for.
###   - Local branch TICKET_ID exists:   the worktree uses it.
###   - Remote branch TICKET_ID exists:  the worktree tracks origin/TICKET_ID.
###   - Neither exists:                  a new branch starts from the latest origin trunk.
###
set -euo pipefail
WORKTREES_DIR="$JB_CFG_WORKTREES_DIR"
WORKTREE_ID="${1:-}"

if [ -z "$WORKTREE_ID" ]; then
    echo "Usage: $0 WORKTREE_ID" >&2
    exit 1
fi

# Get the basename of the current Git repository
repo_name=$(basename "$(git rev-parse --show-toplevel)")
# Dir to place the new worktree for this repository
worktree_dir="$WORKTREES_DIR/$WORKTREE_ID/$repo_name"
if [ -e "$worktree_dir" ]; then
    echo "Already exists: $worktree_dir" >&2
    exit 1
fi

# Fetch first, so that any newly pushed branches are visible and trunk is current
echo "Fetching origin..."
git fetch origin --prune
git remote set-head origin --auto

if git show-ref --verify --quiet "refs/heads/$WORKTREE_ID"; then
    # There's already a branch, just not a worktree/dir for it yet
    git worktree add "$worktree_dir" "$WORKTREE_ID"
elif git show-ref --verify --quiet "refs/remotes/origin/$WORKTREE_ID"; then
    # There's a remote branch, but no local branch yet. Create a local branch that tracks the remote.
    git worktree add --track -b "$WORKTREE_ID" "$worktree_dir" "origin/$WORKTREE_ID"
else
    # No local or remote branch exists. Create a new branch from the latest trunk.
    trunk="origin/$(git trunk)"
    # --no-track: the new branch does not track trunk
    git worktree add --no-track -b "$WORKTREE_ID" "$worktree_dir" "$trunk"
fi

echo "Worktree ready: $worktree_dir"

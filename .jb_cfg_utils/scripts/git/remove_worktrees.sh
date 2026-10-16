#!/usr/bin/env bash
###
### Scans the provided WORKTREES_DIR for worktree dirs.
### For each worktree dir found, the worktree and the branch it was on are deleted.
### Safety rules:
###   - A worktree with uncommitted or untracked changes is skipped.
###   - A branch with commits that are on no remote is kept unless you confirm.
###   - WORKTREES_DIR is removed only if every worktree in it was removed.
###

WORKTREES_DIR="$1"

if [ -z "$WORKTREES_DIR" ]; then
    echo "Must provide a directory to scan: $0 WORKTREES_DIR"
    exit 1
fi

if [ ! -d "$WORKTREES_DIR" ]; then
    echo "Directory not found: $WORKTREES_DIR"
    exit 1
fi

# Translate it into absolute path for remainder of script
WORKTREES_DIR=$(cd "$WORKTREES_DIR" && pwd)

### Bail if there's nothing to do
shopt -s nullglob
worktrees=("$WORKTREES_DIR"/*)
if [ ${#worktrees[@]} -eq 0 ]; then
    echo "No worktrees found in $WORKTREES_DIR, we're done here"
    exit 0
fi

confirm_delete_remote_branch() {
    local worktree_current_branch="$1"

    # Live, exact-name check (no stale refs, no substring matches)
    if git ls-remote --exit-code --heads origin "$worktree_current_branch" >/dev/null 2>&1; then
        echo "⚠⚠⚠⚠⚠⚠ Remote branch 'origin/$worktree_current_branch' exists. ⚠⚠⚠⚠⚠⚠"
        read -r -p "Do you want to delete the remote branch as well? (y/N): " delete_remote
        if [ "$delete_remote" = "y" ] || [ "$delete_remote" = "Y" ]; then
            read -r -p "⚠⚠⚠⚠⚠⚠ Are you FOR SURE for sure? ⚠⚠⚠⚠⚠⚠ (y/N): " for_sure_delete_remote
            if [ "$for_sure_delete_remote" = "y" ] || [ "$for_sure_delete_remote" = "Y" ]; then
                echo "Deleting REMOTE branch: origin/$worktree_current_branch"
                git push origin --delete "$worktree_current_branch"
            else
                echo "OK. Skipping remote branch deletion."
            fi
        else
            echo "OK. Skipping remote branch deletion."
        fi
    else
        echo "No remote branch 'origin/$worktree_current_branch' found. 👍"
    fi
}

# Returns 1 if the worktree was skipped, so the caller keeps WORKTREES_DIR
delete_worktree_and_branch() {
    local worktree_dir="$1"

    (
        # Move into the worktree dir to get repo information
        cd "$worktree_dir" || exit 1

        if [ -n "$(git status --porcelain)" ]; then
            echo "SKIPPED: $worktree_dir has uncommitted or untracked changes:"
            git status --short
            echo "Commit or discard them, or run: git worktree remove --force $worktree_dir"
            exit 1
        fi

        local branch unpushed=""
        branch=$(git rev-parse --abbrev-ref HEAD)
        if [ "$branch" != "HEAD" ]; then
            unpushed=$(git log --oneline "$branch" --not --remotes)
        fi

        local repo_dir
        repo_dir=$(git rev-parse --git-common-dir)

        # Move into the repo dir to perform deletion operations
        cd "$repo_dir/.." || exit 1

        # Same filesystem as the worktree, so `mv` is a rename and not a copy
        local node_modules_tmp_dir
        node_modules_tmp_dir=$(mktemp -d "$(dirname "$WORKTREES_DIR")/.worktree-trash.XXXXXX")
        echo "Moving node_modules contents to temporary location to speed up worktree removal: $node_modules_tmp_dir"
        find "$worktree_dir" -type d -name node_modules -prune | while read -r nm_dir; do
            rel_path="${nm_dir#"$worktree_dir"/}"
            dest="$node_modules_tmp_dir/$rel_path"
            mkdir -p "$(dirname "$dest")"
            echo "Moving $rel_path to $dest"
            mv "$nm_dir" "$dest"
        done

        echo "Beginning deletion of node_modules dirs in background..."
        rm -rf "$node_modules_tmp_dir" &
        echo "Removing worktree: $worktree_dir"
        if ! git worktree remove "$worktree_dir"; then
            echo "SKIPPED: git could not remove $worktree_dir"
            exit 1
        fi

        if [ "$branch" = "HEAD" ]; then
            echo "Worktree was on a detached HEAD. No branch to delete."
            exit 0
        fi

        if [ -n "$unpushed" ]; then
            echo "⚠ Branch '$branch' has commits that are on no remote:"
            echo "$unpushed"
            read -r -p "Delete the local branch anyway? (y/N): " delete_local
            if [ "$delete_local" != "y" ] && [ "$delete_local" != "Y" ]; then
                echo "OK. Keeping local branch: $branch"
                exit 0
            fi
        fi

        confirm_delete_remote_branch "$branch"
        echo "Deleting LOCAL branch: $branch"
        git branch -D "$branch"
    )
}

is_git_worktree() {
    local dir="$1"
    echo "Checking for git worktree: $dir"
    if [ -f "$dir/.git" ] && grep -q '^gitdir: ' "$dir/.git"; then
        return 0
    else
        return 1
    fi
}

skipped=0
for child_dir in "${worktrees[@]}"; do
    if [ -d "$child_dir" ] && is_git_worktree "$child_dir"; then
        delete_worktree_and_branch "$child_dir" || skipped=1
    fi
done

if [ "$skipped" -ne 0 ]; then
    echo "One or more worktrees were skipped. Leaving $WORKTREES_DIR in place."
    exit 1
fi

check_for_open_tmux_sessions() {
    TMUX_SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    WORKTREE_NAME=$(basename "$WORKTREES_DIR")

    for session in $TMUX_SESSIONS; do
        if [[ "${session,,}" == *"${WORKTREE_NAME,,}"* ]]; then
            local kill_session_cmd="tmux kill-session -t $session"
            local kill_session_msg="You can kill it with '$kill_session_cmd'"

            echo "Found matching open tmux session: $session"

            if [ -n "$TMUX" ]; then
                echo " You're running this from a Tmux session, be cautious if you decide to kill $session "
            fi

            read -r -p "Do you want to kill it? (y/n) " answer
            if [ "$answer" = "y" ]; then
                $kill_session_cmd
                echo " Killed $session"
            else
                echo "OK, leaving it alone"
                echo "$kill_session_msg"
            fi
        fi
    done
}

# Remove worktrees dir if empty
if [ -z "$(ls -A "$WORKTREES_DIR")" ]; then
    rmdir "$WORKTREES_DIR"
    check_for_open_tmux_sessions
else
    # If it's not empty, ask the user if they want to delete it
    echo "Directory $WORKTREES_DIR is not empty:"
    printf "\n"
    ls -a "$WORKTREES_DIR"
    printf "\n"
    read -r -p "Do you want to delete it? (y/n) " answer
    if [ "$answer" = "y" ]; then
        rm -rf "$WORKTREES_DIR"
        echo " Deleted $WORKTREES_DIR"
        check_for_open_tmux_sessions
    else
        echo "OK, leaving it alone"
    fi
fi

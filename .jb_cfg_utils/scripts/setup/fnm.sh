#!/usr/bin/env bash
##############################################
# Installs LTS Node if no versions already present
##############################################
export PATH="${HOMEBREW_PREFIX:-/opt/homebrew}/bin:$PATH"
eval "$(fnm env)"

if [ ! -d "$FNM_DIR/node-versions/.downloads" ]; then
    fnm install --lts
else
    echo "✅ Node is already available"
fi

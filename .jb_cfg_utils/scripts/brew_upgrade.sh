#!/bin/bash
# Used to run brew upgrades in the background on a weekly cadence
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
{
    echo "=== $(date) ==="
    caffeinate -i /usr/local/bin/brew update
    caffeinate -i /usr/local/bin/brew upgrade --formula
    /usr/local/bin/brew cleanup
    echo "=== done $(date) ==="
} >>"$JB_CFG_BREW_UPGRADE_LOG_PATH" 2>&1

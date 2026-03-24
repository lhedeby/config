#!/usr/bin/env bash
set -euo pipefail

is_se() {
  hyprctl -j devices | jq -e '.keyboards[].active_keymap | select(. == "Swedish")' >/dev/null
}

case "${1:-show}" in
  show)
    if is_se; then
      echo '{"text":"  SE"}'
    else
      echo '{"text":"  US"}'
    fi
    ;;
  toggle)
    if is_se; then
      hyprctl switchxkblayout current 0  # US
    else
      hyprctl switchxkblayout current 1  # SE
    fi
    ;;
esac

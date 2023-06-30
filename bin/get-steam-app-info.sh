#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

appid="${1:-}"

if [[ ! "$appid" =~ ^[0-9]+$ ]]; then
  echo "app id is invalid" >&2
  exit 1
fi

export PATH="/usr/games:$PATH"

get_steam_app_info() {
  "$SCRIPT_DIR/steamcmd.exp" "$1" | vdf2json
}

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "app-info=$(get_steam_app_info "$appid")" >> "$GITHUB_OUTPUT"
else
  get_steam_app_info "$appid"
fi

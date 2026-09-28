#!/usr/bin/env bash
# Print the final leaderboard from the saved advancement files. Needs: jq.
#   ./score.sh path/to/server-dir
# Run `save-all flush` in the console first so the files are up to date.
set -euo pipefail
dir=${1:-.}
for f in "$dir"/world/players/advancements/*.json; do
  uuid=$(basename "$f" .json)
  name=$(jq -r --arg u "$uuid" '.[] | select(.uuid == $u) | .name' "$dir/usercache.json" 2>/dev/null || true)
  count=$(jq '[to_entries[]
               | select(.key | startswith("minecraft:"))
               | select(.key | startswith("minecraft:recipes/") | not)
               | select(.value.done == true)] | length' "$f")
  printf '%s\t%s\n' "$count" "${name:-$uuid}"
done | sort -rn | column -t

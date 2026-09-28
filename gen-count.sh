#!/usr/bin/env bash
# Regenerate datapack/competition/data/comp/function/count.mcfunction for a
# given server version. Needs: unzip, curl.
#   ./gen-count.sh path/to/server.jar
# Works with a vanilla jar or a Paper/Purpur (paperclip) jar; for paperclip the
# matching vanilla jar is downloaded from Mojang, since advancements live there.
set -euo pipefail
jar=$1
dir=$(dirname "$0")
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

if unzip -l "$jar" META-INF/download-context >/dev/null 2>&1; then
  url=$(unzip -p "$jar" META-INF/download-context | cut -f2)
  curl -fsSL "$url" -o "$tmp/vanilla.jar"
  jar=$tmp/vanilla.jar
fi

# vanilla server jars are bundlers; the real jar is nested under META-INF/versions
inner=$(unzip -Z1 "$jar" 'META-INF/versions/*/*.jar' 2>/dev/null | head -n1 || true)
if [ -n "$inner" ]; then unzip -p "$jar" "$inner" > "$tmp/server.jar"; else cp "$jar" "$tmp/server.jar"; fi

out=$dir/datapack/competition/data/comp/function/count.mcfunction
{
  echo 'scoreboard players set @a comp.adv 0'
  unzip -Z1 "$tmp/server.jar" 'data/minecraft/advancement/*.json' \
    | grep -v '/recipes/' \
    | sed -E 's#^data/minecraft/advancement/(.*)\.json$#execute as @a[advancements={minecraft:\1=true}] run scoreboard players add @s comp.adv 1#'
  echo 'schedule function comp:count 1s'
} > "$out"
echo "wrote $(( $(wc -l < "$out") - 2 )) advancement checks to $out"

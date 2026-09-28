#!/usr/bin/env bash
# Start the server from this folder's server/ directory. Put a Purpur jar there
# as server.jar first (https://purpurmc.org/download/purpur).
set -euo pipefail
cd "$(dirname "$0")/server"
mkdir -p world/datapacks
[ -e world/datapacks/competition ] || cp -r ../datapack/competition world/datapacks/
echo eula=true > eula.txt
exec java -Xms12G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
  -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M \
  -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 -jar server.jar nogui

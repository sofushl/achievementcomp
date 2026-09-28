# Advancement competition

A Minecraft datapack for a timed competition. Each player gets **2 hours of
playtime**, and whoever has the **most advancements** when their time runs out wins.
Built for Purpur/Paper 26.3, and it also works on vanilla.

## What players see

- **Tab list:** the minutes of playtime they have left.
- **Sidebar:** everyone's advancement count, highest first. This is the live leaderboard.
- When a player's time runs out, they become a spectator and chat announces it.

The clock counts **each player's own playtime**, not wall-clock time. Time spent
logged off doesn't count, so people can join late or take breaks.

## Folder contents

| Path | What it is |
|---|---|
| `datapack/competition/` | The datapack. Copy it into `<server>/world/datapacks/`. |
| `server/server.properties` | The server settings used for the Abellan server (adventure mode before start, 100-block world border, hard difficulty). |
| `start.sh` | Starts the server from `server/` with 12 GB of heap, installing the datapack and accepting the EULA on first run. |
| `gen-count.sh` | Rebuilds `count.mcfunction` for a different Minecraft version. |
| `score.sh` | Prints the final leaderboard from the saved player files. |

**Dependencies:** Java 25 (for 26.3), a server
jar, and `unzip`, `curl` and `jq` for the helper scripts.

## Running a competition

1. Download a Purpur jar to `server/server.jar`, then run `./start.sh`.
   You can also use your own server: copy `datapack/competition` into its
   `world/datapacks/` folder and run `reload`.
2. Players join in adventure mode and can't break or place anything until the start.
3. When everyone is ready, run this in the console:
   ```
   function comp:start
   ```
   It revokes all advancements, clears inventories and XP, puts everyone in
   survival, and starts the clocks.
4. At the end, run `save-all flush`, then `./score.sh server` to print the final
   ranking. The sidebar shows the same numbers.

## How it works

| Function | Runs | Job |
|---|---|---|
| `load` | on load or `reload` | Creates the scoreboards and assigns them to the tab list and sidebar. |
| `start` | manually | Resets players and starts `comp.time`, which tracks playtime in ticks. |
| `tick` | every tick | Moves players still in adventure mode into survival, updates minutes left, and calls `timeup` at 144000 ticks (2 hours). |
| `timeup` | per player | Makes the player a spectator and tags them `comp.out`. |
| `count` | every second | Recounts each online player's advancements. |

Vanilla has no built-in statistic for "advancements completed", so `count.mcfunction`
has one generated check per advancement (126 for 26.3, not counting recipe unlocks).
Offline players keep their last count on the sidebar.

### Changing the length

The length is 144000 ticks (20 ticks per second × 7200 seconds). It appears in
`load.mcfunction` (`#duration`) and in `tick.mcfunction` (the `matches 144000..`
check). Change both, then run `reload`.

### Updating to a new Minecraft version

```
./gen-count.sh path/to/server.jar
```

This accepts a vanilla jar or a Paper/Purpur jar. For Paper or Purpur, it downloads
the matching vanilla jar, because that is where the advancement list lives. Also
update `min_format`/`max_format` in `pack.mcmeta` to the new data pack format, or
the server will warn that the pack is incompatible.

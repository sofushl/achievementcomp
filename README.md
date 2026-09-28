# Advancement competition

A Minecraft datapack for a timed competition. Each player gets **2 hours of
playtime**, and whoever has the **most advancements** when their time runs out wins.
Built for Minecraft 26.3 (Purpur/Paper), and it also works on vanilla.

## What players see

- **Tab list:** the minutes of playtime they have left.
- **Sidebar:** everyone's advancement count, highest first. This is the live leaderboard.
- When a player's time runs out, they become a spectator and chat announces it.

The clock counts **each player's own playtime**, not wall-clock time. Time spent
logged off doesn't count, so people can join late or take breaks.

## Folder contents

This repo is the datapack. The repo root is the pack root.

| Path | What it is |
|---|---|
| `pack.mcmeta`, `data/` | The datapack itself. |
| `scripts/gen-count.sh` | Rebuilds `count.mcfunction` for a different Minecraft version. |
| `scripts/score.sh` | Prints the final leaderboard from the saved player files. |

**Dependencies:** none for the pack. The helper scripts need `unzip`, `curl` and `jq`.

## Installing

Clone or unzip this repo as a folder in `<server>/world/datapacks/` (for example
`world/datapacks/achievementcomp`), then run `reload` or restart. The folder must
contain `pack.mcmeta` directly. You can also zip the contents of the repo
(`pack.mcmeta` at the zip root). The pack targets 26.3 (pack format 107.1).

The pack does not change server settings such as the default gamemode, the world
border or the difficulty. Set these yourself. If you set the default gamemode to
adventure, players cannot break or place blocks until `comp:start`, and the pack
moves them to survival after the start.

## Running a competition

1. Install the pack and let players join.
2. When everyone is ready, run this in the console:
   ```
   function comp:start
   ```
   It revokes all advancements, clears inventories and XP, puts everyone in
   survival, and starts the clocks.
3. At the end, run `save-all flush`, then `scripts/score.sh path/to/server` to print
   the final ranking. The sidebar shows the same numbers.

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
scripts/gen-count.sh path/to/server.jar
```

This accepts a vanilla jar or a Paper/Purpur jar. For Paper or Purpur, it downloads
the matching vanilla jar, because that is where the advancement list lives. Also
update `min_format`/`max_format` in `pack.mcmeta` to the new data pack format, or
the server will warn that the pack is incompatible.

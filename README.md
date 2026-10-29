# Advancement competition

A Minecraft datapack for a timed competition. The whole competition runs on one
shared **two hour** clock, and whoever has the **most advancements** when time
runs out wins. Built for Minecraft 26.3 (Purpur/Paper), and it also works on vanilla.

## What players see

- **Tab list:** the minutes left on the shared clock.
- **Sidebar:** everyone's advancement count, highest first. This is the live leaderboard.
- When the two hours are up, everyone becomes a spectator and chat announces it.

The clock is **global**: it starts at `comp:start` and runs in real time for two
hours, whether or not any given player is online. People who join late simply
have less time left.

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

The pack does not change server settings such as the default gamemode or the
difficulty. Set these yourself. It does manage the world border: `comp:setup`
shrinks it to 25 blocks around the arena, and `comp:start` expands it to 750
blocks when the competition begins. If you set the default gamemode to
adventure, players cannot break or place blocks until `comp:start`, and the pack
moves them to survival after the start.

## Running a competition

1. Install the pack
2. Call setup with: function comp:setup {x:<int>,y:<int>,z:<int>}
   It centers a 25-block world border on those coordinates and sets the world
   spawn there, so everyone can gather inside.
3. When everyone is ready, run this in the console:
   ```
   function comp:start
   ```
   It revokes all advancements, clears inventories and XP, puts everyone in
   survival, expands the world border to 750, and starts the global two hour clock.
4. At the end, run `save-all flush`, then `scripts/score.sh path/to/server` to print
   the final ranking. The sidebar shows the same numbers.

## How it works

| Function | Runs | Job |
|---|---|---|
| `load` | on load or `reload` | Creates the scoreboards and assigns them to the tab list and sidebar. |
| `setup` | manually | Centers the world border and spawn on the arena and shrinks the border to 25 blocks. |
| `start` | manually | Resets players, expands the border to 750, zeroes the global clock (`#timer` on `comp.time`), and starts the competition. |
| `tick` | every tick | Moves players still in adventure mode into survival, advances the global clock, updates minutes left, and calls `timeup` when the clock reaches `#duration`. |
| `timeup` | once, when time runs out | Makes everyone a spectator, tags them `comp.out`, and stops the clock. |
| `count` | every second | Recounts each online player's advancements. |

Vanilla has no built-in statistic for "advancements completed", so `count.mcfunction`
has one generated check per advancement (126 for 26.3, not counting recipe unlocks).
Offline players keep their last count on the sidebar.

### Changing the length

The length is 144000 ticks (20 ticks per second × 7200 seconds). It is set once,
as `#duration` in `load.mcfunction`; `tick.mcfunction` compares against that
constant. Change it, then run `reload`.

### Updating to a new Minecraft version

```
scripts/gen-count.sh path/to/server.jar
```

This accepts a vanilla jar or a Paper/Purpur jar. For Paper or Purpur, it downloads
the matching vanilla jar, because that is where the advancement list lives. Also
update `min_format`/`max_format` in `pack.mcmeta` to the new data pack format, or
the server will warn that the pack is incompatible.

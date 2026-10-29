# Advancement competition

A Minecraft datapack for a timed competition. One shared **two hour** clock runs,
and whoever has the **most advancements** when it ends wins. Built for Minecraft
26.3 (Purpur/Paper); it also works on vanilla.

> **Hardcoded for one world.** `comp:setup` uses fixed coordinates (arena centre
> `250 250`, spawn `250 123 250`). They fit the seed **7702654185421006115**.
> On any other seed, edit `data/comp/function/setup.mcfunction` first.

## What players see

- **Tab list:** minutes left.
- **Sidebar:** advancement count, highest first. The title shows the minutes left.
- At time up, everyone becomes a spectator and chat names the winner.

The clock is **global**. It starts at `comp:start` and runs in real time, whether
or not a player is online. Late joiners have less time left.

## Contents

| Path | What it is |
|---|---|
| `pack.mcmeta`, `data/` | The datapack. The repo root is the pack root. |
| `scripts/gen-count.sh` | Rebuilds `count.mcfunction` for another Minecraft version. |
| `scripts/score.sh` | Prints the final leaderboard from the saved player files. |

The pack has no dependencies. The scripts need `unzip`, `curl` and `jq`.

## Installing

Put this folder in `<server>/world/datapacks/`, then run `reload` or restart.
`pack.mcmeta` must be directly in the folder (or at the zip root). The pack
targets 26.3 (pack format 107.1).

The pack does not change the default gamemode or difficulty. It does manage the
world border (25 blocks at setup, 750 at start). `setup` puts everyone in
adventure mode, and the pack moves them to survival at the start.

## Running a competition

1. Install the pack.
2. Run `function comp:setup`. It resets scores, sets a 25-block border and the
   world spawn, puts everyone in adventure mode, and sets the time to 0.
3. Optional: run `/tick freeze` by hand. Before the start, run `/tick rate 20`
   and `/tick unfreeze`. The `tick` command does not load inside functions on
   this Purpur build, so the pack does not call it.
4. When everyone is ready, run `function comp:start`. It revokes advancements,
   clears inventories and XP, sets survival, expands the border to 750, and starts
   the clock.
5. At the end, run `save-all flush`, then `scripts/score.sh path/to/server`.

## How it works

| Function | Runs | Job |
|---|---|---|
| `load` | on load or `reload` | Creates the scoreboards and the display slots. Sets the world spawn, so new players never start underground. |
| `setup` | manually | Resets scores, sets border, spawn and time. |
| `start` | manually | Resets players, expands the border, zeroes `#timer`, starts. |
| `tick` | every tick | Advances the clock, updates minutes left, calls `timeup` at `#duration`. |
| `timeup` | once | Counts, announces the winner, makes everyone a spectator. |
| `count` | every second | Recounts each online player's advancements. |

Vanilla has no statistic for completed advancements, so `count.mcfunction` has one
generated check per advancement (recipes excluded). Offline players keep their
last count on the sidebar.

**Changing the length:** set `#duration` (in ticks, 144000 = 2 hours) in
`load.mcfunction`, then `reload`. If applicable, also update the PVP offsets (80, 60 and 20 minutes before the end) in `load.mcfunction` and the PVP chat messages in `pvp_on` and `pvp_off`.

**New Minecraft version:** run `scripts/gen-count.sh path/to/server.jar` (vanilla
or Paper/Purpur jar), and update `min_format`/`max_format` in `pack.mcmeta`.

execute unless score #started comp.state matches 1 run return 0
gamemode survival @a[gamemode=adventure,tag=!comp.out]
scoreboard players add #timer comp.time 1
scoreboard players operation @a comp.left = #duration comp.const
scoreboard players operation @a comp.left -= #timer comp.time
scoreboard players add @a comp.left 1199
scoreboard players operation @a comp.left /= #ticksPerMin comp.const
execute if score #timer comp.time >= #duration comp.const run function comp:timeup

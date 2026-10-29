execute unless score #started comp.state matches 1 run return 0
gamemode survival @a[gamemode=adventure,tag=!comp.out]
scoreboard players add #timer comp.time 1
scoreboard players operation #left comp.time = #duration comp.const
scoreboard players operation #left comp.time -= #timer comp.time
scoreboard players add #left comp.time 1199
scoreboard players operation #left comp.time /= #ticksPerMin comp.const
scoreboard players operation @a comp.left = #left comp.time
execute unless score #left comp.time = #shown comp.time run function comp:title
execute if score #timer comp.time >= #duration comp.const run function comp:timeup

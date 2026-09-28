execute unless score #started comp.state matches 1 run return 0
gamemode survival @a[gamemode=adventure,tag=!comp.out]
scoreboard players add @a comp.time 0
scoreboard players operation @a comp.left = #duration comp.const
execute as @a run scoreboard players operation @s comp.left -= @s comp.time
scoreboard players add @a comp.left 1199
scoreboard players operation @a comp.left /= #ticksPerMin comp.const
execute as @a[tag=!comp.out] if score @s comp.time matches 144000.. run function comp:timeup
scoreboard players set @a[tag=comp.out] comp.left 0

scoreboard players set #started comp.state 2
function comp:count
tag @a remove comp.winner
scoreboard players set #max comp.time 0
execute as @a run scoreboard players operation #max comp.time > @s comp.adv
execute as @a if score @s comp.adv = #max comp.time run tag @s add comp.winner
tag @a add comp.out
gamemode spectator @a
tellraw @a {"text":"Time's up! Everyone is now a spectator.","color":"red"}
execute unless entity @a[tag=comp.winner] run tellraw @a {"text":"No players were online, so there is no winner.","color":"gray"}
execute if entity @a[tag=comp.winner] run tellraw @a [{"text":"Winner: ","color":"gold"},{"selector":"@a[tag=comp.winner]","color":"yellow"},{"text":" with ","color":"gold"},{"score":{"name":"#max","objective":"comp.time"},"color":"yellow"},{"text":" advancements!","color":"gold"}]

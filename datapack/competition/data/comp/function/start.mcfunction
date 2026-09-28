advancement revoke @a everything
clear @a
xp set @a 0 levels
tag @a remove comp.out
gamemode survival @a
scoreboard objectives remove comp.time
scoreboard objectives add comp.time minecraft.custom:minecraft.play_time
scoreboard players set #started comp.state 1
tellraw @a {"text":"Competition started! 2 hours of playtime - most advancements wins.","color":"gold"}

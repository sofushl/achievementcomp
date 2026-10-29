time set 0
advancement revoke @a everything
clear @a
xp set @a 0 levels
tag @a remove comp.out
gamemode survival @a
scoreboard players set #timer comp.time 0
worldborder set 750
scoreboard players set #started comp.state 1
tellraw @a {"text":"Competition started! 2 hours on the clock - most advancements wins.","color":"gold"}

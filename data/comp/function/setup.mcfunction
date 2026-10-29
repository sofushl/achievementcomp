worldborder center 250 250
worldborder set 25
setworldspawn 250 126 250
gamemode adventure @a
gamerule respawn_radius 25
scoreboard players reset * comp.adv
scoreboard players reset * comp.left
scoreboard players reset * comp.time
scoreboard players reset * comp.state
tag @a remove comp.out
tag @a remove comp.winner
scoreboard objectives modify comp.adv displayname "Advancements"
time set 0
gamerule pvp false

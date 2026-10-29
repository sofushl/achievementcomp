scoreboard objectives add comp.state dummy
scoreboard objectives add comp.const dummy
scoreboard objectives add comp.time dummy
scoreboard objectives add comp.left dummy "Minutes left"
scoreboard objectives add comp.adv dummy "Advancements"
scoreboard players set #ticksPerMin comp.const 1200
scoreboard players set #duration comp.const 144000
scoreboard players set #offset comp.const 80
scoreboard players operation #offset comp.const *= #ticksPerMin comp.const
scoreboard players operation #pvp1 comp.const = #duration comp.const
scoreboard players operation #pvp1 comp.const -= #offset comp.const
scoreboard players set #offset comp.const 60
scoreboard players operation #offset comp.const *= #ticksPerMin comp.const
scoreboard players operation #pvpend comp.const = #duration comp.const
scoreboard players operation #pvpend comp.const -= #offset comp.const
scoreboard players set #offset comp.const 20
scoreboard players operation #offset comp.const *= #ticksPerMin comp.const
scoreboard players operation #pvp2 comp.const = #duration comp.const
scoreboard players operation #pvp2 comp.const -= #offset comp.const
scoreboard objectives setdisplay list comp.left
scoreboard objectives setdisplay sidebar comp.adv
schedule function comp:count 1s

scoreboard objectives add comp.state dummy
scoreboard objectives add comp.const dummy
scoreboard objectives add comp.left dummy "Minutes left"
scoreboard objectives add comp.adv dummy "Advancements"
scoreboard players set #ticksPerMin comp.const 1200
scoreboard players set #duration comp.const 144000
scoreboard objectives setdisplay list comp.left
scoreboard objectives setdisplay sidebar comp.adv
schedule function comp:count 1s

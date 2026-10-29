scoreboard players operation #shown comp.time = #left comp.time
execute store result storage comp:ui left int 1 run scoreboard players get #left comp.time
function comp:title_set with storage comp:ui

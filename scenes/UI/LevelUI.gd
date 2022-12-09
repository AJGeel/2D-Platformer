extends CanvasLayer

func _ready():
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("loop_total_changed", self, "on_loop_total_changed")
		baseLevels[0].connect("death_tally_changed", self, "on_death_tally_changed")

func on_loop_total_changed(totalLoops, collectedLoops):
	$MarginContainer/HBoxContainer/LoopLabel.text = str(collectedLoops, "/", totalLoops)

func on_death_tally_changed(deathTally):
	print(str("You died: ", deathTally, " times."))

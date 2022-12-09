extends HBoxContainer

func _ready():
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("loop_total_changed", self, "on_loop_total_changed")
		update_display(baseLevels[0].totalLoops, baseLevels[0].collectedLoops)

func update_display(totalLoops, collectedLoops):
	$LoopLabel.text = str(collectedLoops, "/", totalLoops)

func on_loop_total_changed(totalLoops, collectedLoops):
	update_display(totalLoops, collectedLoops)

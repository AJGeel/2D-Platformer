extends CanvasLayer

func _ready():
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("emerald_total_changed", self, "on_emerald_total_changed")
		baseLevels[0].connect("death_tally_changed", self, "on_death_tally_changed")

func on_emerald_total_changed(totalEmeralds, collectedEmeralds):
	$MarginContainer/HBoxContainer/EmeraldLabel.text = str(collectedEmeralds, "/", totalEmeralds)

func on_death_tally_changed(deathTally):
	print(str("You died: ", deathTally, " times."))

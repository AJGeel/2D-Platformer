extends HBoxContainer

func _ready():
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("death_total_changed", self, "on_death_total_changed")
		update_display(baseLevels[0].deathTotal)

func update_display(deathTotal):
	$DeathLabel.text = str(deathTotal)

func on_death_total_changed(deathTotal):
	update_display(deathTotal)
	$AnimationPlayer.queue("shine")
	$AnimationPlayer.queue("idle")

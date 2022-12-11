extends HBoxContainer

func _ready():
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("time_total_changed", self, "on_time_total_changed")
		update_display(baseLevels[0].totalTime)

func format_time(totalTime):
	var seconds = totalTime % 60
	var minutes = (totalTime / 60) % 60
	
	# Returns a string with the format "MM:SS"
	return "%02d:%02d" % [minutes, seconds]

func update_display(totalTime):
	var formattedTime = format_time(totalTime)
	$TimeLabel.text = str(formattedTime)

func on_time_total_changed(totalTime):
	update_display(totalTime)

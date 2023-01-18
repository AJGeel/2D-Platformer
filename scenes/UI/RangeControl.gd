extends HBoxContainer

signal percentage_changed

var currentPercentage = 1.0

func _ready():
	var _subtractBtn = $SubtractButton.connect("pressed", self, "on_button_pressed", [-0.1])
	var _addBtn = $AddButton.connect("pressed", self, "on_button_pressed", [0.1])

func set_current_percentage(percent):
	currentPercentage = clamp(percent, 0, 1)
	
	var labelNumber = round(currentPercentage * 10)
	
	$Label.text = str(labelNumber)
	emit_signal("percentage_changed", currentPercentage)

func on_button_pressed(change):
	set_current_percentage(currentPercentage + change)

extends CanvasLayer

onready var continueButton = $CanvasLayer/CenterContainer/VBoxContainer/ResumeButton
onready var optionsButton = $CanvasLayer/CenterContainer/VBoxContainer/OptionsButton
onready var mainMenuButton = $CanvasLayer/CenterContainer/VBoxContainer/MainMenuButton

func _ready():
	continueButton.grab_focus()
	continueButton.connect("pressed", self, "on_continue_pressed")
	optionsButton.connect("pressed", self, "on_options_pressed")
	mainMenuButton.connect("pressed", self, "on_main_menu_pressed")
	get_tree().paused = true

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		unpause()
		get_tree().set_input_as_handled()

func unpause():
	queue_free()
	get_tree().paused = false

func on_continue_pressed():
	unpause()

func on_options_pressed():
	pass

func on_main_menu_pressed():
	unpause()
	$"/root/ScreenTransitionManager".transition_to_menu()

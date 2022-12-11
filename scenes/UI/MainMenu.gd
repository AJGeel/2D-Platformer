extends CanvasLayer

func _ready():
	var playButton = $CenterContainer/VBoxContainer/PlayButton
	var optionsButton = $CenterContainer/VBoxContainer/OptionsButton
	var connectButton = $CenterContainer/VBoxContainer/ConnectButton
	var quitButton = $CenterContainer/VBoxContainer/QuitButton
	
	playButton.connect("pressed", self, "on_play_pressed")
	optionsButton.connect("pressed", self, "on_options_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
	playButton.grab_focus()

func on_play_pressed():
	$"/root/LevelManager".change_level(0)

func on_quit_pressed():
	get_tree().quit()

func on_options_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/OptionsMenuStandalone.tscn")

extends CanvasLayer

func _ready():
	var playButton = $MainMenuOptions/PlayButton
	var optionsButton = $MainMenuOptions/OptionsButton
	var connectButton = $MainMenuOptions/ConnectButton
	var feedbackButton = $MainMenuOptions/FeedbackButton
	var quitButton = $MainMenuOptions/QuitButton
	
	playButton.connect("pressed", self, "on_play_pressed")
	optionsButton.connect("pressed", self, "on_options_pressed")
	connectButton.connect("pressed", self, "on_connect_pressed")
	feedbackButton.connect("pressed", self, "on_feedback_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
	playButton.grab_focus()

func on_play_pressed():
	$"/root/LevelManager".change_level(0)

func on_options_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/OptionsMenuStandalone.tscn")

func on_connect_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/ConnectMenu.tscn")

func on_feedback_pressed():
	print("Feedback btn pressed")
	OS.shell_open("https://discord.gg/mTPmh74byM")

func on_quit_pressed():
	get_tree().quit()

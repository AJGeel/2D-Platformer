extends CanvasLayer

func _ready():
	var playButton = $CenterContainer/VBoxContainer/PlayButton
	var quitButton = $CenterContainer/VBoxContainer/QuitButton
	
	playButton.connect("pressed", self, "on_play_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
	playButton.grab_focus()

func on_play_pressed():
	$"/root/LevelManager".change_level(0)

func on_quit_pressed():
	get_tree().quit()

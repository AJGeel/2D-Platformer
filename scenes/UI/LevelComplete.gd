extends CanvasLayer

onready var nextButton = $CanvasLayer/CenterContainer/VBoxContainer/NextButton
onready var retryButton = $CanvasLayer/CenterContainer/VBoxContainer/RetryButton

func _ready():
	nextButton.connect("pressed", self, "on_next_button_pressed")
	retryButton.connect("pressed", self, "on_retry_button_pressed")
	nextButton.grab_focus()

func on_next_button_pressed():
	$"/root/LevelManager".increment_level()

func on_retry_button_pressed():
	print("Retry")
	pass

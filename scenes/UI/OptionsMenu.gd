extends CanvasLayer

signal back_pressed

onready var backButton = $CanvasLayer/CenterContainer/VBoxContainer/BackButton
onready var windowModeButton = $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/WindowModeButton

var fullscreen = false

func _ready():
	windowModeButton.connect("pressed", self, "on_window_mode_pressed")
	backButton.connect("pressed", self, "on_back_pressed")
	backButton.grab_focus()
	update_display()

func update_display():
	windowModeButton.text = "WINDOWED" if !fullscreen else "FULLSCREEN"

func on_window_mode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()

func on_back_pressed():
	emit_signal("back_pressed")

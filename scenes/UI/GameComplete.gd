extends CanvasLayer

onready var mainMenuButton = $CenterContainer/VBoxContainer/MainMenuButton

func _ready():
	mainMenuButton.connect("pressed", self, "on_main_menu_pressed")

func on_main_menu_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()

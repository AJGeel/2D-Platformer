extends CanvasLayer

onready var connectButton = $CanvasLayer/CenterContainer/VBoxContainer/ConnectButton
onready var backButton = $CanvasLayer/CenterContainer/VBoxContainer/BackButton

func _ready():
	backButton.connect("pressed", self, "on_back_pressed")
	connectButton.connect("pressed", self, "on_connect_pressed")
	connectButton.grab_focus()

func on_connect_pressed():
	OS.alert('The connection is currently not supported yet. Visit the Calcium Crew Discord for updates on progress.')

func on_back_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()

extends CanvasLayer

signal back_pressed

onready var backButton = $CanvasLayer/CenterContainer/VBoxContainer/BackButton
onready var windowModeButton = $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/WindowModeButton
onready var musicRangeControl = $CanvasLayer/CenterContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var sfxRangeControl = $CanvasLayer/CenterContainer/VBoxContainer/SFXVolumeContainer/RangeControl

var fullscreen = false

func _ready():
	windowModeButton.connect("pressed", self, "on_window_mode_pressed")
	backButton.connect("pressed", self, "on_back_pressed")
	backButton.grab_focus()
	musicRangeControl.connect("percentage_changed", self, "on_music_volume_changed")
	sfxRangeControl.connect("percentage_changed", self, "on_sfx_volume_changed")
	update_display()
	update_initial_volume_settings()

func update_display():
	windowModeButton.text = "WINDOWED" if !fullscreen else "FULLSCREEN"

func update_bus_volume(busName, volumePercent):
	var busIndex = AudioServer.get_bus_index(busName)
	var volumeDb = linear2db(volumePercent)
	AudioServer.set_bus_volume_db(busIndex, volumeDb)

func get_bus_volume_percent(busName):
	var busIndex = AudioServer.get_bus_index(busName)
	var volumePercent = db2linear(AudioServer.get_bus_volume_db(busIndex))
	return volumePercent

func update_initial_volume_settings():
	var musicPercent = get_bus_volume_percent("Music")
	var sfxPercent = get_bus_volume_percent("SFX")
	musicRangeControl.set_current_percentage(musicPercent)
	sfxRangeControl.set_current_percentage(sfxPercent)

func on_window_mode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()

func on_back_pressed():
	emit_signal("back_pressed")

func on_music_volume_changed(percent):
	update_bus_volume("Music", percent)

func on_sfx_volume_changed(percent):
	update_bus_volume("SFX", percent)

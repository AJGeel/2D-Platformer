extends Node2D

export(String, MULTILINE) var text

var lastAnimation = null

func _ready():
	# Update label text
	$Node2D/PanelContainer/MarginContainer/Label.text = text
	var _areaEntered = $Area2D.connect("area_entered", self, "on_area_entered")
	var _areaExited = $Area2D.connect("area_exited", self, "on_area_exited")
	$AnimationPlayer.playback_speed = 1.25

func on_area_entered(_area2d):
	$AnimationPlayer.current_animation = "opened"
	$ScrollAudioPlayer.play()

func on_area_exited(_area2d):
	$AnimationPlayer.play_backwards("opened")
	$AnimationPlayer.playback_speed = 2
	$AnimationPlayer.queue("idle")

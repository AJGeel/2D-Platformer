extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var random_animation_speed = rng.randf_range(0.5, 1)
	$AnimationPlayer.playback_speed = random_animation_speed

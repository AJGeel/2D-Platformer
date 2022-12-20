extends Node2D

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(_area2d):
	$AnimationPlayer.play("bounce")
	$AnimationPlayer.queue("RESET")
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.bounced_on_mushroom()

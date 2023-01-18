extends Node

func apply_camera_shake(percentage):
	var cameras = get_tree().get_nodes_in_group("camera")
	if (cameras.size() > 0):
		cameras[0].apply_shake(percentage)

func apply_twitch(amount: int = 1):
	var cameras = get_tree().get_nodes_in_group("camera")
	if (cameras.size() > 0):
		cameras[0].apply_twitch(amount)

func apply_vignette(amount: int = 1):
	var cameras = get_tree().get_nodes_in_group("camera")
	if (cameras.size() > 0):
		cameras[0].apply_vignette(amount)

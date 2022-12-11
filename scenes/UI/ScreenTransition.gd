extends CanvasLayer

signal screen_covered

func emit_screen_covered():
	emit_signal("screen_covered")

func pick_random_transition():
	randomize()
	#_print(randf())
	$ColorRect.get_material().set_shader_param("selectedImage", randf())

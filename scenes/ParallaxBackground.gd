extends ParallaxBackground

export(float) var CLOUD_SPEED = -1.0

func _physics_process(delta):
	$ParallaxClouds.motion_offset.x += CLOUD_SPEED * delta

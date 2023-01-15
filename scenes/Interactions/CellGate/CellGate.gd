extends Node2D

export(bool) var isOpen = false

var isOpening = false

func _ready():
	if (isOpen):
		$DustParticles.set_lifetime(0.01)
		$AnimationPlayer.set_speed_scale(100)
		$AnimationPlayer.play("SwingOpen")
		$Lock/AnimationPlayer.set_speed_scale(100)
		$Lock/AnimationPlayer.play("Explode")

# Check if the CellGate is in an interactible state
func interaction_can_interact() -> bool:
	if (isOpen || isOpening):
		return false
	else:
		return true

func interaction_interact(_interactionTarget: Node) -> void:
	if (isOpen || isOpening):
		return
	
	
	# if player holds one or more keys:
	#$AnimationPlayer.play("SwingOpen")
	#$Lock/AnimationPlayer.play("Explode")
	
	# else: 
	# $Lock/AnimationPlayer.play("Jiggle")
	
	isOpening = true
	$"/root/Helpers".apply_camera_shake(1)
	$"/root/Helpers".apply_twitch()
	$AnimationPlayer.play("SwingOpen")
	$Lock/AnimationPlayer.play("Explode")
	isOpen = true

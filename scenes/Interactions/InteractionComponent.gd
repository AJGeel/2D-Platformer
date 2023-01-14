extends Area2D

export var INTERACTION_PARENT : NodePath

signal on_interactable_changed(newInteractable)

var interactionTarget : Node

func _process(_delta):
	# Check whether the player is trying to interact
	if (Input.is_action_just_pressed("ui_accept")):
		print("DEBUG: Player tried to interact")
		if (interactionTarget != null):
			print("DEBUG: ... and player successfully interacted")
			interactionTarget.interaction_interact(self)
			
			# Cleanup: remove interaction target
			reset_interaction_target()
			# Todo: trigger animation

# Signal triggered when the player enters an interactable area
func _on_InteractionComponent_area_entered(area):
	# @DEV Note: Interactable objects (like CellGate) should always be structured like:
	# > Object
	# > > InteractArea
	
	var potentialTarget = area.get_parent()
	
	# Check if the interaction target candidate is in an interactable state
	if (potentialTarget.has_method("interaction_can_interact") && potentialTarget.interaction_can_interact()):
		interactionTarget = area.get_parent()
		emit_signal("on_interactable_changed", interactionTarget)
	else:
		reset_interaction_target()

# Signal triggered when the player exits an interactable area
func _on_InteractionComponent_area_exited(area):
	if (area.get_parent() == interactionTarget):
		reset_interaction_target()

func reset_interaction_target() -> void:
	interactionTarget = null
	emit_signal("on_interactable_changed", null)

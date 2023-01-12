extends Area2D

export var INTERACTION_PARENT : NodePath

signal on_interactable_changed(newInteractable)

var interactionTarget : Node

func _process(_delta):
	# Check whether the player is trying to interact
	if (Input.is_action_just_pressed("ui_accept")):
		print("Player tried to interact")
		if (interactionTarget != null):
			interactionTarget.interaction_interact(self)

# Signal triggered when the player enters an interactable area
func _on_InteractionComponent_area_entered(area):
	var canInteract: bool = false
	
	# Note: Interactable objects should always be structured like:
	# > Object
	# > > InteractArea
	if (area.get_parent().has_method("interaction_can_interact")):
		canInteract = true
	else:
		return
	
	# Store the thing we'll be interacting with, so we can trigger it from _process
	interactionTarget = area.get_parent()
	emit_signal("on_interactable_changed", interactionTarget)

# Signal triggered when the player exits an interactable area
func _on_InteractionComponent_area_exited(area):
	if (area.get_parent() == interactionTarget):
		interactionTarget = null
		emit_signal("on_interactable_changed", null)

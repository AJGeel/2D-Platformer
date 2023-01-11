extends Area2D

export var INTERACTION_PARENT : NodePath

signal on_interactable_changed(newInteractable)

var interactionTarget : Node

func _process(_delta):
	# Check whether the player is trying to interact
	if (interactionTarget != null && Input.is_action_just_pressed("ui_accept")):
		# If so, call interaction_interact() if the target supports it
		if (interactionTarget.has_method("interaction_interact")):
			interactionTarget.interaction_interact(self)

# Signal triggered when the player enters an interactable area
func _on_InteractionComponent_area_entered(body):
	
	print("Entered interaction component")
	
	var canInteract := false
	
	if (body.has_method("interaction_can_interact")):
		canInteract = body.interaction_can_interact(get_node(INTERACTION_PARENT))
	
	if not canInteract:
		return
	
	# Store the thing we'll be interacting with, so we can trigger it from _process
	interactionTarget = body
	emit_signal("on_interactable_changed", interactionTarget)

# Signal triggered when the player exits an interactable area
func _on_InteractionComponent_area_exited(body):
	print("Exited interaction component")
	if (body == interactionTarget):
		interactionTarget = null
		emit_signal("on_interactable_changed", null)

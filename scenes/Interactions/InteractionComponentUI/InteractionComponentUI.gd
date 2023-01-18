extends Control

# @DEV reference: https://www.youtube.com/watch?v=C_-faOyIuTQ&t=224s

# Used to attach the UI to the interaction component
export var INTERACTION_COMPONENT_NODEPATH : NodePath

# Currently unused. Could be used to dynamically set the texture (sprite) and text
#export var INTERACTION_TEXTURE_NODEPATH : NodePath
#export var INTERACTION_TEXT_NODEPATH : NodePath
#export var INTERACTION_DEFAULT_TEXTURE : Texture
#export var INTERACTION_DEFAULT_TEXT : String

var fixedPosition : Vector2

func _ready():
	# We need to connect ourselves to the interaction components' signal
	var _interactionNode = get_node(INTERACTION_COMPONENT_NODEPATH).connect("on_interactable_changed", self, "interactable_target_changed", [], CONNECT_DEFERRED)
	
	# On load, we should be hidden
	hide()

func _process(_delta : float):
	# Because we're a child of the player we'll always be moving relative to them
	# But when we're set against an item we should stick above it
	# So each frame we'll make sure we're moved to our fixed_position
	set_global_position(fixedPosition)

func interactable_target_changed(newInteractable : Node) -> void:
	# If the new interactable object is null, it means we've moved out of range.
	# So the UI should be hidden
	if (newInteractable == null):
		hide()
		return
	
	# Otherwise, we've encountered something new
	# We want to get the icon we should display from it, along with the text
	
	# Start by grabbing our default texture & text
	#var interactionTexture := INTERACTION_DEFAULT_TEXTURE
	#var interactionText := INTERACTION_DEFAULT_TEXT

	# Then check whether the interactable has a custom texture
	#if (newInteractable.has_method("interaction_get_texture")):
	#	interactionTexture = newInteractable.interaction_get_texture()
	
	# Check for custom text
	#if (newInteractable.has_method("interaction_get_text")):
	#	interactionText = newInteractable.interaction_get_text()
	
	# Then, update the texture and text
	#get_node(INTERACTION_TEXTURE_NODEPATH).texture = interactionTexture
	#get_node(INTERACTION_TEXT_NODEPATH).text = interactionText
	
	# Record the position we should fix ourselves to
	# This should be just above the interactable item
	fixedPosition = Vector2(newInteractable.get_global_position().x, newInteractable.get_global_position().y - 25)
	
	# Move to the fixed position
	self.set_global_position(fixedPosition)
	
	# Then, ensure the UI gets displayed
	show()
	$UIAnimationPlayer.play("FadeIn")

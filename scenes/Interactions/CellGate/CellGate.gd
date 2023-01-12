extends Node2D

export(int, 2, 4) var GATE_HEIGHT
export(bool) var isOpen = false

var isOpening = false

var SPRITE_2H = preload("res://assets/interactions/cell-gate/cell-gate-2h.png")
var SPRITE_3H = preload("res://assets/interactions/cell-gate/cell-gate-3h.png")
var SPRITE_4H = preload("res://assets/interactions/cell-gate/cell-gate-4h.png")

const FACTOR = 18

# Update sprite and collision props on init
func _ready():
	update_sprite()
	update_collision_props()
	# TODO?: Update Lock Height

func interaction_can_interact() -> bool:
	return true

func interaction_interact(interactionTarget: Node) -> void:
	if (isOpen || isOpening):
		return
	
	# if player holds one or more keys:
	#$AnimationPlayer.play("SwingOpen")
	#$Lock/AnimationPlayer.play("Explode")
	
	# else: 
	# $Lock/AnimationPlayer.play("Jiggle")
	
	isOpening = true
	$AnimationPlayer.play("SwingOpen")
	$Lock/AnimationPlayer.play("Explode")
	isOpen = true

# Update the gate's sprite to match the set gate height
func update_sprite():
	var spriteNode = $Sprite
	
	match GATE_HEIGHT:
		2:
			spriteNode.set_texture(SPRITE_2H)
		3:
			spriteNode.set_texture(SPRITE_3H)
		4:
			spriteNode.set_texture(SPRITE_4H)
	
	spriteNode.offset.y = -1 * FACTOR * (GATE_HEIGHT - 1)

func update_collision_props():
	var collisionNode = $StaticBody2D/CollisionShape2D
	var dustParticlesNode = $DustParticles
	
	print("Updating collision props for ", self)
	print("Original state:")
	print(collisionNode.shape.extents.y)
	print(collisionNode.position.y)
	collisionNode.shape.extents.y = FACTOR * (GATE_HEIGHT / 2) # (18, 27, 36)
	collisionNode.position.y = -1 * FACTOR * ((GATE_HEIGHT - 1) / 2) # (0, -9, -18)
	
	print("Final state:")
	print(collisionNode.shape.extents.y)
	print(collisionNode.position.y)
	
	dustParticlesNode.amount = 4 * GATE_HEIGHT # (8, 12, 16)
	dustParticlesNode.emission_rect_extents.y = GATE_HEIGHT * 8 - 4 # (12, 20, 28)
	dustParticlesNode.position.y = (GATE_HEIGHT - 2) * -9 # (0, -9, -18)

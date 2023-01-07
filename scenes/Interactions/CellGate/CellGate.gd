extends Node2D

export(int, 2, 4) var GATE_HEIGHT

var SPRITE_2H = preload("res://assets/interactions/cell-gate/cell-gate-2h.png")
var SPRITE_3H = preload("res://assets/interactions/cell-gate/cell-gate-3h.png")
var SPRITE_4H = preload("res://assets/interactions/cell-gate/cell-gate-4h.png")

const factor = 18


func _ready():
	update_sprite(GATE_HEIGHT)
	update_collision_props(GATE_HEIGHT)
	pass # Replace with function body.

# Update the gate's sprite to match the set gate height
func update_sprite(gateHeight):
	var spriteNode = $Sprite
	
	match gateHeight:
		2:
			spriteNode.set_texture(SPRITE_2H)
		3:
			spriteNode.set_texture(SPRITE_3H)
		4:
			spriteNode.set_texture(SPRITE_4H)
	
	spriteNode.offset.y = -1 * factor * (GATE_HEIGHT - 1)

func update_collision_props(gateHeight):
	#var areaNode = $Area2D
	var collisionNode = $StaticBody2D/CollisionShape2D
	var dustParticlesNode = $DustParticles
	
	collisionNode.shape.extents.y = factor * (GATE_HEIGHT / 2) # (18, 27, 36)
	collisionNode.position.y = -1 * factor * ((GATE_HEIGHT - 1) / 2) # (0, -9, -18)
	
	dustParticlesNode.amount = 4 * GATE_HEIGHT # (8, 12, 16)
	dustParticlesNode.emission_rect_extents.y = GATE_HEIGHT * 8 - 4 # (12, 20, 28)
	dustParticlesNode.position.y = (GATE_HEIGHT - 2) * -9 # (0, -9, -18)
	
	pass

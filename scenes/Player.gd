extends KinematicBody2D

signal died

var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")

enum State {NORMAL, DASHING}

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

var gravity = 1000
var velocity = Vector2.ZERO
var maxVerticalSpeed = 500
var maxHorizontalSpeed = 140
var maxDashSpeed = 500
var minDashSpeed = 200
var horizontalAcceleration = 2000
var jumpSpeed = 320
var jumpTerminationMultiplier = 4
var hasDoubleJump = false
var hasDash = false
var currentState = State.NORMAL
var isStateNew = true
var isDying = false

# Buffer Jump input https://www.youtube.com/watch?v=8wlQ5VCYFTI

var defaultHazardMask = 0

func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask

func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func process_normal(delta):
	if (isStateNew):
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
	
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			$"/root/Helpers".apply_camera_shake(0.75)
			hasDoubleJump = false
		$CoyoteTimer.stop()
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		if (Input.is_action_pressed("down")):
			velocity.y = maxVerticalSpeed
		else:
			velocity.y += gravity * delta
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	
	if (is_on_floor()):
		hasDoubleJump = true
		hasDash = true
	
	if (hasDash && Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
		hasDash = false
	
	update_animation()

func process_dash(delta):
	if (isStateNew):
		$"/root/Helpers".apply_camera_shake(1)
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dashHazardMask
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else :
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
		
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector

func update_animation():
	var moveVec = get_movement_vector()
	
	if (!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif (moveVec.x != 0):
		$AnimatedSprite.play("run")
	else:
		if Input.is_action_pressed("down"):
			$AnimatedSprite.play("crouch")
		else:
			$AnimatedSprite.play("idle")
	
	if (moveVec.x != 0):
		$AnimatedSprite.flip_h = true if moveVec.x > 0 else false	

func kill():
	if (isDying):
		return
	else:
		isDying = true
		var playerDeathInstance = playerDeathScene.instance()
		get_parent().add_child_below_node(self, playerDeathInstance)
		playerDeathInstance.global_position = global_position
		playerDeathInstance.velocity = velocity
		emit_signal("died")

func on_hazard_area_entered(area2d):
	$"/root/Helpers".apply_camera_shake(0.75)
	call_deferred("kill")

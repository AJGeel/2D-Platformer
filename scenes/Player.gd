extends KinematicBody2D

signal died

var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")
var footstepParticles = preload("res://scenes/FootstepParticles.tscn")

enum State {NORMAL, DASHING, INPUT_DISABLED}

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

var gravity = 1000
var velocity = Vector2.ZERO
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
	$AnimatedSprite.connect("frame_changed", self, "on_animated_sprite_frame_changed")
	defaultHazardMask = $HazardArea.collision_mask

func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func process_normal(delta):
	if (isStateNew):
		stop_trail()
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
	
	var moveVector = get_movement_vector()
	var prevVelocity = velocity
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			$"/root/Helpers".apply_camera_shake(0.75)
			hasDoubleJump = false
			start_trail()
			yield(get_tree().create_timer(.4), "timeout")
			stop_trail()
			
		$CoyoteTimer.stop()
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	
	# Just landed on the floor
	if (!wasOnFloor && is_on_floor() && !isStateNew):
		var footstepScale = clamp(prevVelocity.y / 300, 1, 3)
		var shakeScale = clamp(prevVelocity.y / 800, 0, 1.5)
		addFootsteps(footstepScale)
		$"/root/Helpers".apply_camera_shake(shakeScale)
	
	if (is_on_floor()):
		hasDoubleJump = true
		hasDash = true
	
	if (hasDash && Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
		hasDash = false
	
	update_animation()

func process_dash(delta):
	if (isStateNew):
		start_trail()
		$"/root/Helpers".apply_camera_shake(1)
		$"/root/Helpers".apply_twitch()
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

func process_input_disabled(delta):
	if (isStateNew):
		$AnimatedSprite.play("idle")
	velocity.x = lerp(0, velocity.x, pow(2, -50 *delta))
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

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
		playerDeathInstance.velocity = velocity
		get_parent().add_child_below_node(self, playerDeathInstance)
		playerDeathInstance.global_position = global_position
		emit_signal("died")

func start_trail():
	$TrailParticles.emitting = true

func stop_trail():
	$TrailParticles.emitting = false

func addFootsteps(scale = 1):
	var footstep = footstepParticles.instance()
	get_parent().add_child(footstep)
	$AudioPlayers/FootstepAudioPlayer.play()
	footstep.scale = Vector2.ONE * scale
	footstep.global_position = global_position

func disable_player_input():
	change_state(State.INPUT_DISABLED)

func on_hazard_area_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(0.75)
	call_deferred("kill")

func on_bouncy_platform_entered(_area2d):
	pass

func on_animated_sprite_frame_changed():
	if ($AnimatedSprite.animation == "run" && $AnimatedSprite.frame == 0):
		addFootsteps()

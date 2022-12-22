extends KinematicBody2D

signal died

var playerDeathScene = preload("res://scenes/PlayerDeath.tscn")
var footstepParticles = preload("res://scenes/FootstepParticles.tscn")

enum State {NORMAL, DASHING, INPUT_DISABLED}

export(int, LAYERS_2D_PHYSICS) var dashHazardMask
export(bool) var unlockedDash = false
export(bool) var unlockedDoubleJump = false
export(bool) var unlockedWallJump = true

const GRAVITY = 1000
const MAX_HORIZONTAL_SPEED = 140
const MAX_DASH_SPEED = 500
const MIN_DASH_SPEED = 200
const HORIZONTAL_ACCELERATION = 2000
const JUMP_SPEED = 320
const JUMP_TERMINATION_MULTIPLIER = 4
const MUSHROOM_BOOST = -600

var velocity = Vector2.ZERO
var isLaunched = false
var bufferedJump = false
var hasDoubleJump = false
var hasDash = false
var currentState = State.NORMAL
var isStateNew = true
var isDying = false
var defaultHazardMask = 0

onready var jumpBufferTimer: = $JumpBufferTimer

func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	$AnimatedSprite.connect("frame_changed", self, "on_animated_sprite_frame_changed")
	defaultHazardMask = $HazardArea.collision_mask
	
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.connect("launched_by_mushroom", self, "on_launched_by_mushroom")

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
		change_trail_to(false)
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
	
	var moveVector = get_movement_vector()
	var prevVelocity = velocity
	
	velocity.x += moveVector.x * HORIZONTAL_ACCELERATION * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || (unlockedDoubleJump && hasDoubleJump))):
		
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			# Double Jump
			velocity.y = moveVector.y * JUMP_SPEED
			add_double_jump_effects()
		else:
			# Single Jump
			velocity.y = moveVector.y * JUMP_SPEED
		$CoyoteTimer.stop()
	
	elif (is_on_floor() && bufferedJump == true):
		bufferedJump = false
		velocity.y = -1 * JUMP_SPEED
	
	# Jump input buffer
	if Input.is_action_just_pressed("jump"):
		bufferedJump = true
		jumpBufferTimer.start()
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump") && !isLaunched):
		velocity.y += GRAVITY * JUMP_TERMINATION_MULTIPLIER * delta
	else:
		velocity.y += GRAVITY * delta
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	
	# Landing on the floor & footsteps
	if (!wasOnFloor && is_on_floor() && !isStateNew):
		var footstepScale = clamp(prevVelocity.y / 300, 1, 3)
		var shakeScale = clamp(prevVelocity.y / 500, 0, 2)
		
		add_footsteps(footstepScale)
		
		# Big landing
		if (shakeScale >= 1):
			$"/root/Helpers".apply_twitch()
			$"/root/Helpers".apply_camera_shake(shakeScale)
			# TODO Add crunch sound effect
	
	if (is_on_floor()):
		# Reset values when you hit the floor
		hasDoubleJump = true
		hasDash = true
		isLaunched = false
	
	if (unlockedDash && hasDash && Input.is_action_just_pressed("dash")):
		# Handle dash state logic
		call_deferred("change_state", State.DASHING)
		hasDash = false
	
	if (is_on_wall()):
		# Slow down fall gravity
		pass
	
	update_animation()

func process_dash(delta):
	if (isStateNew):
		change_trail_to(true)
		$"/root/Helpers".apply_camera_shake(1)
		$"/root/Helpers".apply_twitch()
		$AudioPlayers/DashAudioPlayer.play()
		$AudioPlayers/DashAudioPlayer2.play()
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dashHazardMask
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else :
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
		
		velocity = Vector2(MAX_DASH_SPEED * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < MIN_DASH_SPEED):
		call_deferred("change_state", State.NORMAL)

func process_input_disabled(delta):
	if (isStateNew):
		$AnimatedSprite.play("idle")
	velocity.x = lerp(0, velocity.x, pow(2, -50 *delta))
	velocity.y += GRAVITY * delta
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
		$"/root/Helpers".apply_twitch()
		$"/root/Helpers".apply_camera_shake(1)
		emit_signal("died")

func change_trail_to(state):
	if state == true:
		$TrailParticles.emitting = true
	else:
		$TrailParticles.emitting = false

func add_footsteps(scale = 1):
	var footstep = footstepParticles.instance()
	get_parent().add_child(footstep)
	$AudioPlayers/FootstepAudioPlayer.play()
	footstep.scale = Vector2.ONE * scale
	footstep.global_position = global_position

func add_double_jump_effects():
	$"/root/Helpers".apply_camera_shake(0.75)
	$AudioPlayers/DoubleJumpAudioPlayer.play()
	hasDoubleJump = false
	change_trail_to(true)
	yield(get_tree().create_timer(.4), "timeout")
	change_trail_to(false)

func disable_player_input():
	change_state(State.INPUT_DISABLED)

func on_hazard_area_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(0.75)
	call_deferred("kill")

func on_launched_by_mushroom():
	isLaunched = true
	velocity.y = MUSHROOM_BOOST
	add_double_jump_effects()

func on_animated_sprite_frame_changed():
	if ($AnimatedSprite.animation == "run" && $AnimatedSprite.frame == 0):
		add_footsteps(0.5)

func _on_JumpBufferTimer_timeout():
	bufferedJump = false

extends KinematicBody2D

var velocity = Vector2.ZERO
const GRAVITY = 1000

# var words = ["Oof", "Ow", "Ouch", "Argh", "Darn", "Youch", "Yoink", "Owie", "Shucks", "Crunch", "Yeet", "Ugh", "Golly", "Oy"]

func _ready():
	if (velocity.x > 0):
		$Visuals.scale = Vector2(-1, 1)
	var _hurtboxArea = $HurtboxArea.connect("area_entered", self, "on_hurtbox_entered")
	$AudioPlayers/DeathSoundPlayer1.play()
	$AudioPlayers/DeathSoundPlayer2.play()
	$AudioPlayers/DeathSoundPlayer3.play()
	# var randomWord = words[randi() % words.size()]
	# $Text/Label.text = randomWord

func _process(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (is_on_floor()):
		velocity.x = lerp(0, velocity.x, pow(2, -2 * delta))

func kill():
	$AnimationPlayer.set_current_animation("fly_away")

func on_hurtbox_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")

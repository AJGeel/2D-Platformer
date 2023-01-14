extends KinematicBody2D

enum DIRECTIONS { horizontal, vertical}

export var startDirection = Vector2.RIGHT
export var maxSpeed = 60
export(DIRECTIONS) var moveDirection = DIRECTIONS.horizontal

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

func _ready():
	direction = startDirection
	var _goalDetectorEntered = $GoalDetector.connect("area_entered", self, "on_goal_entered")

func _process(_delta):
	if (is_on_wall()):
		change_direction()
	
	if (moveDirection == DIRECTIONS.horizontal):
		velocity.x = (direction * maxSpeed).x
	elif (moveDirection == DIRECTIONS.vertical):
		velocity.y = (direction * maxSpeed).y
	
	velocity = move_and_slide(velocity, Vector2.UP)

func on_goal_entered(_area2d):
	change_direction()

func change_direction():
	direction *= -1

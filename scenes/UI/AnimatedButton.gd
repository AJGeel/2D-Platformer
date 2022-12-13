extends Button

export(bool) var enablePitchRandomization = true
export(float) var minPitchScale = 0.95
export(float) var maxPitchScale = 1.05

onready var ConfirmNode = $AudioStreams/Confirm
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	connect("mouse_entered", self, "on_mouse_entered")
	connect("focus_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("focus_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")


func _process(_delta):
	rect_pivot_offset = rect_min_size / 2

func on_mouse_entered():
	$HoverAnimationPlayer.play("hover")

func on_mouse_exited():
	$HoverAnimationPlayer.play_backwards("hover")

func on_pressed():
	play_audio()
	$ClickAnimationPlayer.play("click")

func play_audio():
	if (enablePitchRandomization):
		ConfirmNode.pitch_scale = rng.randf_range(minPitchScale, maxPitchScale)
	ConfirmNode.play()

extends Button

export(bool) var enablePitchRandomization = true
export(float) var minPitchScale = 0.98
export(float) var maxPitchScale = 1.02

onready var ConfirmAudioNode = $AudioStreams/Confirm
onready var ClickAudioNode = $AudioStreams/Click
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	connect("mouse_entered", self, "on_mouse_entered")
	connect("focus_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("focus_exited", self, "on_mouse_exited")
	connect("focus_exited", self, "on_focus_exited")
	connect("pressed", self, "on_pressed")


func _process(_delta):
	rect_pivot_offset = rect_min_size / 2

func reset_button_state():
	$HoverAnimationPlayer.play_backwards("hover")

func play_audio(node):
	node.play()

func on_mouse_entered():
	$HoverAnimationPlayer.play("hover")

func on_mouse_exited():
	reset_button_state()

func on_pressed():
	play_audio(ConfirmAudioNode)
	$ClickAnimationPlayer.play("click")

func on_focus_exited():
	play_audio(ClickAudioNode)
	reset_button_state()

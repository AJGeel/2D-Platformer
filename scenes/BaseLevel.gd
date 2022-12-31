extends Node

signal loop_total_changed
signal death_total_changed
signal enemies_killed_changed
signal time_total_changed
signal launched_by_mushroom

export(PackedScene) var levelCompleteScene

var playerScene = preload("res://scenes/Player.tscn")
var pauseScene = preload("res://scenes/UI/PauseMenu.tscn")

var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

# Game stats
var totalLoops = 0
var collectedLoops = 0
var deathTotal = 0
var enemiesKilled = 0
var startTime = 0
var totalTime = 0
var timerActive = true

func _ready():
	spawnPosition = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	loop_total_changed(get_tree().get_nodes_in_group("loop").size())
	startTime = OS.get_unix_time()
	$Flag.connect("player_won", self, "on_player_won")

func _process(_delta):
	time_total_changed()

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pauseInstance = pauseScene.instance()
		add_child(pauseInstance)

func bounced_on_mushroom():
	emit_signal("launched_by_mushroom")

func loop_collected():
	collectedLoops += 1
	emit_signal("loop_total_changed", totalLoops, collectedLoops)

func loop_total_changed(newTotal):
	totalLoops = newTotal
	emit_signal("loop_total_changed", totalLoops, collectedLoops)

func time_total_changed():
	if (timerActive):
		var currentTime = OS.get_unix_time()
		totalTime = currentTime - startTime
		emit_signal("time_total_changed", totalTime)

func death_total_changed():
	deathTotal += 1
	emit_signal("death_total_changed", deathTotal)

func enemies_killed_changed():
	enemiesKilled += 1
	emit_signal("enemies_killed_changed", enemiesKilled)

func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)

func create_player():
	var playerInstance = playerScene.instance()
	
	# TODO: Re-instance player unlocks based on game state
	# playerInstance.unlockedDash = true
	# playerInstance.unlockedDoubleJump = true
	# playerInstance.unlockedWallJump = true
	$PlayerRoot.add_child(playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)

func on_player_died():
	death_total_changed()
	currentPlayerNode.queue_free()
	var timer = get_tree().create_timer(1.25)
	yield(timer, "timeout")
	create_player()

func on_player_won():
	currentPlayerNode.disable_player_input()
	timerActive = false
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)

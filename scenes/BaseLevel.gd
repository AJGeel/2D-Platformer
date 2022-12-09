extends Node

signal loop_total_changed
signal death_tally_changed
signal enemies_killed_changed

export(PackedScene) var levelCompleteScene

var playerScene = preload("res://scenes/Player.tscn")
var pauseScene = preload("res://scenes/UI/PauseMenu.tscn")

var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

# Game stats
var totalLoops = 0
var collectedLoops = 0
var deathTally = 0
var enemiesKilled = 0
var timeSpent = 0

func _ready():
	spawnPosition = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	loop_total_changed(get_tree().get_nodes_in_group("loop").size())
	$Flag.connect("player_won", self, "on_player_won")

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pauseInstance = pauseScene.instance()
		add_child(pauseInstance)

func loop_collected():
	collectedLoops += 1
	emit_signal("loop_total_changed", totalLoops, collectedLoops)

func loop_total_changed(newTotal):
	totalLoops = newTotal
	emit_signal("loop_total_changed", totalLoops, collectedLoops)

func death_tally_changed():
	deathTally += 1
	emit_signal("death_tally_changed", deathTally)

func enemies_killed_changed():
	enemiesKilled += 1
	emit_signal("enemies_killed_changed", enemiesKilled)

func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)

func create_player():
	var playerInstance = playerScene.instance()
	$PlayerRoot.add_child(playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)

func on_player_died():
	death_tally_changed()
	currentPlayerNode.queue_free()
	var timer = get_tree().create_timer(1.25)
	yield(timer, "timeout")
	create_player()

func on_player_won():
	currentPlayerNode.disable_player_input()
	print("Here is how you did:")
	print("Loops collected: ", collectedLoops, "/", totalLoops)
	print("Times died: ", deathTally)
	print("Enemies Killed: ", enemiesKilled)
	print("Time elapsed: ", timeSpent)
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)

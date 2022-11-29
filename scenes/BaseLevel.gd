extends Node

signal emerald_total_changed

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var totalEmeralds = 0
var collectedEmeralds = 0

func _ready():
	spawnPosition = $Player.global_position
	register_player($Player)
	emerald_total_changed(get_tree().get_nodes_in_group("emerald").size())
	
	$Flag.connect("player_won", self, "on_player_won")

func emerald_collected():
	collectedEmeralds += 1
	print(totalEmeralds, collectedEmeralds)
	emit_signal("emerald_total_changed", totalEmeralds, collectedEmeralds)

func emerald_total_changed(newTotal):
	totalEmeralds = newTotal
	emit_signal("emerald_total_changed", totalEmeralds, collectedEmeralds)

func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)

func create_player():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)

func on_player_died():
	currentPlayerNode.queue_free()
	create_player()

func on_player_won():
	$"/root/LevelManager".increment_level()

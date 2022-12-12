extends CanvasLayer

onready var nextButton = $CanvasLayer/CenterContainer/VBoxContainer/BottomMenu/NextButton
onready var retryButton = $CanvasLayer/CenterContainer/VBoxContainer/BottomMenu/RetryButton
onready var mainMenuButton = $CanvasLayer/CenterContainer/VBoxContainer/BottomMenu/MainMenuButton
onready var ScoreLabel = $CanvasLayer/CenterContainer/VBoxContainer/ScorePanel/HBox/ScoreLabel

var baseScore = 10000

func _ready():
	nextButton.connect("pressed", self, "on_next_button_pressed")
	retryButton.connect("pressed", self, "on_retry_button_pressed")
	mainMenuButton.connect("pressed", self, "on_main_menu_button_pressed")
	nextButton.grab_focus()
	
	# Try to see if we have score data available
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	if (baseLevels.size() > 0):
		# If so: calculate score
		var score = calculate_score(baseLevels[0])
		var formattedScore = format_score(str(score))
		ScoreLabel.text = str(formattedScore)

func calculate_score(node):
	# f(x) = 0.75 * x^2 + 0.25
	# 0% = 0.25x, 100% = 1.00x
	var loopX = float(node.collectedLoops + 0.0000001) / float(node.totalLoops + 0.0000001)
	var loopMultiplier = 0.75 * pow(loopX, 2) + 0.25
	
	# f(x) = 1 - (x - 5) / (80 - 5)
	# 5 sec = 1.00x, 60+ sec = 0.26x
	var timeX = clamp(float(node.totalTime), 5, 60)
	var timeMultiplier = 1 - (timeX - 5) / (80 - 5)
	
	# f(x) = 1 - sqrt(x) / 3.8
	# 0 deaths = 1.00x, 10+ deaths = 0.168x
	var deathX = clamp(float(node.deathTotal), 0, 10)
	var deathMultiplier = 1 - sqrt(deathX) / 3.8
	
	return round(baseScore * loopMultiplier * timeMultiplier * deathMultiplier)

func format_score(score : String) -> String:
	var i : int = score.length() - 3
	while i > 0:
		score = score.insert(i, ",")
		i = i - 3
	return score

func on_next_button_pressed():
	$"/root/LevelManager".increment_level()

func on_retry_button_pressed():
	$"/root/LevelManager".restart_level()

func on_main_menu_button_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()

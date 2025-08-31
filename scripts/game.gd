# This is a modified version of your game.gd script.
# Only the `_on_game_over` function is changed to reflect your new setup.

extends Node2D

@export var player_scene = preload("res://scenes/player/player.tscn")
@onready var player_spawn: Marker2D = $playerSpawn
@export var wall_scene:Array[PackedScene] = []
@export var lava_scene:Array[PackedScene]
@export var game_over_ui_scene: PackedScene = preload("res://scenes/ui/game_over_ui.tscn")

var wall_index = 1
var lava
var player
var max_height = 0.0  # track the highest point reached
var score = 0

func _ready() -> void:
	player = player_scene.instantiate()
	player.global_position = player_spawn.global_position
	# Connect the player's upgrade signal to this script
	player.upgrade_request.connect(_on_player_upgrade_request)
	call_deferred("add_child", player)
	
	var wall = wall_scene.pick_random().instantiate()
	wall.area_entered.connect(_on_layer_body_entered)
	wall.position = Vector2(0,0)
	call_deferred("add_child",wall)
	
	lava = lava_scene.pick_random().instantiate()
	lava.global_position = $lava_pos.global_position
	# Connect the lava's game over signal to this script
	lava.game_over.connect(_on_game_over)
	call_deferred("add_child", lava)

func _process(delta: float) -> void:
	update_score()

func _on_layer_body_entered(body: Node2D) -> void:
	if body is Player:
		var wall = wall_scene.pick_random().instantiate()
		wall.area_entered.connect(_on_layer_body_entered)
		wall.position = Vector2(0,0 - (768* wall_index))
		call_deferred("add_child", wall)
		wall_index += 1

func update_score() -> void:
	if is_instance_valid(player):
		var current_height = player_spawn.global_position.y - player.global_position.y
		if current_height > max_height:
			max_height = current_height
			score = round(max_height/100)
			$CanvasLayer/score_label.text = str(int(score)) + "m"

func _on_player_upgrade_request(new_item_scene: PackedScene) -> void:
	# This function handles the actual umbrella/jetpack swap
	print("Upgrade requested!")
	
	# Check if the player has an umbrella to begin with
	if is_instance_valid(player.umbrella):
		# Remove the old umbrella from the scene
		player.umbrella.queue_free()
	
	# Instantiate the new item
	var new_item = new_item_scene.instantiate()
	
	# Attach the new item to the player's hand marker
	player.get_node("hand_marker").add_child(new_item)
	new_item.position = Vector2.ZERO
	
	# Update the player's reference to the new item
	player.umbrella = new_item
	
	# Connect the new item's signal
	new_item.fuel_out.connect(player._on_fuel_out)
	
	# Update the player's up_speed to the new item's speed
	player.up_speed = new_item.data.fly_speed
	
	print("Upgrade successful! Player now has a ", new_item.data.item_name)
	
func _on_game_over() -> void:
	# Pause the game
	get_tree().paused = true
	
	# Instantiate and show the game over UI
	var game_over_ui = game_over_ui_scene.instantiate()
	get_node("CanvasLayer").add_child(game_over_ui)
	game_over_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	game_over_ui.set_final_score(score)

extends Node2D

@export var player_scene = preload("res://scenes/player/player.tscn")
@onready var player_spawn: Marker2D = $playerSpawn
@export var wall_scene:Array[PackedScene] = []
@export var lava_scene:Array[PackedScene]

var wall_index = 1
var lava
var player
var max_height = 0.0  # track the highest point reached
var score = 0

func _ready() -> void:
	player = player_scene.instantiate()
	player.global_position = player_spawn.global_position
	call_deferred("add_child", player)
	
	var wall = wall_scene.pick_random().instantiate()
	wall.area_entered.connect(_on_layer_body_entered)
	wall.position = Vector2(0,0)
	call_deferred("add_child",wall)
	
	lava = lava_scene.pick_random().instantiate()
	lava.global_position = $lava_pos.global_position
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

func update_score():
	# Higher Y = down, so use negative to track ascent
	var current_height = -player.global_position.y

	# Only update if player reached a new max
	if current_height > max_height:
		max_height = current_height
		score = int(max_height / 20)  # scale down if too fast

	$CanvasLayer/score_label.text = str(score) + " m"

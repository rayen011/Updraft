extends Node2D

@export var player_scene = preload("res://scenes/player/player.tscn")
@onready var player_spawn: Marker2D = $playerSpawn
@export var wall_scene:Array[PackedScene] = []
@export var lava_scene:Array[PackedScene]
var wall_index = 1
var lava
var player
var score = 0.0
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
	
	score += player.up_speed /100 * delta
	$CanvasLayer/score_label.text = str(int(score)) + " m"
func _on_layer_body_entered(body: Node2D) -> void:
	if body is Player:
		#$walls_1.global_position.y -= 380#768
		var wall = wall_scene.pick_random().instantiate()
		wall.area_entered.connect( _on_layer_body_entered)
		wall.position = Vector2(0,0 - (768* wall_index) )
		#add_child(wall)
		call_deferred("add_child", wall)
		wall_index += 1

extends Node

@onready var items_container: Node = $"../items_container"
@onready var rock_container: Node = $"../rock_container"


@export var items_scene:Array[PackedScene] = []
@export var items:Array[ItemData]
var player
var spawn_timer = Timer.new()
var rng = RandomNumberGenerator.new()
var min_item_time_spwn = 3
var max_item_time_spwn = 6

var rock_timer = Timer.new()
func _ready() -> void:
	spawn_timer.wait_time = rng.randi_range(min_item_time_spwn,max_item_time_spwn)
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
	# Connect the timeout signal
	spawn_timer.connect("timeout", Callable(self, "_on_my_timer_timeout"))
	player = get_tree().get_first_node_in_group("Player")
	
	rock_timer.wait_time =randf_range(2, 3) 
	rock_timer.autostart = true
	rock_timer.one_shot = false
	rock_timer.timeout.connect(spawn_rock)
	add_child(rock_timer)
	
func _process(delta: float) -> void:
	pass
	
func _on_my_timer_timeout():
	spawn_item()
	

func spawn_item():
	var rand_x = randf_range(-100, 300)
	var rand_y = randf_range(250, 350)
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	var spawn_pos = player.position - Vector2(rand_x, rand_y)
	spawn_pos.x = clamp(spawn_pos.x, 0, 500) # adjust cave width
	
	# This is the new logic to spawn different types of items
	var item_rate = randf()
	var item_picked
	if item_rate <= 0.3:
		item_picked = 1 # Speed Boost
	else:
		item_picked = 0 # Durability Boost
	#else:
		#item_picked = 2 # New Jetpack upgrade
	
	var item = items_scene.pick_random().instantiate()
	# Assign the correct ItemData to the pickup.
	item.data = items[item_picked] 
	item.global_position = spawn_pos
	items_container.add_child(item)
	spawn_timer.wait_time = rng.randi_range(min_item_time_spwn,max_item_time_spwn)

func spawn_rock():
	player = get_tree().get_first_node_in_group("Player")
	var rock_scene = preload("res://scenes/rock.tscn")
	var rock = rock_scene.instantiate()
	var rand_x = randf_range(0, 500)
	var rand_y = randf_range(250, 350)
	var spawn_pos = player.position - Vector2(rand_x, rand_y)
	rock.global_position = spawn_pos
	rock_container.add_child(rock)

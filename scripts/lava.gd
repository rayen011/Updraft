extends Node2D

var player
var up_speed = 0.0

@onready var add_speed_timer: Timer = $add_speed_timer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	up_speed = player.up_speed
	add_speed_timer.wait_time = 10
	add_speed_timer.start()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("touched player")
func _process(delta: float) -> void:
	position.y -= up_speed *delta


func _on_add_speed_timer_timeout() -> void:
	print("added speed")
	up_speed += 10

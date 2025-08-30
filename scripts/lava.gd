extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("touched player")
func _process(delta: float) -> void:
	position.y -= 170 *delta

extends Node2D

signal area_entered(body)


func _on_pass_layer_body_entered(body: Node2D) -> void:
	if body is Player:
		area_entered.emit(body)

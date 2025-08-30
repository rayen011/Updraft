# res://scenes/items/pickup.gd
extends Area2D

@export var data: ItemData   # Which item/boost this pickup represents

func _ready() -> void:
	if data and data.sprite:
		$Sprite2D.texture = data.sprite   # Automatically show the item’s sprite

# When something touches this pickup
func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.collect_item(data)
		queue_free()   # remove the pickup after collection

# res://scenes/items/pickup.gd
extends Area2D
class_name Item
@export var data: ItemData   # Which item/boost this pickup represents
var expired_timer = Timer.new()
func _ready() -> void:
	expired_timer.autostart = true
	expired_timer.one_shot = true
	expired_timer.wait_time = 10
	add_child(expired_timer)
	expired_timer.connect("timeout", Callable(self, "_on_my_timer_timeout"))
	if data and data.sprite:
		$Sprite2D.texture = data.sprite   # Automatically show the item’s sprite

# When something touches this pickup

func _on_area_entered(area: Area2D) -> void:
	var player
	player = area.get_parent()
	player.collect_item(data)
	queue_free()   # remove the pickup after collection

func _on_my_timer_timeout():
	queue_free()

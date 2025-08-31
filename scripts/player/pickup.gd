# res://scenes/items/pickup.gd
extends Area2D
class_name Item
@export var data: ItemData   # Which item/boost this pickup represents
var expired_timer = Timer.new()
func _ready() -> void:
	$popup.play()
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
	if area.get_parent().is_in_group("Player"):
		player = area.get_parent()
		$pick_audio.play()
	elif area.get_parent().is_in_group("Umbrella"):
		player = area.get_parent().get_parent()
	else:
		return
	player.collect_item(data)
	queue_free()   # remove the pickup after collection

func _on_my_timer_timeout():
	queue_free()

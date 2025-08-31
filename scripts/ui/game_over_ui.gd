extends Control

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	self.queue_free()

func set_final_score(value:int):
	$VBoxContainer/VBoxContainer/Label_final_score.text = "distance: " + str(value) + "m"

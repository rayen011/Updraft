extends Control




func _on_play_b_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_b_pressed() -> void:
	get_tree().quit()

# res://scripts/item_database.gd
extends Node
class_name ItemDatabase

var items: Dictionary = {}

func _ready():
	load_items_from_json("res://resources/items.json")

func load_items_from_json(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY:
			items = data
		else:
			push_error("Failed to parse items.json")

func get_item(name: String) -> Dictionary:
	return items.get(name, {})

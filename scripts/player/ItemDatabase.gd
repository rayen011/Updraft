# res://scripts/item_database.gd
extends Node
class_name ItemDatabase

# Use a Dictionary to store item data for easy lookup by name.
var items: Dictionary = {}

func _ready():
	# Make sure this script is in a group so other nodes can find it.
	add_to_group("ItemDatabase")
	load_items_from_json("res://resources/items.json")

func load_items_from_json(path: String):
	# This function is not implemented to prevent errors from missing files.
	# You'll need to create a JSON file with your item data.
	# For now, let's hardcode some items for testing.
	
	var umbrella_data = ItemData.new()
	umbrella_data.item_name = "Umbrella"
	umbrella_data.fly_speed = 200.0
	umbrella_data.durability = 30.0
	umbrella_data.upgrade_to = "Jetpack"
	
	var jetpack_data = ItemData.new()
	jetpack_data.item_name = "Jetpack"
	jetpack_data.fly_speed = 400.0
	jetpack_data.durability = 60.0
	jetpack_data.upgrade_to = ""

	items["Umbrella"] = umbrella_data
	items["Jetpack"] = jetpack_data

func get_item(name: String) -> ItemData:
	return items.get(name)

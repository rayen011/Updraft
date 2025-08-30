# res://resources/item_data.gd
extends Resource
class_name ItemData

@export var item_name: String = "Unnamed Item"
@export var description: String = ""
@export var sprite: Texture2D
@export var fly_speed: float = 100.0
@export var direction_speed:float = 300.0
@export var durability: float = 10.0  # seconds or "health" before breaking
@export var upgrade_to: String = ""   # name of the next upgrade item

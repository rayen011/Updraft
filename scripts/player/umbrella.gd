extends Node2D
class_name Umbrella
@onready var hand_marker: Marker2D = $handMarker


@export var data: ItemData   # link to resource (umbrella.tres)
@onready var durability_bar: ProgressBar = $durabilityBar

var current_durability: float

func _ready() -> void:
	if data:
		current_durability = data.durability
		print("Equipped item:", data.item_name, " | Durability:", data.durability)
		durability_bar.max_value = current_durability
func _process(delta: float) -> void:
	current_durability -= .8 *delta
	durability_bar.value = current_durability

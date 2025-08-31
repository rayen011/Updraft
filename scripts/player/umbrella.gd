extends Node2D
class_name Umbrella

signal fuel_out

@onready var hand_marker: Marker2D = $handMarker


@export var data: ItemData   # link to resource (umbrella.tres)
@onready var durability_bar: ProgressBar = $durabilityBar

var current_durability: float
var durability_take:float = 0.5
func _ready() -> void:
	if data:
		current_durability = data.durability
		print("Equipped item:", data.item_name, " | Durability:", data.durability)
		durability_bar.max_value = current_durability
func _process(delta: float) -> void:
	current_durability -= durability_take *delta
	durability_bar.value = current_durability
	check_durabilty()

func take_damage(damage_amount: float) -> void:
	current_durability -= damage_amount
	
func check_durabilty():
	if data.item_name == "Jetpack":
		if current_durability < (data.durability *0.4):
			$engineloweffect.emitting = true
			$engineeffect.emitting = false
		else:
			$engineloweffect.emitting = false
			$engineeffect.emitting = true
	if current_durability <= 0:
		fuel_out.emit()
	if data.item_name == "Jetpack":
		$engineloweffect.emitting = false
		$engineeffect.emitting = false

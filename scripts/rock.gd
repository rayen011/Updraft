extends RigidBody2D
class_name Rock

@export var effect_type: String = "durability_damage"
@export var effect_value: float = 0.1

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Rocks should fall naturally, so use gravity
	gravity_scale = 1.0
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC # optional, keeps consistent rotation if needed
	angular_damp = 1.5 # less spinning if it looks weird

	# Remove rock after some time to avoid clutter
	var timer = Timer.new()
	timer.wait_time = 10
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Example: apply effect to player
		if effect_type == "durability_damage":
			body.apply_durability_damage(effect_value)
		elif effect_type == "speed_down":
			body.apply_speed_modifier(-effect_value)
		elif effect_type == "down_force":
			body.apply_downward_push(effect_value)

		# Destroy the rock after hitting
		#queue_free()

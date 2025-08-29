extends CharacterBody2D
class_name Player

# ------------------------------
# Movement settings
# ------------------------------
const SPEED := 300.0
var up_speed := 150.0

# ------------------------------
# Umbrella swing settings
# ------------------------------
const MAX_TILT := 12.0 * (PI / 180.0)    # 12 degrees -> radians
const SWING_SPEED := 5.0
const RETURN_SPEED := 8.0

var umbrella_scene := preload("res://scenes/player/umbrella.tscn")
var umbrella: Node2D

# used for idle wobble (safer than OS/Time calls)
var _idle_wobble_time := 0.0

# ------------------------------
# Ready
# ------------------------------
func _ready() -> void:
	umbrella = umbrella_scene.instantiate()
	# attach umbrella to the hand marker so it follows automatically
	$hand_marker.add_child(umbrella)
	umbrella.position = Vector2.ZERO

# ------------------------------
# Physics loop
# ------------------------------
func _physics_process(delta: float) -> void:
	_idle_wobble_time += delta

	# constant upward motion
	global_position.y -= up_speed * delta

	# horizontal input
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		# smooth deceleration toward zero
		velocity.x = lerp(velocity.x, 0.0, 10.0 * delta)

	# umbrella swing
	swing_umbrella(direction, delta)

	# move the character (CharacterBody2D uses its velocity property)
	move_and_slide()

# ------------------------------
# Swing logic
# ------------------------------
func swing_umbrella(direction: float, delta: float) -> void:
	var target_angle: float = 0.0

	if direction < 0.0:
		target_angle = -MAX_TILT
	elif direction > 0.0:
		target_angle = MAX_TILT
	else:
		# gentle idle wobble (3 degrees)
		var wobble := 3.0 * (PI / 180.0)
		target_angle = sin(_idle_wobble_time * 2.5) * wobble

	# correct conditional expression (GDScript uses: X if cond else Y)
	var tilt_speed := RETURN_SPEED if direction == 0.0 else SWING_SPEED
	var weight = clamp(tilt_speed * delta, 0.0, 1.0)

	# use lerp_angle for smooth rotation across wrap-around
	umbrella.rotation = lerp_angle(umbrella.rotation, target_angle, weight)

extends CharacterBody2D
class_name Player

# ------------------------------
# Movement settings
# ------------------------------


# ------------------------------
# Umbrella swing settings
# ------------------------------
const MAX_TILT := 12.0 * (PI / 180.0)    # 12 degrees -> radians
const SWING_SPEED := 5.0
const RETURN_SPEED := 8.0

var umbrella_scene := preload("res://scenes/player/lava_umrella.tscn")
var umbrella: Node2D

@onready var boost_timer: Timer = $boost_timer


var up_speed:float
var temp_speed:float
var has_booster:bool = false
# used for idle wobble (safer than OS/Time calls)
var _idle_wobble_time := 0.0

# ------------------------------
# Ready
# ------------------------------
func _ready() -> void:
	umbrella = umbrella_scene.instantiate()
	umbrella.fuel_out.connect(_on_fuel_out)
	# attach umbrella to the hand marker so it follows automatically
	up_speed = umbrella.data.fly_speed
	$hand_marker.add_child(umbrella)
	umbrella.position = Vector2.ZERO

# ------------------------------
# Physics loop
# ------------------------------
func _physics_process(delta: float) -> void:
	_idle_wobble_time += delta
	if velocity.y >0:
		velocity.y = -1/2
	# constant upward motion
	global_position.y -= up_speed * delta

	# horizontal input
	var direction := Input.get_axis("left", "right")
	if direction != 0.0:
		velocity.x = direction * umbrella.data.direction_speed
	else:
		# smooth deceleration toward zero
		velocity.x = lerp(velocity.x, 0.0, 10.0 * delta)

	# umbrella swing
	swing_umbrella(direction, delta)
	swing_player(direction, delta)
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

func swing_player(direction: float, delta: float) -> void:
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
	rotation = lerp_angle(rotation, target_angle, weight)


func collect_item(item: ItemData) -> void:
	match item.item_name:
		"Durability Boost":
			if umbrella:
				umbrella.current_durability += item.durability
				print("Boost! Durability is now:", umbrella.current_durability)

		"Speed Boost":
			if !has_booster:
				has_booster = true
				temp_speed = up_speed
				up_speed += item.fly_speed
				print("Boost! Fly speed is now:", up_speed)
				boost_timer.start(5)
			else:
				up_speed += item.fly_speed
				print("Boost Again! Fly speed is now:", up_speed)
		_:
			print("Picked up:", item.item_name)

func _on_fuel_out():
	up_speed = 0


func _on_boost_timer_timeout() -> void:
	up_speed = temp_speed
	has_booster = false
	
func apply_durability_damage(effect_value):
	umbrella.current_durability -= umbrella.current_durability*effect_value

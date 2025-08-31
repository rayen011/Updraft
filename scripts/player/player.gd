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

# Exported scene variables for different umbrellas
@export var umbrella_scene := preload("res://scenes/player/jetpack.tscn")
@export var jetpack_scene := preload("res://scenes/player/jetpack.tscn")

var umbrella: Node2D

@onready var boost_timer: Timer = $boost_timer

# Signal to request an upgrade
signal upgrade_request(item_scene: PackedScene)

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
	
	# horizontal movement
	velocity.x = direction * umbrella.data.direction_speed

	# clamp player to the screen
	global_position.x = clamp(global_position.x, 0, 500)
	move_and_slide()

	# swing animations
	swing_umbrella(direction, delta)
	swing_player(direction, delta)

# ------------------------------
# Internal functions
# ------------------------------
func _on_fuel_out() -> void:
	print("Out of fuel!")
	up_speed = -100
	
func _on_boost_timer_timeout():
	has_booster = false
	temp_speed = up_speed
	print("Boost ended. Speed is now:", up_speed)
	
func swing_umbrella(direction: float, delta: float) -> void:
	var target_angle: float = 0.0

	if direction < 0.0:
		target_angle = MAX_TILT
	elif direction > 0.0:
		target_angle = -MAX_TILT
	else:
		# gentle idle wobble (3 degrees)
		var wobble := 3.0 * (PI / 180.0)
		target_angle = sin(_idle_wobble_time * 2.5) * wobble

	# use lerp_angle for smooth rotation across wrap-around
	var tilt_speed := RETURN_SPEED if direction == 0.0 else SWING_SPEED
	var weight = clamp(tilt_speed * delta, 0.0, 1.0)
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

		"Jetpack":
			# Instead of upgrading directly, we tell the Game Manager to do it.
			upgrade_request.emit(jetpack_scene)

func take_damage(damage_amount: float) -> void:
	if is_instance_valid(umbrella):
		umbrella.take_damage(damage_amount)
		print("Player takes damage: ", damage_amount)

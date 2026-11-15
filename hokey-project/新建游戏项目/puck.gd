extends RigidBody3D

# Movement settings
@export var start_speed: float = 5.0
@export var speed_increase: float = 0.4
@export var max_speed: float = 12.0

# Puck starting position
var spawn_position: Vector3
var current_speed: float = 5.0

func _ready() -> void:
	spawn_position = global_position

	gravity_scale = 0.0
	lock_rotation = true
	continuous_cd = true

	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	linear_damp = 0.0

	contact_monitor = true
	max_contacts_reported = 8

	current_speed = start_speed

	body_entered.connect(_on_body_entered)

	launch_puck()


func launch_puck() -> void:
	var direction = Vector3(
		randf_range(-0.5, 0.5),
		0.0,
		[-1.0, 1.0].pick_random()
	).normalized()

	linear_velocity = direction * current_speed


func _physics_process(_delta: float) -> void:
	var flat_velocity = Vector3(
		linear_velocity.x,
		0.0,
		linear_velocity.z
	)

	if flat_velocity.length() > 0.1:
		linear_velocity = (
			flat_velocity.normalized() * current_speed
		)


func _on_body_entered(_body: Node) -> void:
	current_speed = min(
		current_speed + speed_increase,
		max_speed
	)


func reset_puck() -> void:
	current_speed = start_speed

	set_deferred("freeze", true)

	await get_tree().physics_frame

	global_position = spawn_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	set_deferred("freeze", false)

	await get_tree().physics_frame

	launch_puck()

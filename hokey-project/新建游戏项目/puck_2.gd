extends RigidBody3D

var stuck_timer: float = 0.0
var stuck_limit: float = 3.0
var start_transform: Transform3D

func _ready() -> void:
	start_transform = global_transform
	can_sleep = false


func _physics_process(delta: float) -> void:
	var speed = Vector2(linear_velocity.x, linear_velocity.z).length()

	if speed < 0.2:
		stuck_timer += delta
	else:
		stuck_timer = 0.0

	if stuck_timer >= stuck_limit:
		stuck_timer = 0.0
		reset_puck()


func reset_puck() -> void:
	set_physics_process(false)
	call_deferred("_safe_reset")


func _safe_reset() -> void:
	freeze = true

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	global_transform = start_transform

	await get_tree().physics_frame

	freeze = false
	sleeping = false

	apply_central_impulse(Vector3(1.5, 0.0, 2.0))
	set_physics_process(true)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("paddle"):
		var offset = $CollisionShape3D.global_position - body.global_position
		offset.y = 0.0

		var future_offset = offset - body.strike_velocity * 0.01
		future_offset.y = 0.0

		if future_offset.length_squared() < offset.length_squared():
			var force = body.strike_velocity * 1.2
			apply_central_impulse(force)

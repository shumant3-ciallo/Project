extends RigidBody3D

@export var puck_speed: float = 5.0

func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = 0.0

	var direction = Vector3(0.3, 0.0, 1.0).normalized()
	linear_velocity = direction * puck_speed

func _physics_process(_delta: float) -> void:
	if linear_velocity.length() > 0.1:
		var direction = linear_velocity.normalized()
		direction.y = 0.0
		linear_velocity = direction.normalized() * puck_speed

extends AnimatableBody3D

@export var puck: RigidBody3D
@export var speed: float = 5.0

# Movement boundaries (adjust in Inspector)
@export var min_x: float = -2.0
@export var max_x: float = 2.0
@export var min_z: float = -2.5
@export var max_z: float = -0.35

# Table center
@export var center_z: float = 0.0

# False = AI on negative Z side
# True = AI on positive Z side
@export var ai_on_positive_z: bool = true

var paddle_velocity: Vector3 = Vector3.ZERO
var start_position: Vector3


func _ready() -> void:
	start_position = global_position

	if puck == null:
		push_warning("Puck is not assigned!")
		return

	print("AI position: ", global_position)
	print("Puck position: ", puck.global_position)


func _physics_process(delta: float) -> void:
	if puck == null:
		return

	if delta <= 0.0:
		return

	var before = global_position

	var target = start_position

	# Check if puck is on AI side
	var puck_in_ai_side: bool

	if ai_on_positive_z:
		puck_in_ai_side = puck.global_position.z >= center_z
	else:
		puck_in_ai_side = puck.global_position.z <= center_z

	# Follow puck only when it enters AI territory
	if puck_in_ai_side:
		target.x = puck.global_position.x
		target.z = puck.global_position.z

	# Keep paddle inside table boundaries
	target.x = clampf(target.x, min_x, max_x)
	target.z = clampf(target.z, min_z, max_z)
	target.y = start_position.y

	# Calculate movement
	var movement = target - global_position
	movement.y = 0.0

	var max_distance = speed * delta

	if movement.length() > max_distance:
		movement = movement.normalized() * max_distance

	# Move with collision checking
	move_and_collide(movement)

	# Calculate actual paddle velocity
	paddle_velocity = (global_position - before) / delta


# Keep this method because Puck2 has a signal connected to it
func _on_puck_2_body_entered(_body: Node3D) -> void:
	pass

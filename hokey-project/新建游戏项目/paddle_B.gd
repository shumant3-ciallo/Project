extends AnimatableBody3D

@export var puck: RigidBody3D
@export var speed: float = 5.0

var paddle_velocity = Vector3.ZERO
var start_position: Vector3
var strike_velocity = 0; 
@export var center_line: Marker3D
func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	if puck == null:
		return

	var before = global_position
	var puckCenter = puck.get_node("CollisionShape3D").global_position
	var target: Vector3 = global_position

	
	target.x = puckCenter.x
	target.z = puckCenter.z

	# Stay on the bots side of the table
	if puckCenter.z > center_line.position.z:
		target.z = min(target.z, start_position.z)
	else:	
		target.z = min(target.z, center_line.global_position.z)

	var movement = target - global_position
	var max_distance = speed * delta

	if movement.length() > max_distance:
		movement = movement.normalized() * max_distance
	strike_velocity = movement / delta
	move_and_collide(movement)
   
	paddle_velocity = (global_position - before) / delta
	


func _on_puck_2_body_entered(body: Node) -> void:
	pass # Replace with function body.

extends AnimatableBody3D

@export var puck: RigidBody3D
@export var speed: float = 5.0

var paddle_velocity = Vector3.ZERO
var start_position: Vector3
var strike_velocity = Vector3.ZERO
var attack_time := 0.0
var attack_target := Vector3.ZERO

var radius = 0.072
@export var prepare_distance := 0.18
@export var attack_distance := 0.18
@export var paddle_radius := 0.072
@export var center_line: Marker3D


func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	if puck == null:
		return
	global_position.x = clamp(global_position.x,-0.185,0.638)
	global_position.z = clamp(global_position.z,0.427,1.96)
	var before = global_position
	var puckCenter = puck.get_node("CollisionShape3D").global_position
	var target: Vector3 = global_position

	
	target.x = puckCenter.x
	target.z = puckCenter.z
	
	var middlez = center_line.global_position.z

	# Stay on the bots side of the table
	if puckCenter.z > middlez:
		attack_time = 0.0
		target = Vector3(puckCenter.x,start_position.y,start_position.z)
		
	elif attack_time > 0.0:
	# during attcak keepgoingon
		attack_time = maxf(attack_time - delta, 0.0)
		target = attack_target
	else:
		var prepare_target := Vector3( puckCenter.x,
		start_position.y,
		puckCenter.z - prepare_distance
		)
		target = prepare_target;
		if global_position.distance_to(prepare_target) < 0.025:
			attack_time = 0.2
			attack_target = Vector3(
				puckCenter.x,
				start_position.y,
				puckCenter.z + attack_distance
			)
			target = attack_target
	


	var movement = target - global_position
	var max_distance = speed * delta

	if movement.length() > max_distance:
		movement = movement.normalized() * max_distance
	strike_velocity = movement / delta
	move_and_collide(movement)
	
	paddle_velocity = (global_position - before) / delta
	


func _on_puck_2_body_entered(body: Node) -> void:
	pass # Replace with function body.

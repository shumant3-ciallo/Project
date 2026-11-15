extends AnimatableBody3D
@export var max_speed: float = 3.0
var clickOn = false;
var mouse
var origin
var distance
var end
var start_position: Vector3 
var plane 
var paddle_velocity = Vector3.ZERO
var strike_velocity := Vector3.ZERO
var previous_position;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position;
	previous_position = global_position;
func getPosition():
		var camera := $"../Camera3D" as Camera3D
		mouse = get_viewport().get_mouse_position()
		origin =  camera.project_ray_origin(mouse);
		distance =camera.project_ray_normal(mouse)
		plane = Plane(Vector3.UP, start_position.y)
		var hit = plane.intersects_ray(origin, distance)
		return hit
		
func mouse_hits_paddle() -> bool:
	var camera := $"../Camera3D" as Camera3D
	var mouse_pos := get_viewport().get_mouse_position()

	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_direction := camera.project_ray_normal(mouse_pos)

	var query := PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_origin + ray_direction * camera.far
	)

	var result := get_world_3d().direct_space_state.intersect_ray(query)
	return not result.is_empty() and result["collider"] == self
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var drag_offset := Vector3.ZERO

func _physics_process(delta: float) -> void:
	var before := global_position

	if Input.is_action_just_pressed("mouseClick"):
		clickOn = false

		if mouse_hits_paddle():
			var hit = getPosition()
			if hit != null:
				clickOn = true

				drag_offset = global_position - hit
				drag_offset.y = 0.0

	if Input.is_action_just_released("mouseClick"):
		clickOn = false

	if clickOn:
		var hit = getPosition()
		if hit != null:
			var target: Vector3 = hit + drag_offset
			target.y = start_position.y
			var motion := target - global_position
			motion.y = 0.0
			motion = motion.limit_length(max_speed * delta)

			strike_velocity = motion / delta

			move_and_collide(motion)


	paddle_velocity = (global_position - before) / delta


func _on_puck_2_body_entered(body: Node) -> void:
	pass # Replace with function body.

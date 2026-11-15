extends AnimatableBody3D
var clickOn = false;
var mouse
var origin
var distance
var end
var start_position: Vector3 
var plane 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position;
	
func getPosition():
		var camera := $"../Camera3D" as Camera3D
		mouse = get_viewport().get_mouse_position()
		origin =  camera.project_ray_origin(mouse);
		distance =camera.project_ray_normal(mouse)
		plane = Plane(Vector3.UP, start_position.y)
		var hit = plane.intersects_ray(origin, distance)
		return hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouseClick"):
		clickOn = true
	if Input.is_action_just_released("mouseClick"):
		clickOn = false
	if clickOn == true:
		# target 是鼠标射线计算出的世界坐标目标。
		var hit = getPosition()
		var target := Vector3(hit.x, start_position.y, hit.z)
		var motion := target - global_position

# 限制每个物理帧的移动距离。
		motion = motion.limit_length(300 * delta)

		move_and_collide(motion)
		
		


# Replace with function body.

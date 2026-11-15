extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	
	
	if body.is_in_group("paddle"):
		var offset = $CollisionShape3D.global_position - body.global_position
		offset.y = 0.0
		
		var future_offset = offset - body.strike_velocity * 0.01
		future_offset.y = 0.0
		if future_offset.length_squared() < offset.length_squared():
			var force = body.strike_velocity*1.7
			apply_central_impulse(force) # Replace with function body.

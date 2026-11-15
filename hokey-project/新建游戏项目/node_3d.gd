extends Node3D
var red_score: int=0
var blue_score: int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_blue_goal_body_entered(body: Node3D) -> void:
	if body.name == "Puck" or body.name =="Puck2":
		red_score += 1
		print("Red Scored! Score:", red_score)

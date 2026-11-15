
extends OmniLight3D

@export var color_offset: int = 0

var timer: float = 0.0
var color_index: int = 0

var colors = [
	Color("#FF365E"), # Red
	Color("#FF9F1C"), # Orange
	Color("#FFE14A"), # Yellow
	Color("#37D67A"), # Green
	Color("#328CFF"), # Blue
	Color("#A855F7"), # Purple
	Color("#FF55C8")  # Pink
]

func _ready() -> void:
	update_color()

func _process(delta: float) -> void:
	timer += delta

	if timer >= 0.3:
		timer -= 0.3
		color_index = (color_index + 1) % colors.size()
		update_color()

func update_color() -> void:
	var index = (color_index + color_offset) % colors.size()
	light_color = colors[index]

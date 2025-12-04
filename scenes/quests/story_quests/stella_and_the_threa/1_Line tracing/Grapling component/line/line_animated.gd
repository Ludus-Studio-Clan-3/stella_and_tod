extends Node2D

@export var start_point: Vector2
@export var end_point: Vector2
@export var speed: float = 100.0

var line: Line2D
var progress: float = 0.0

func _ready():
	line = Line2D.new()
	line.width = 4
	line.default_color = Color(1,1,1,0.95)
	line.points = [start_point, start_point]
	add_child(line)

func _process(delta):
	if progress >= 1.0:
		return

	var total_dist = start_point.distance_to(end_point)
	progress += speed * delta / total_dist
	progress = clamp(progress, 0, 1)

	# compute the line's current pos
	var current_pos = start_point.lerp(end_point, progress)
	line.points[1] = current_pos

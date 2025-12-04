extends Node2D

@export var start_point: Vector2
@export var end_point: Vector2
@export var speed: float = 200.0
@export var circle_radius: float = 60.0
@export var circle_color: Color = Color.WHITE

@export var hand_draw_strength: float = 0.5

var progress := 0.0
var line_points := []
var real_start: Vector2
var real_end: Vector2


func _ready():
	var dir = (end_point - start_point).normalized()
	real_start = start_point + dir * circle_radius
	real_end   = end_point - dir * circle_radius


func _process(delta):
	if progress < 1.0:
		var dist = real_start.distance_to(real_end)
		progress += speed * delta / dist
		progress = clamp(progress, 0.0, 1.0)

		var p = real_start.lerp(real_end, progress)
		line_points.append(p)

	queue_redraw()


func _draw():
	# --- Cicrles ---
	draw_arc(start_point, circle_radius, 0, TAU, 64, circle_color, 4)
	draw_arc(end_point, circle_radius, 0, TAU, 64, circle_color, 4)

	if line_points.size() < 2:
		return

	var noisy_points: Array = []
	var t = Time.get_ticks_msec() * 0.001

	for i in range(line_points.size()):
		var p = line_points[i]

		var offset = Vector2(
			sin(t * 3.1 + i * 0.5),
			cos(t * 2.7 + i * 0.8)
		) * hand_draw_strength

		noisy_points.append(p + offset)

	# --- Line ---
	for i in range(noisy_points.size() - 1):
		draw_line(noisy_points[i], noisy_points[i+1], Color.WHITE, 4, true)

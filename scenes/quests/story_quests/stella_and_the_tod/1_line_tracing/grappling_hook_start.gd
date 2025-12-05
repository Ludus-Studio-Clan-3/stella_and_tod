extends Node2D

@onready var fog_mat = $Fog/ParallaxLayer/ColorRect.material
var fog_density := 0.0

const MAX_DENSITY := 3.0
const MIN_DENSITY := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("LevelManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fog_density = clamp(fog_density + delta * 0.02, MIN_DENSITY, MAX_DENSITY)
	fog_mat.set_shader_parameter("density", fog_density)

func reduce_fog(amount: float = 0.5) -> void:
	fog_density = clamp(fog_density - amount, MIN_DENSITY, MAX_DENSITY)
	fog_mat.set_shader_parameter("density", fog_density)

func reduce_fog_smooth(amount: float = 0.5, duration: float = 2.5):
	var new_density = clamp(fog_density - amount, MIN_DENSITY, MAX_DENSITY)
	var tween = create_tween()
	tween.tween_property(self, "fog_density", new_density, duration)
	tween.tween_callback(Callable(self, "_update_shader"))

func _update_shader():
	fog_mat.set_shader_parameter("density", fog_density)

func desable_fog_smooth(amount: float = 0.5, duration: float = 2.5):
	var new_density = clamp(fog_density - amount, MIN_DENSITY, MAX_DENSITY)
	var tween = create_tween()
	tween.tween_property(self, "fog_density", new_density, duration)
	tween.tween_callback(Callable(self, "_disable_fog"))
	
func _disable_fog():
	var fog_canvas = $Fog
	if fog_canvas :
		fog_canvas.visible = false

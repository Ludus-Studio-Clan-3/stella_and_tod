extends Node2D


@onready var fog_mat = $Fog/ParallaxLayer/ColorRect.material

var fog_density = 0.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fog_density = clamp(fog_density + delta * 0.02 , 0.0, 3.0)
	fog_mat.set_shader_parameter("density", fog_density)   

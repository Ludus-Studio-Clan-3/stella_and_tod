extends Node2D

@export var sparkle_duration: float = 0.6

# nodes attendus
@onready var spr = $Sprite if has_node("Sprite") else null
@onready var glow = $PointLight2D if has_node("PointLight2D") else null
@onready var sfx = $AudioStreamPlayer2D if has_node("AudioStreamPlayer2D") else null

func _ready():
	# initial low alpha
	if spr:
		spr.modulate = Color(1,1,1,0.25)
	if glow:
		glow.energy = 0.0

func light_up():
	var tween = create_tween()
	if spr:
		tween.tween_property(spr, "modulate:a", 1.0, sparkle_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if glow:
		tween.tween_property(glow, "energy", 1.5, sparkle_duration).set_trans(Tween.TRANS_SINE)
	if sfx:
		sfx.play()

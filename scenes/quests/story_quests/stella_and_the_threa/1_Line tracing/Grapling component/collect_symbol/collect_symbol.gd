extends Area2D
#when player collects the symbol
signal collected(symbol_node)

@export var id: int = 1

var picked: bool = false
@onready var sprite = $Sprite

func _ready():
	sprite.modulate = Color(0.75, 0.75, 0.75, 1.0)
	sprite.frame = id
	

func _on_body_entered(body):
	if picked:
		return
	if not body or not body.is_in_group("player"):
		return

	picked = true
	sprite.modulate = Color(0.827, 0.353, 0.157, 1.0)
	if $CollectParticles:
		$CollectParticles.emitting = true
	if $CollectSfx:
		$CollectSfx.play()
	emit_signal("collected", self)
	await get_tree().create_timer(0.8).timeout
	queue_free()

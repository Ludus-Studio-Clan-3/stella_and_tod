extends Area2D
signal lever_activated()

@export var auto_disable_after_use: bool = true

var used: bool = false

func _on_body_entered(body):
	if used:
		return
	if not body or not body.is_in_group("player"):
		return
	print("player body entered lever")
	
	used = true
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("on")
	emit_signal("lever_activated")
	if auto_disable_after_use:
		if $Sprite:
			$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)

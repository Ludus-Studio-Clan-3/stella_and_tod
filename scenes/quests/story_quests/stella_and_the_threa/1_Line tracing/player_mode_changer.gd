extends Area2D

@onready var player:= %Player;

func _ready() -> void:
	pass

		 
func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		player.change_mode_from_number(1)


func _on_body_exited(body: Node2D) -> void:

	if(body.is_in_group("player")):
		player.change_mode_from_number(3)

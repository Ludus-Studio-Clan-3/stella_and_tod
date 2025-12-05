extends Area2D

signal toggled(is_on: bool)

@export var interact_action: StringName = "interact"
@export var is_on: bool = false       

@onready var player_inside = false
@onready var player_ref = null

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	_update_appearance()


func _on_body_entered(body):
	if body.is_in_group("player"):
		print('body entered')
		player_inside = true
		player_ref = body
		body.change_mode_from_number(1)


func _on_body_exited(body):
	if body == player_ref:
		player_inside = false
		player_ref = null
		body.change_mode_from_number(3)

func _process(delta):
	if not player_inside:
		return
	
	if Input.is_action_just_pressed(interact_action):
		_toggle()


func _toggle():
	is_on = !is_on
	_update_appearance()
	emit_signal("toggled", is_on)


func _update_appearance():
	if has_node("Sprite2D"):
		$Sprite2D.frame = 1 if is_on else 0

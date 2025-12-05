extends Node

@export_category("Config")
@export var sky_symbol_scene: PackedScene = preload("uid://bc2g6tst4jm1c")
@export var line_width: float = 6.0
@export var line_color: Color = Color(1,1,1,0.95)
@export var sky_center: Vector2 = Vector2(1280/2, 720/2)
#@export var sky_center: Vector2 = Vector2(1280, 720)
@export var sky_radius: float = 220.0
@export var placement_mode: String = "arc" # "arc", "circle", "random_arc"

# runtime state
var collect_order: Array = []  # instances CollectSymbol collected (order)
var sky_symbols: Array = []    # instances SkySymbol (ordre = collect_order)
var can_draw: bool = false
var current_index: int = 0


# references nodes
@onready var collect_root =$"../CollectSymbols" if has_node("../CollectSymbols") else $CollectSymbols
@onready var levers_root = $"../Levers"
@onready var sky_root = $"../SkyRoot"
@onready var lines_root = $"../SkyRoot"
# debug
@onready var debug_label = get_node_or_null("DebugLabel")
@onready var specialNeedle = $"../OnTheGround/HoockableNeedes/SpecialNeedle"

func _ready():
	# Connect collect symbols
	for s in collect_root.get_children():
		if s.has_signal("collected"):
			s.connect("collected", Callable(self, "_on_collect_symbol"))

	# Connect levers
	for l in levers_root.get_children():
		if l.has_signal("toggled"):
			l.connect("toggled", Callable(self, "_on_lever_toggled"))

	#just for debug
	if debug_label:
		debug_label.text = "Collect 0/" + str(collect_root.get_child_count())

func _on_lever_toggled(is_on: bool):
	if not is_on:
		return

	_on_lever_activated()
	
# --- collecte ---
func _on_collect_symbol(symbol_node):
	if symbol_node in collect_order:      
		return
	collect_order.append(symbol_node)
	_update_debug()
	var level_manager = get_tree().get_first_node_in_group("LevelManager")
	if level_manager:
		level_manager.reduce_fog_smooth(0.6, 3.0)
	
	# if all symbols collected -> build sky
	if collect_order.size() == 4 :
		if specialNeedle:
			specialNeedle.visible = true
			
		can_draw = true
		_build_sky_symbols()

func _update_debug():
	if debug_label:
		debug_label.text = "Collect " + str(collect_order.size()) + "/" + str(collect_root.get_child_count())

# --- psitions ---
func _generate_positions(n: int) -> Array:
	print('_generate_positions')
	var res := []
	if placement_mode == "circle":
		for i in range(n):
			var angle = float(i) / float(n) * TAU
			var pos = sky_center + Vector2(cos(angle), sin(angle)) * sky_radius
			res.append(pos)
		return res
	elif placement_mode == "random_arc":
		# top random arc
		var spread = 1.4 # radians
		var start = -PI/2 - spread/2
		for i in range(n):
			var t = float(i) / max(1, n-1)
			var angle = start + t * spread + randf_range(-0.12,    0.12)
			var r = sky_radius * randf_range(0.9, 1.1)
			res.append(sky_center + Vector2(cos(angle), sin(angle)) * r)
		return res
	else: # arc (default)
		var spread = 1.2
		var start = -PI/2 - spread/2
		for i in range(n):
			var t = float(i) / max(1, n-1)
			var angle = start + t * spread
			res.append(sky_center + Vector2(cos(angle), sin(angle)) * sky_radius)
		return res

# --- build SkySymbols place them in the collect_order order ---
func _build_sky_symbols():
	print("_build_sky_symbols")
	# clean the sky, just in case
	for child in sky_root.get_children():
		child.queue_free()
	sky_symbols.clear()

	var n = collect_order.size()
	var positions = _generate_positions(n)

	print('postinons ', positions)
	print('taille = ', n)
	for i in range(n):
		var sky_inst = sky_symbol_scene.instantiate()
		sky_inst.global_position = positions[i]
		
		sky_inst.set_meta("collected_ref", collect_order[i])
		print("sky_inst", sky_inst)
		print('')
		sky_root.add_child(sky_inst)
		sky_symbols.append(sky_inst)
		print("sky_root", sky_root.get_children())
		print('sky_root_size', sky_root.get_children().size())
		print("sky_symbols", sky_symbols)        
	
	#just for test need to be deleted
	#_on_lever_activated()


# --- trace the next ligne ---
func _on_lever_activated():
	print('on_lever_activated')
	if not can_draw:
		# feedback
		print("Constellation still locked.")
		return
	if current_index >= sky_symbols.size() - 1:
		print("all lignes traced.")
		return

	var A = sky_symbols[current_index]
	var B = sky_symbols[current_index + 1]
	
	print("")
	print("")
	print("A = ", A)
	print("A.global_position = ", A.global_position)
	print("")
	print("B.global_position = ", B.global_position)
	"""
	var line := Line2D.new()
	line.width = 4
	line.default_color = Color.WHITE
	line.points = [A.global_position, B.global_position]

	get_tree().current_scene.add_child(line)
	"""
	
	_create_animated_line(A.global_position, B.global_position)
	# light up symbols
	if A.has_method("light_up"):
		print('A.light-up')
		A.light_up()
	if B.has_method("light_up"):
		print('B.light-up')
		B.light_up()

	current_index += 1

	# if done -> callback
	if current_index >= sky_symbols.size() - 1:
		_on_constellation_complete()

# ---  (Line2D with) ---
func _create_animated_line(a: Vector2, b: Vector2):
	var level_manager = get_tree().get_first_node_in_group("LevelManager")
	if level_manager:
		level_manager.desable_fog_smooth(0.3, 1.5)
		
	var line_anim = preload("uid://cidb76x5gqoj6").instantiate()
	line_anim.start_point = a
	line_anim.end_point = b
	sky_root.add_child(line_anim)




func _on_line_tween_finished(line):
	print('_on_line_tween_finished')
	var sfx = AudioStreamPlayer2D.new()
	
	sfx.stream = preload("res://assets/third_party/nepalese_hand_bells/handBells-f4.ogg")
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", Callable(sfx, "queue_free"))

func _on_constellation_complete():
	print("Constellation complète !")
	# final animation
	var memoire = $"../OnTheGround/CollectibleItem"
	if memoire:
		memoire.visible = true
	for s in sky_symbols:
		if s.has_method("light_up"):
			s.light_up()

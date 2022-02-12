extends Dude
class_name Player

signal input_enabled_changed(val)

onready var input_enabled := has_node("camera") setget set_input_enabled

func _ready():
	._ready()
	emit_signal("input_enabled_changed", input_enabled)


func _input(event):
	if input_enabled:
		if event.is_action_pressed("ui_accept"):
			jump = true
		if event.is_action_pressed("interact"):
			interact = true
		if event.is_action_pressed("switch"):
			call_deferred("switch_focus")
		if event.is_action_pressed("focus_all"):
			call_deferred("focus_all")
			
func switch_focus():
	var players = get_tree().get_nodes_in_group("player")
	var start_i = players.find(self)
	var i = 1
	
	var end_i = players.size()
	while !players[(start_i + i) % players.size()].alive and i != end_i:
		i += 1
	if i != end_i:
		for player in players:
			player.input_enabled = false
		var player_with_focus = players[(start_i + i) % players.size()]
		if has_node("camera"):
			var cam = $camera
			player_with_focus.input_enabled = true
			remove_child(cam)
			player_with_focus.add_child(cam)

func focus_all():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.input_enabled = true
	

func get_input_dir():
	if input_enabled:
		return Vector2(
			float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
			float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
		)
	else: 
		return Vector2.ZERO

func set_input_enabled(val):
	input_enabled = val
	emit_signal("input_enabled_changed", val)




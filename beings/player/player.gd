extends Dude
class_name Player

export var input_enabled := true

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
	var i = (players.find(self) + 1) % players.size()
	for player in players:
		player.input_enabled = false
	var player_with_focus = players[i]
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

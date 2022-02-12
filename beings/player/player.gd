extends Dude
class_name Player


func _input(event):
	if event.is_action_pressed("ui_accept"):
		jump = true
	if event.is_action_pressed("interact"):
		interact = true

func get_input_dir():
	return Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)

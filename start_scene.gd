extends Node2D


func _input(event):
	if event.is_action_pressed("ui_accept"):
		Signal.emit_signal("next_level")

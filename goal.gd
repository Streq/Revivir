extends Area2D
signal goal()



func _on_body_entered(body):
	Signal.emit_signal("next_level")

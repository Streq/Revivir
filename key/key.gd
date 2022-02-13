extends Node2D

var node_to_unlock = null



func _on_grab_area_body_entered(body):
	yield(get_tree(), "idle_frame")
	get_parent().remove_child(self)
	body.add_child(self)
	position = Vector2(0,-16)


func _on_unlock_area_body_entered(body):
	if body == node_to_unlock:
		body.queue_free()
		queue_free()

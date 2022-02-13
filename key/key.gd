extends Node2D

var node_to_unlock = null
var ignore = []


func _on_grab_area_body_entered(body):
	if ignore.find(body) != -1:
		return
	yield(get_tree(), "idle_frame")
	
	#make it so the former parent cant instantly regrab it
	var old_parent = get_parent()
	ignore.append(old_parent)
	old_parent.remove_child(self)
	body.add_child(self)
	position = Vector2(0,-16)
	yield(get_tree().create_timer(1.0),"timeout")
	ignore.erase(old_parent)


func _on_unlock_area_body_entered(body):
	if body == node_to_unlock:
		body.queue_free()
		queue_free()

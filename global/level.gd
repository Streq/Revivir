extends Node


export (Array, PackedScene) var levels
export var index = -1
var current = null
var go_to_next_level = false

func _ready():
	Signal.connect("next_level", self, "next_level")
	
func next_level():
	if !go_to_next_level:
		go_to_next_level = true
		index += 1
		if !current:
			current = get_tree().current_scene
		current.queue_free()
		current = levels[index].instance()
		yield(get_tree(), "idle_frame")
		go_to_next_level = false
		get_parent().call_deferred("add_child", current)
		
func _input(event):
	if event.is_action_pressed("restart"):
		index -= 1
		next_level()

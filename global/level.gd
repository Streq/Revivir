extends Node


export (Array, PackedScene) var levels
export var index = -1
var current = null
var go_to_next_level = false

func _ready():
	Signal.connect("next_level", self, "next_level")
	
func next_level(increment = 1):
	if !go_to_next_level:
		go_to_next_level = true
		index += increment
		if !current:
			current = get_tree().current_scene
		current.queue_free()
		current = levels[index].instance()
		yield(get_tree(), "idle_frame")
		go_to_next_level = false
		get_parent().call_deferred("add_child", current)
		
func _input(event):
	if event.is_action_pressed("restart"):
		if index != -1:
			index -= 1
			next_level()
		else:
			get_tree().reload_current_scene()
	if OS.is_debug_build():
		if event.is_action_pressed("next_level"):
			next_level()
		if event.is_action_pressed("prev_level"):
			next_level(-1)


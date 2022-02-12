extends Node2D


func _ready():
	Signal.emit_signal("next_level")

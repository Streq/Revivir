extends Node2D


func _ready():
	$key.modulate = modulate
	$terrain.modulate = modulate
	$key.node_to_unlock = $terrain

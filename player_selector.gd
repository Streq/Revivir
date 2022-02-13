extends Node2D

signal all_players_dead()
signal someone_died()


var alive := 0


func _ready():
	for child in get_children():
		child.connect("dead", self, "_on_player_dead")
		if child.alive:
			alive += 1

		



func _on_player_dead():
	alive -= 1
	if !alive:
		emit_signal("all_players_dead")
	emit_signal("someone_died")

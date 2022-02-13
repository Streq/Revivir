extends Node2D




func _on_players_someone_died():
	var cam:Camera2D = get_tree().get_nodes_in_group("camera")[0]
	if to_local(cam.global_position).x < 0:
		$left.visible = true
	else:
		$right.visible = true

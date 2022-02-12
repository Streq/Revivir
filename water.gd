extends Area2D

func _on_body_entered(body):
	if body.has_death("lava"):
		body.die(null)

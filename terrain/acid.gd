extends Area2D

func _on_body_entered(body):
	body.die(null)
	

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if !body.alive:
			body.velocity = lerp (body.velocity, Vector2.ZERO, 10*delta)
			body.velocity.y -= 500*delta
		elif body.has_death("lava"):
			body.die(null)

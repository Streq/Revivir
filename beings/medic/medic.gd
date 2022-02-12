extends Dude

onready var sight := $sight

func get_input_dir():
	
	var dirx := 0.0
	for body in sight.get_overlapping_bodies():
		if !body.alive and body.is_on_floor():
			dirx = sign(body.global_position.x-global_position.x)
			interact = true
			break
	return Vector2(
		dirx,
		0.0
	)

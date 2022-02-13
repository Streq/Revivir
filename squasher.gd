extends KinematicBody2D
var velocity := Vector2.ZERO
enum State{IDLE, SQUASHING}

export var squash_speed := 300.0
export var direction := Vector2.ZERO
var state = State.SQUASHING

func _physics_process(delta):
	match state:
		State.IDLE:
			pass
		State.SQUASHING:
			velocity = direction*squash_speed
			velocity = move_and_slide(velocity)
			if velocity == Vector2.ZERO:
				state = State.IDLE
				direction = -direction
	
	
	


func _on_squash_zone_body_entered(body):
	body.die("vertical_squash")


func _on_squash_sight_body_entered(body):
	if state == State.IDLE:
		state = State.SQUASHING

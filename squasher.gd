extends KinematicBody2D
var velocity := Vector2.ZERO
enum State{IDLE, SQUASHING}

export var squash_speed := 200.0
export var direction := Vector2.ZERO
var state = State.SQUASHING
onready var squash_sight = $squash_sight
onready var moving_squash_zone = $moving_squash_zone
onready var static_squash_zone = $static_squash_zone
func _ready():
	squash_sight.set_as_toplevel(true)
	static_squash_zone.set_as_toplevel(true)

func _physics_process(delta):
	match state:
		State.IDLE:
			for bod in squash_sight.get_overlapping_bodies():
				if bod.alive:
					state = State.SQUASHING
		State.SQUASHING:
			velocity = direction*squash_speed
			velocity = move_and_slide(velocity)
			if velocity == Vector2.ZERO:
				state = State.IDLE
				direction = -direction	



func _on_moving_squash_zone_body_entered(body):
	pass # Replace with function body.


func _on_static_squash_zone_body_entered(body):
	if moving_squash_zone.get_overlapping_bodies().find(body)!=-1:
		body.die("vertical_squash")
		direction = -direction

extends KinematicBody2D
class_name Dude
signal dead(who)
signal revived(who)

var velocity := Vector2.ZERO
var jump := false
var interact := false
export var alive := true
export (float, -1, 1, 2) var facing = 1.0
export var speed := 300.0
export var jump_speed := 200.0
export var gravity := 500.0
export var lerp_speed := 1.0
export var lerp_floor_idle := 8.0
export var lerp_air_idle := 1.0
export var has_focus := false
export var texture_long : Texture

onready var animation := $AnimationPlayer
onready var sprite := $pivot/Sprite
onready var pivot := $pivot
onready var interact_area = $interact_area
onready var interactuable_area = $interactuable_area
onready var standing_shape = $standing_shape
onready var knocked_shape = $knocked_shape
onready var label_revivir = $label_revivir
onready var particles_revive = $particles_revive

onready var deaths := []

func _ready():
	update_areas()
	pass
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += delta*gravity
	var show_revivir_label = false
	if alive:
		var dir = get_input_dir()
		
		if dir.x:
			velocity.x = lerp(velocity.x, speed*dir.x, lerp_speed*delta)
			if is_on_floor():
				animation.play("run")
			else:
				animation.play("air")
		elif is_on_floor():
			animation.play("stop")
			if abs(velocity.x)>10:
				animation.play("stop")
			else:
				animation.play("idle")
			velocity.x = lerp(velocity.x, 0, lerp_floor_idle*delta)
		else:
			animation.play("air")
			velocity.x = lerp(velocity.x, 0, lerp_air_idle*delta)
		if jump and is_on_floor():
			velocity.y -= jump_speed
		if dir.x:
			facing = dir.x
		
		if interact:
			for area in interact_area.get_overlapping_areas():
				if area.owner != self:
					area.owner.revive()
		
		pivot.scale.x = facing
		
		pass
	else:
		if is_on_floor():
			animation.play("knocked")
			velocity.x = 0.0
		else:
			animation.play("hit_on_air")
		for area in interactuable_area.get_overlapping_areas():
			if area.owner.is_in_group("player"):
				show_revivir_label = true
				break
	label_revivir.visible = show_revivir_label
	jump = false
	interact = false

func get_input_dir():
	return Vector2(0,0)

func die(cause = null):
	if deaths.find(cause) == -1:
		if cause:
			deaths.append(cause)
			match(cause):
				"lava":
					sprite.material = ShaderMaterial.new()
					sprite.material.shader = preload("res://assets/shader/red_dither.gdshader")
				"vertical_squash":
					yield(get_tree(),"idle_frame")
					sprite.texture = texture_long
					standing_shape.scale.x = 0.5
					standing_shape.scale.y = 2
					knocked_shape.scale.x = 2
					knocked_shape.position.y += 6
					

		if alive:
			emit_signal("dead", self)
			set_alive(false)
			velocity = Vector2(100.0 * -facing, -300.0)

func revive():
	set_alive(true)
	particles_revive.emitting = true
	emit_signal("revived", self)
	

func set_alive(val):
	alive = val
	call_deferred("update_areas")

func update_areas():
	interact_area.monitoring = alive
	interact_area.monitorable = alive
	interactuable_area.monitoring = !alive
	interactuable_area.monitorable = !alive
	standing_shape.disabled = !alive
	knocked_shape.disabled = alive


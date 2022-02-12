extends KinematicBody2D
class_name Dude
signal dead()
signal revived()

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
export var texture_long : Texture
export var texture_normal : Texture

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
		match(cause):
			"lava":
				set_lava(true)
			"vertical_squash":
				set_vertical_squash(true)
		if alive:
			emit_signal("dead")
			set_alive(false)

const NOT_FOUND = -1

func set_lava(val):
	var i = deaths.find("lava")
	if val:
		if i == NOT_FOUND:
			sprite.material = ShaderMaterial.new()
			sprite.material.shader = preload("res://assets/shader/red_dither.gdshader")
			deaths.append("lava")
			velocity = Vector2(100.0 * -facing, -300.0)
	else:
		if i != NOT_FOUND:
			sprite.material = null
			deaths.remove(i)

func set_vertical_squash(val):
	var i = deaths.find("vertical_squash")
	if val:
		if i == NOT_FOUND:
			sprite.texture = texture_long
			standing_shape.scale.x = 0.5
			standing_shape.scale.y = 2
			knocked_shape.scale.x = 2
			knocked_shape.position.y = 10.5
			deaths.append("vertical_squash")
	else:
		if i != NOT_FOUND:
			sprite.texture = texture_normal
			standing_shape.scale.x = 1
			standing_shape.scale.y = 1
			knocked_shape.scale.x = 1
			knocked_shape.position.y = 4.5
			deaths.remove(i)

func has_death(val):
	return deaths.find(val) != -1

func revive():
	set_alive(true)
	particles_revive.emitting = true
	emit_signal("revived")
	

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


extends CharacterBody2D
class_name Baloon

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _raycast = $RayCast2D
@onready var _target = get_node("../Player")

var smoke_scene = preload("res://smoke.tscn")
var direction = Vector2(0, 0)
var speed = 20.0
var damage_timer = Timer.new()
var dead_timer = Timer.new()
var balloon_life = Timer.new()
var dead = false

func _ready():
	_animated_sprite.play("drift")
	add_to_group("baloons")
	damage_timer.timeout.connect(damage_player)
	damage_timer.wait_time = 1.0
	add_child(damage_timer)
	dead_timer.timeout.connect(remove)
	dead_timer.wait_time = 1.0
	add_child(dead_timer)
	
	balloon_life = Timer.new()
	#balloon_life.timeout.connect(remove)
	balloon_life.timeout.connect(remove)
	balloon_life.wait_time = 2.0
	add_child(balloon_life)
	balloon_life.start()

func _get_chase_direction():
	var size = len(_target.trail)
	var trail_direction = _get_los(_target.trail[len(_target.trail)-1])
	if trail_direction != null:
		return trail_direction
	return direction

func _get_los(target_pos):
	_raycast.set_target_position(target_pos - global_position)
	_raycast.force_raycast_update()
	if !_raycast.is_colliding():
		return _raycast.target_position.normalized()
	return null
	
func _process(delta):
	var chase_direction = _get_chase_direction()
	if chase_direction != null:
		direction = chase_direction
		_animated_sprite.play("drift")

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func damage_player():
	get_node("../Player").laughter_meter += 50

func _on_area_2d_body_entered(body):
	if body.name == "Player" :
		damage_player()
		explode()

func _on_area_2d_body_exited(body):
	if body.name == "Player" :
		damage_timer.stop()

func explode():
	remove()

func remove():
	var smoke = smoke_scene.instantiate()
	smoke.position = position
	get_parent().add_child(smoke)
	queue_free()

extends CharacterBody2D
class_name Chicken

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _raycast = $RayCast2D
@onready var _target = get_node("../Player")

var smoke_scene = preload("res://smoke.tscn")
var feather_scene = preload("res://proj/feather.tscn")
var banana_scene = preload("res://banana.tscn")
var direction = Vector2(0, 0)
var speed = 35.0
var damage_timer = Timer.new()
var dead_timer = Timer.new()
var dead = false

var feather_timer = Timer.new()


func _ready():
	_animated_sprite.play("walk")
	add_to_group("enemies")
	damage_timer.timeout.connect(damage_player)
	damage_timer.wait_time = 1.0
	add_child(damage_timer)
	dead_timer.timeout.connect(remove)
	dead_timer.wait_time = 1
	add_child(dead_timer)
	
	feather_timer.timeout.connect(_feather_attack)
	feather_timer.wait_time = 1.0
	
	add_child(feather_timer)
	feather_timer.start()
	
func _feather_attack():
	var feather = feather_scene.instantiate()
	feather.position = position
	feather.velocity = direction * 1.5 * speed * 10
	get_parent().add_child(feather)
	feather_timer.start()
	

func _get_chase_direction():
	# chickens get spooked by cats, flee then despawn
	if get_node_or_null("../cat") != null:
		var cat_direction = _get_los($"../cat".global_position)
		if cat_direction != null:
			dead_timer.start()
			dead = true
			return cat_direction * -1

	var size = len(_target.trail)
	var trail_direction = null
	for n in range(size-1, -1, -1):
		trail_direction = _get_los(_target.trail[n])
		if trail_direction != null:
			return trail_direction
	return null

func _get_los(target_pos):
	_raycast.set_target_position(target_pos - global_position)
	_raycast.force_raycast_update()
	if !_raycast.is_colliding():
		return _raycast.target_position.normalized()
	return null
	
func _process(delta):
	if dead: return
	
	var chase_direction = _get_chase_direction()
	if chase_direction != null:
		direction = chase_direction
		_animated_sprite.rotation = atan2(direction.y, direction.x) + PI/2
		_animated_sprite.play("walk")
	else:
		direction = Vector2.ZERO
		_animated_sprite.play("idle")


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func damage_player():
	get_node("../Player").laughter_meter += 10

func _on_area_2d_body_entered(body):
	if body.name == "Player" :
		damage_player()
		damage_timer.start()

func _on_area_2d_body_exited(body):
	if body.name == "Player" :
		damage_timer.stop()

func die():
	if !dead:
		call_deferred("disable_collisions")
		dead_timer.start()
		dead = true

func disable_collisions():
	$CollisionShape2D.disabled = true

func remove():
	var smoke = smoke_scene.instantiate()
	smoke.position = position
	get_parent().add_child(smoke)
	queue_free()

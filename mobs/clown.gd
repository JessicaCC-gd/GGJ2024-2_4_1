extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
#var _raycast: RayCast2D
@onready var _raycast = $RayCast2D
@onready var _target = get_node("../Player")

var smoke_scene = preload("res://smoke.tscn")
var direction = Vector2(0, 0)
var speed = 70.0
var damage_timer = Timer.new()
var dead_timer = Timer.new()
var dead = false
var health = 1

func _ready():
	_animated_sprite.play("walk")
	add_to_group("enemies")
	damage_timer.timeout.connect(damage_player)
	damage_timer.wait_time = 1.0
	add_child(damage_timer)
	dead_timer.timeout.connect(remove)
	dead_timer.wait_time = 1.0
	add_child(dead_timer)

func _get_direction():
	if get_node_or_null("../cat") != null:
		return (global_position - $"../cat".global_position).normalized()
	
	return (get_node("../Player").global_position - global_position).normalized()
	
func _process(delta):
	$AnimatedSprite2D.modulate = Color(1,1,1)
	if !dead:
		direction = _get_direction()
		_animated_sprite.rotation = atan2(direction.y, direction.x) + PI/2
		_animated_sprite.play("walk")
	else:
		direction = Vector2.ZERO
		_animated_sprite.rotation += 2 * PI * delta
		_animated_sprite.play("stun")

func _physics_process(delta):
	if !dead:
		velocity = direction * speed
		move_and_slide()

func damage_player():
	get_node("../Player").laughter_meter += 20

func _on_area_2d_body_entered(body):
	if body.name == "Player" :
		damage_player()
		damage_timer.start()

func _on_area_2d_body_exited(body):
	if body.name == "Player" :
		damage_timer.stop()

# more like damage() now
func die():
	$AnimatedSprite2D.modulate = Color.RED
	health=health-1
	if health <= 0:
		if !dead:
			call_deferred("disable_collisions")
			$AudioStreamPlayer2D.play()
			dead_timer.start()
			dead = true

func disable_collisions():
	$CollisionShape2D.disabled = true

func remove():
	var smoke = smoke_scene.instantiate()
	smoke.position = position
	get_parent().add_child(smoke)
	queue_free()

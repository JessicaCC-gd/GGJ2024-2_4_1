extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _area_2d = $Area2D


var lifetime = Timer.new()

func _ready():
	_animated_sprite.play("default")
	lifetime.timeout.connect(_despawn)
	lifetime.wait_time = 2.0
	add_child(lifetime)
	lifetime.start()
	
func _despawn():
	queue_free()
	
func _process(delta):
	if velocity.length() > 20:
		_animated_sprite.rotation += delta * 2 * PI
	var player = get_node_or_null('../Player')
	var distance_to_player
	if player != null:
		distance_to_player = (player.global_position - global_position).length()
	else: distance_to_player = 9999
	if distance_to_player > 1000:
		queue_free()
	
func _physics_process(delta):
	velocity *= 0.95
	move_and_slide()

func _on_area_2d_body_entered(body):
	if (body.is_in_group("players")):
		body.damage(10)
		queue_free()

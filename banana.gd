extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _area_2d = $Area2D

func _ready():
	_animated_sprite.play("default")
	
func _process(delta):
	if velocity.length() > 20:
		_animated_sprite.rotation += delta * 2 * PI
	var distance_to_player = (get_node('../Player').global_position - global_position).length()
	if distance_to_player > 1000:
		queue_free()
	
func _physics_process(delta):
	velocity *= 0.95
	move_and_slide()

func _on_area_2d_body_entered(body):
	if (body.is_in_group("enemies")):
		body.die()
		queue_free()

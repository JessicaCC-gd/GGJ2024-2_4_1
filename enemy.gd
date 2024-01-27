extends CharacterBody2D

@onready var _nav_agent = $NavigationAgent2D
@onready var _animated_sprite = $AnimatedSprite2D

var direction = Vector2(0, 0)
var speed = 30.0

func _ready():
	pass

func _physics_process(delta):
	direction = (get_node("../Player").global_position - self.global_position).normalized()
	_animated_sprite.rotation = atan2(direction.y, direction.x) + PI/2
	velocity = direction * speed
	move_and_slide()

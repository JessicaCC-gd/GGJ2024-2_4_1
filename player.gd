extends CharacterBody2D


@onready var _animated_sprite = $AnimatedSprite2D
var speed = 200

func _physics_process(delta):
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 270
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 90
		input_dir.x += 1
	if Input.is_action_pressed("move_up"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 0
		input_dir.y -= 1
	if Input.is_action_pressed("move_down"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 180
		input_dir.y += 1

	velocity = input_dir.normalized() * speed
	if input_dir == Vector2(0,0):
		_animated_sprite.play("idle")

	move_and_collide(velocity * delta)

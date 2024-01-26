extends CharacterBody2D


@onready var _animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var vel : Vector2 = Vector2()
var moveSpeed: float = 2.0 # n meters per second

func _physics_process(delta):
	var input = Vector2()
	if Input.is_action_pressed("move_up") :
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 0
		input.y -= 1
		input.x = 0
	elif Input.is_action_pressed("move_down"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 180
		input.y += 1
		input.x = 0
	elif Input.is_action_pressed("move_left"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 270
		input.x -= 1
		input.y = 0
	elif Input.is_action_pressed("move_right"):
		_animated_sprite.play("walk")
		_animated_sprite.rotation_degrees = 90
		input.x += 1
		input.y = 0
	else:
		_animated_sprite.play("idle")

	var dir = (transform.y * input.y + transform.x * input.x)
	vel.x = dir.x * moveSpeed
	vel.y = dir.y * moveSpeed
	var collision = move_and_collide(vel)

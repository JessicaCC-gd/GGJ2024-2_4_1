extends CharacterBody2D


@onready var _animated_sprite = $AnimatedSprite2D
var speed = 200
var current_damage = 0
var laughter_meter = 0
var damage_timer = Timer.new()
var scent_timer = Timer.new()
var scent_trail = []

func drop_scent():
  scent_trail.push_front(scent)
	

func _ready():
	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(damage)
	scent_timer.wait_time = 1.0
	scent_timer.timeout.connect()

func _physics_process(delta):
#	damage()
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1	
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1

	player_animation(input_dir)
	velocity = input_dir.normalized() * speed
	move_and_collide(velocity * delta)


func player_animation(input_dir):
	if input_dir.x != 0 || input_dir.y != 0:
		_animated_sprite.play("walk")
	else:
		_animated_sprite.play("idle")
	if input_dir.x > 0 && input_dir.y == 0:
		_animated_sprite.rotation_degrees = 90
	elif input_dir.x > 0 && input_dir.y > 0:
		_animated_sprite.rotation_degrees = 135
	elif input_dir.x > 0 && input_dir.y < 0:
		_animated_sprite.rotation_degrees = 45
	elif input_dir.x < 0 && input_dir.y == 0:
		_animated_sprite.rotation_degrees = -90
	elif input_dir.x < 0 && input_dir.y > 0:
		_animated_sprite.rotation_degrees = -135
	elif input_dir.x < 0 && input_dir.y < 0:
		_animated_sprite.rotation_degrees = -45
	elif input_dir.x == 0 && input_dir.y < 0:
		_animated_sprite.rotation_degrees = 0
	elif input_dir.x == 0 && input_dir.y > 0:
		_animated_sprite.rotation_degrees = 180

func damage():
	laughter_meter += current_damage

func _on_area_2d_body_entered(body):
	if current_damage == 0:
		damage_timer.start
	if body.name == "enemy":
		current_damage += 1

func _on_area_2d_body_exited(body):
	if body.name == "enemy":
		current_damage -= 1

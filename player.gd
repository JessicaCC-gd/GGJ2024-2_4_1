extends CharacterBody2D


@onready var _animated_sprite = $AnimatedSprite2D

var speed = 150.0
var force = 100.0
var current_damage = 0
var laughter_meter = 0
var laughter_max = 100
var trail = []
var max_trail_count = 5
var scent_timer = Timer.new()
var cat_scene = preload("res://cat.tscn")
	
func drop_scent():
	if len(trail) >= max_trail_count:
		trail.pop_front()
	trail.push_back(global_position)


func _ready():
	scent_timer.wait_time = 1.0
	scent_timer.timeout.connect(drop_scent)
	add_child(scent_timer)
	scent_timer.start()

func _physics_process(delta):
	if laughter_meter == laughter_max:
		get_tree().change_scene_to_file("res://game_over.tscn")
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

	if move_and_slide():
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() is CharacterBody2D:
				var dir = col.get_collider().global_position.direction_to(self.global_position)
				col.get_collider().position -= dir * force * delta
				
	if Input.is_action_just_pressed("action_1"):
		var cat = cat_scene.instantiate()
		cat.position = position
		get_parent().add_child(cat)


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

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
var banana_scene = preload("res://banana.tscn")
var no_cats = 5
var no_tea = 3
var cat_cooldown_active = false
var cat_cooldown_timer = Timer.new()
var dash_cooldown_timer = Timer.new()
var dash_duration_timer = Timer.new()
var no_banana = 10
var dash = false
@export var dash_avaliable = true

const BOOST = 2
	
func drop_scent():
	if len(trail) >= max_trail_count:
		trail.pop_front()
	trail.push_back(global_position)

func _ready():
	cat_cooldown_timer.wait_time = 10.0
	cat_cooldown_timer.one_shot = true
	cat_cooldown_timer.timeout.connect(reactivate_cat)
	add_child(cat_cooldown_timer)
	scent_timer.wait_time = 1.0
	scent_timer.timeout.connect(drop_scent)
	add_child(scent_timer)
	scent_timer.start()
	dash_cooldown_timer.timeout.connect(reactivate_dash)
	dash_cooldown_timer.wait_time = 10.0
	add_child(dash_cooldown_timer)
	dash_duration_timer.wait_time = 2.0
	dash_duration_timer.timeout.connect(disable_dash)
	add_child(dash_duration_timer)

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
	var boost = 1
	if dash == true:
		boost=BOOST
	velocity = input_dir.normalized() * speed * boost

	if move_and_slide():
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() is CharacterBody2D:
				var dir = col.get_collider().global_position.direction_to(self.global_position)
				col.get_collider().position -= dir * force * delta
				
	if Input.is_action_just_pressed("action_1") && no_cats > 0 && cat_cooldown_active == false:
		var cat = cat_scene.instantiate()
		cat.position = position
		no_cats -= 1
		get_parent().add_child(cat)
		cat_cooldown_active = true
		cat_cooldown_timer.start()
	if Input.is_action_just_pressed("action_2") && no_tea > 0 && laughter_meter > 0:
		laughter_meter = max(laughter_meter - 10, 0)
		no_tea -= 1
	if Input.is_action_just_pressed("action_3") && no_banana > 0:
		var banana = banana_scene.instantiate()
		banana.position = position
		no_banana -= 1
		get_parent().add_child(banana)
	if Input.is_action_just_pressed("action_4") && dash_avaliable:
		dash_cooldown_timer.start()
		dash_duration_timer.start()
		dash = true
		dash_avaliable = false

func reactivate_cat():
	cat_cooldown_active = false
	
func reactivate_dash():
	dash_avaliable = true
	dash_cooldown_timer.stop()
	
func disable_dash():
	dash = false

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

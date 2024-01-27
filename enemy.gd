extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
#var _raycast: RayCast2D
@onready var _raycast = $RayCast2D
@onready var _target = get_node("../Player")

var direction = Vector2(0, 0)
var speed = 30.0
var damage_timer = Timer.new()

func _ready():
	add_to_group("enemies")
	damage_timer.timeout.connect(damage_player)
	damage_timer.wait_time = 1.0
	add_child(damage_timer)
	_animated_sprite.play("walk")

func _chase():
	_raycast.set_target_position(_target.global_position - global_position)
	_raycast.force_raycast_update()
	if !_raycast.is_colliding():
		direction = _raycast.target_position.normalized()
		#print("Enemy can see player")
	else:
		direction = Vector2(0, 0)
	
func _physics_process(delta):
	#direction = (get_node("../Player").global_position - self.global_position).normalized()
	_chase()
	_animated_sprite.rotation = atan2(direction.y, direction.x) + PI/2
	velocity = direction * speed
	move_and_slide()

func damage_player():
	get_node("../Player").laughter_meter += 1

func _on_area_2d_body_entered(body):
	if body.name == "Player" :
		print("wooo")
		damage_player()
		damage_timer.start()

func _on_area_2d_body_exited(body):
	if body== $"../Player":
		damage_timer.paused = true

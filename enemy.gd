extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _nav_agent = $NavigationAgent2D
@onready var _animated_sprite = $AnimatedSprite2D
func _ready():
	_nav_agent.set_target_position(get_node("../Player").position)
	
		
func _physics_process(delta):
	_animated_sprite.play("idle")
	if not $NavigationAgent2D.is_navigation_finished():
		var movement_delta = SPEED * delta
		var current_agent_position = global_position
		var next_path_position = _nav_agent.get_next_path_position()
		velocity = (next_path_position - current_agent_position).normalized() * movement_delta
		#move_and_slide()

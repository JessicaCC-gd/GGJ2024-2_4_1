extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.

@onready var _nav_agent = $NavigationAgent2D
@onready var _animated_sprite = $AnimatedSprite2D

var direction = Vector2(0, 0)
var speed = 3000.0

func _ready():
	direction = (get_node("../Player").global_position - self.position).normalized()

func _physics_process(delta):
	direction = (get_node("../Player").global_position - self.position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

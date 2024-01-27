extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("default")

func _on_animated_sprite_2d_animation_finished():
	get_node(".").queue_free()

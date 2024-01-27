extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _area_2d = $Area2D

var smoke_scene = preload("res://smoke.tscn")
var despawn_timer

func _ready():
	_animated_sprite.play("default")
	despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.wait_time = 2.0
	despawn_timer.timeout.connect(_despawn)
	despawn_timer.start()
	
func _despawn():
	var smoke = smoke_scene.instantiate()
	smoke.position = position
	get_parent().add_child(smoke)
	queue_free()


func _on_area_2d_area_entered(area):
	#if area.get_parent().name == "enemy":
	area.get_parent().die()

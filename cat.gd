extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D

var smoke_scene = preload("res://smoke.tscn")
var despawn_timer


func _ready():
	_animated_sprite.play("default")
	despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.wait_time = 2.0
	despawn_timer.timeout.connect(_despawn)
	despawn_timer.start()
	$AudioStreamPlayer2D.stream = load("res://assets/sound/cat-meow-6226.mp3")
	$AudioStreamPlayer2D.play()
	SignalHandler.aw.emit()
	
func _despawn():
	var smoke = smoke_scene.instantiate()
	smoke.position = position
	get_parent().add_child(smoke)
	SignalHandler.angry.emit()
	queue_free()

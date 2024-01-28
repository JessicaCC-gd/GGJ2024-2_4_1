extends Node2D


var rng = RandomNumberGenerator.new()
var particle_scene = preload("res://emotion_particle.tscn")
var lifetime_timer = Timer.new()
var particle_spawn_timer = Timer.new()

func _ready():
	lifetime_timer.wait_time = 2.5
	lifetime_timer.timeout.connect(queue_free)	
	add_child(lifetime_timer)
	lifetime_timer.start()
	particle_spawn_timer.wait_time = 0.01
	particle_spawn_timer.timeout.connect(spawn_particle)
	add_child(particle_spawn_timer)
	particle_spawn_timer.start()

func spawn_particle():
	var particle = particle_scene.instantiate()
	particle.position = global_position + Vector2(rng.randf_range(0, 100), 0).rotated(rng.randf_range(-PI, PI))
	get_parent().add_child(particle)


func _on_area_2d_body_entered(body):
	if (body.is_in_group("enemies") && !body.dead):
		body.die()

extends Node2D

const MAX_ENEMIES = 100
const SPAWN_DISTANCE = 300

var enemy_spawn_timer
var enemy_scene = preload("res://enemy.tscn")
var rng = RandomNumberGenerator.new()

@onready var player = $TileMap/Player


func _ready():
	SignalHandler.aw.connect(crowd_aw)
	SignalHandler.angry.connect(crowd_angry)
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.wait_time = 0.25
	enemy_spawn_timer.one_shot = false
	enemy_spawn_timer.start()
	enemy_spawn_timer.connect("timeout", _on_enemy_timer_timeout)


func _process(delta):
	pass
	
	
func _on_enemy_timer_timeout() -> void:
	var enemy_count = len(get_tree().get_nodes_in_group("enemies"))
	if enemy_count < MAX_ENEMIES:
		var enemy = enemy_scene.instantiate()
		enemy.position = player.position + Vector2(SPAWN_DISTANCE, 0).rotated(rng.randf_range(-PI, PI))
		get_node("TileMap").add_child(enemy)	
		
func crowd_aw():
	$AudioStreamPlayer.stream = load("res://assets/sound/crowdyayapplause25ppllong-6948.mp3")
	$AudioStreamPlayer.volume_db = 3
	$AudioStreamPlayer.play()
	
func crowd_angry():
	$AudioStreamPlayer.stream = load("res://assets/sound/angry-mob-loop-6847.mp3")
	$AudioStreamPlayer.volume_db = -5
	$AudioStreamPlayer.play()

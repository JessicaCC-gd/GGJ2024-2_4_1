extends Node2D

const MAX_ENEMIES = 10
const SPAWN_DISTANCE = 400

var enemy_spawn_timer
var enemy_scene = preload("res://enemy.tscn")
var rng = RandomNumberGenerator.new()

@onready var player = $TileMap/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.wait_time = 1.0
	enemy_spawn_timer.one_shot = false
	enemy_spawn_timer.start()
	enemy_spawn_timer.connect("timeout", self._on_enemy_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_enemy_timer_timeout() -> void:
	var enemy_count = len(get_tree().get_nodes_in_group("enemies"))
	if enemy_count < MAX_ENEMIES:
		var enemy = enemy_scene.instantiate()
		enemy.position = player.position + Vector2(SPAWN_DISTANCE, 0).rotated(rng.randf_range(-PI, PI))		
		get_node("TileMap").add_child(enemy)

extends Node2D

const MAX_ENEMIES = 100
const SPAWN_DISTANCE = 300
const MAX_PU_BANANAS = 20
const MAX_PU_TEA = 10
const MAX_PU_CATS = 10

var enemy_spawn_timer
var enemy_scene = preload("res://enemy.tscn")
var clown_scene = preload("res://clown.tscn")
var banana_spawn_timer = Timer.new()
var tea_spawn_timer = Timer.new()
var cat_spawn_timer = Timer.new()
var pu_banana_scene = preload("res://pu_banana.tscn")
var pu_cat_scene = preload("res://pu_cat.tscn")
var pu_tea_scene = preload("res://pu_tea.tscn")
var rng = RandomNumberGenerator.new()

@onready var player = $TileMap/Player


func _ready():
	set_timers()
	SignalHandler.aw.connect(crowd_aw)
	SignalHandler.angry.connect(crowd_angry)
	enemy_spawn_timer.start()
	banana_spawn_timer.start()
	cat_spawn_timer.start()
	tea_spawn_timer.start()


func set_timers():
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	add_child(banana_spawn_timer)
	add_child(cat_spawn_timer)
	add_child(tea_spawn_timer)
	tea_spawn_timer.wait_time = 1.0
	cat_spawn_timer.wait_time = 1.0
	banana_spawn_timer.wait_time = 1.0
	enemy_spawn_timer.wait_time = 1.0
	enemy_spawn_timer.one_shot = false
	banana_spawn_timer.connect("timeout", _on_banana_timer_timeout)
	cat_spawn_timer.connect("timeout", _on_cat_timer_timeout)
	tea_spawn_timer.connect("timeout", _on_tea_timer_timeout)
	enemy_spawn_timer.connect("timeout", _on_enemy_timer_timeout)

func _process(delta):
	pass
	
func _on_cat_timer_timeout():
	var cat_count = len(get_tree().get_nodes_in_group("cat"))
	if cat_count < MAX_PU_CATS:
		var pu_cat = pu_cat_scene.instantiate()
		pu_cat.position = player.position + Vector2(SPAWN_DISTANCE, 0).rotated(rng.randf_range(-PI, PI))
		get_node("TileMap").add_child(pu_cat)
	
func _on_banana_timer_timeout():
	var banana_count = len(get_tree().get_nodes_in_group("bananas"))
	if banana_count < MAX_PU_BANANAS:
		var pu_banana = pu_banana_scene.instantiate()
		pu_banana.position = player.position + Vector2(SPAWN_DISTANCE, 0).rotated(rng.randf_range(-PI, PI))
		get_node("TileMap").add_child(pu_banana)

func _on_tea_timer_timeout():
	var tea_count = len(get_tree().get_nodes_in_group("tea"))
	if tea_count < MAX_PU_TEA:
		var pu_tea = pu_tea_scene.instantiate()
		pu_tea.position = player.position + Vector2(SPAWN_DISTANCE, 0).rotated(rng.randf_range(-PI, PI))
		get_node("TileMap").add_child(pu_tea)
	
func _on_enemy_timer_timeout() -> void:
	var enemy_count = len(get_tree().get_nodes_in_group("enemies"))
	if enemy_count < MAX_ENEMIES:
		var enemy
		if randf() < 0.9:
			enemy = enemy_scene.instantiate()
		else:
			enemy = clown_scene.instantiate()
			
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

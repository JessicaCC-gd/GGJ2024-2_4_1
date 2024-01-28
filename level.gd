extends Node2D

const MAX_ENEMIES = 200
const SPAWN_DISTANCE = 300
const MAX_PU_BANANAS = 200
const MAX_PU_TEA = 20
const MAX_PU_CATS = 10
const MAX_PU_FROWN = 20

var enemy_spawn_timer
var enemy_scene = preload("res://mobs/enemy.tscn")
var clown_scene = preload("res://mobs/clown.tscn")
var baloon_scene = preload("res://mobs/baloon.tscn")
var chicken_scene = preload("res://mobs/chicken.tscn")
var banana_spawn_timer = Timer.new()
var tea_spawn_timer = Timer.new()
var cat_spawn_timer = Timer.new()
var frown_spawn_timer = Timer.new()
var pu_banana_scene = preload("res://pu_banana.tscn")
var pu_cat_scene = preload("res://pu_cat.tscn")
var pu_tea_scene = preload("res://pu_tea.tscn")
var pu_frown_scene = preload("res://pu_frown.tscn")
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
	frown_spawn_timer.start()


func set_timers():
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	add_child(banana_spawn_timer)
	add_child(cat_spawn_timer)
	add_child(tea_spawn_timer)
	add_child(frown_spawn_timer)
	tea_spawn_timer.wait_time = 1.0
	cat_spawn_timer.wait_time = 4.0
	banana_spawn_timer.wait_time = 0.5
	enemy_spawn_timer.wait_time = 0.3
	frown_spawn_timer.wait_time = 2.0
	enemy_spawn_timer.one_shot = false
	banana_spawn_timer.connect("timeout", _on_banana_timer_timeout)
	cat_spawn_timer.connect("timeout", _on_cat_timer_timeout)
	tea_spawn_timer.connect("timeout", _on_tea_timer_timeout)
	frown_spawn_timer.connect("timeout", _on_frown_timer_timeout)
	enemy_spawn_timer.connect("timeout", _on_enemy_timer_timeout)

func _process(delta):
	pass
	
func _on_cat_timer_timeout():
	var pos : Vector2
	var cat_count = len(get_tree().get_nodes_in_group("cat"))
	if cat_count < MAX_PU_CATS:
		var pu_cat = pu_cat_scene.instantiate()
		pos.y = randi_range(32, ($TileMap.get_used_rect().size.y - 3) * $TileMap.cell_quadrant_size)
		pos.x = randi_range(32, ($TileMap.get_used_rect().size.x - 1) * $TileMap.cell_quadrant_size)
		pu_cat.position = pos
		get_node("TileMap").add_child(pu_cat)
	
func _on_banana_timer_timeout():
	var pos : Vector2
	var banana_count = len(get_tree().get_nodes_in_group("bananas"))
	if banana_count < MAX_PU_BANANAS:
		var pu_banana = pu_banana_scene.instantiate()
		pos.y = randi_range(32, ($TileMap.get_used_rect().size.y - 3) * $TileMap.cell_quadrant_size)
		pos.x = randi_range(32, ($TileMap.get_used_rect().size.x - 1) * $TileMap.cell_quadrant_size)
		pu_banana.position = pos
		get_node("TileMap").add_child(pu_banana)

func _on_tea_timer_timeout():
	var pos : Vector2
	var tea_count = len(get_tree().get_nodes_in_group("tea"))
	if tea_count < MAX_PU_TEA:
		var pu_tea = pu_tea_scene.instantiate()
		pu_tea.position = pos
		get_node("TileMap").add_child(pu_tea)
		
func _on_frown_timer_timeout():
	var pos : Vector2
	var frown_count = len(get_tree().get_nodes_in_group("frown"))
	if frown_count < MAX_PU_FROWN:
		var pu_frown = pu_frown_scene.instantiate()
		pos.y = randi_range(32, ($TileMap.get_used_rect().size.y - 3) * $TileMap.cell_quadrant_size)
		pos.x = randi_range(32, ($TileMap.get_used_rect().size.x - 1) * $TileMap.cell_quadrant_size)
		pu_frown.position = pos
		get_node("TileMap").add_child(pu_frown)

	
func _on_enemy_timer_timeout() -> void:
	var pos : Vector2
	var enemy_count = len(get_tree().get_nodes_in_group("enemies"))
	if enemy_count < MAX_ENEMIES:
		var enemy
		var r = randf()
		if r < 0.40:
			enemy = enemy_scene.instantiate()
		elif r < 0.80:
			enemy = chicken_scene.instantiate()
		elif r < 0.90:
			enemy = baloon_scene.instantiate()
		else:
			enemy = clown_scene.instantiate()
		
		while true:
			pos.y = randi_range(32, ($TileMap.get_used_rect().size.y - 3) * $TileMap.cell_quadrant_size)
			pos.x = randi_range(32, ($TileMap.get_used_rect().size.x - 1) * $TileMap.cell_quadrant_size)
			var distance = pos.distance_to(player.position)
			if (distance > 200 && distance < 700):
				break
		if enemy != null: enemy.position = pos
		get_node("TileMap").add_child(enemy)
		
func crowd_aw():
	$AudioStreamPlayer.stream = load("res://assets/sound/crowdyayapplause25ppllong-6948.mp3")
	$AudioStreamPlayer.volume_db = 3
	$AudioStreamPlayer.play()
	
func crowd_angry():
	$AudioStreamPlayer.stream = load("res://assets/sound/angry-mob-loop-6847.mp3")
	$AudioStreamPlayer.volume_db = -5
	$AudioStreamPlayer.play()

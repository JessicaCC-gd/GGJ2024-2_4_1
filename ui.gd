extends CanvasLayer

@onready var player = $"../TileMap/Player"
@onready var _laugh_meter = $laughter_meter
@onready var emotion = $Emotion

func _ready():
	$HUD/icon_cat/cat_cooldown.max_value = $"../TileMap/Player".cat_cooldown
	$HUD/icon_dash/dash_cooldown.max_value = $"../TileMap/Player".dash_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/icon_cat/cat_cooldown.visible = $"../TileMap/Player".cat_cooldown_active
	$HUD/icon_dash/dash_cooldown.visible = !$"../TileMap/Player".dash_avaliable
	$label_1.set_text(str(player.no_cats))
	$HUD/icon_cat/cat_cooldown.value = $"../TileMap/Player".cat_cooldown_timer.time_left
	$HUD/icon_dash/dash_cooldown.value = $"../TileMap/Player".dash_cooldown_timer.time_left
	$label_2.set_text(str(player.no_tea))
	$label_3.set_text(str(player.no_banana))
	$label_5.set_text(str(player.no_frowns))
	
	if _laugh_meter.value < 20:
		emotion.frame = 0
	if _laugh_meter.value >= 20 && _laugh_meter.value < 40:
		emotion.frame = 1
	if _laugh_meter.value >= 40 && _laugh_meter.value < 60:
		emotion.frame = 2
	if _laugh_meter.value >= 60 && _laugh_meter.value < 80:
		emotion.frame = 3
	if _laugh_meter.value >=80 && _laugh_meter.value < 100:
		emotion.frame = 4

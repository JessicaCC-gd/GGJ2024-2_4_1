extends CanvasLayer

@onready var player = $"../TileMap/Player"
@onready var _laugh_meter = $laughter_meter
@onready var emotion = $Emotion

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$label_1.set_text(str(player.no_cats))
	$label_2.set_text(str(player.no_tea))
	$label_4.set_text(str(floor(player.dash_cooldown_timer.time_left)))
	$label_3.set_text(str(player.no_banana))
	
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

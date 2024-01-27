extends CanvasLayer

@onready var player = $"../TileMap/Player"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$label_1.set_text(str(player.no_cats))
	$label_2.set_text(str(player.no_tea))
	$label_4.set_text(str(floor(player.dash_cooldown_timer.time_left)))

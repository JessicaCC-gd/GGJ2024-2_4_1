extends Camera2D

var tilemap : TileMap
# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_node("../..")
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.cell_quadrant_size
	var map_size_pixels = map_rect.size * tile_size
	limit_right = map_size_pixels.x
	limit_bottom = map_size_pixels.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("frown")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		body.no_frowns += 1
		queue_free()

extends Node2D

var lifetime_timer = Timer.new()

func _ready():
	modulate.a = 0.3
	lifetime_timer.wait_time = 1.0
	lifetime_timer.timeout.connect(queue_free)	
	add_child(lifetime_timer)
	lifetime_timer.start()
	

func _process(delta):
	position.y -= 10 * delta
	pass


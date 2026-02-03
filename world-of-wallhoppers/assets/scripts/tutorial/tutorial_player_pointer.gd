extends Sprite2D

var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	await get_tree().create_timer(2.0).timeout
	timer.start(1.0)
	await timer.timeout
	queue_free()

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		modulate.a = timer.time_left / timer.wait_time

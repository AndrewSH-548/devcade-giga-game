class_name ElectricField
extends NinePatchRect

@onready var slow_area: Area2D = $SlowArea
@onready var slow_shape: CollisionShape2D = $SlowArea/SlowShape
@onready var animation_timer: Timer = $AnimationTimer

func update_sizes() -> void:
	var rect: RectangleShape2D = slow_shape.shape
	rect.size = size
	slow_shape.position = rect.size / 2.0

func _physics_process(_delta: float) -> void:
	update_sizes()
	for body in slow_area.get_overlapping_bodies():
		if body is not Player:
			return
		var player: Player = body as Player
		player.physics_multiplier = 0.5

func next_frame() -> void:
	region_rect.position.x += region_rect.size.x
	region_rect.position.x = fmod(region_rect.position.x, texture.get_width())

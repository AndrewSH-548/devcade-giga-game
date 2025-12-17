## A projectile that will remove itself in a given time in seconds, (default of 3 seconds)
extends CharacterBody2D

@export var bullet_lifespan = 3; ## the lifespan of the bullet in seconds.

func _ready() -> void:
	await get_tree().create_timer(bullet_lifespan).timeout; # removes bullet after (bullet_life_span) seconds
	self.queue_free();
	
func _process(_delta: float) -> void:
	move_and_slide();

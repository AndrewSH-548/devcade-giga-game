## A projectile that will remove itself in a given time in seconds, (default of 3 seconds)
extends CharacterBody2D

@export var bullet_lifespan = 3; ## the lifespan of the bullet in seconds.
@export var has_gravity = false; ## if true, then the bullet will fall with gravity, otherwise it will travel linearlly. (false by default)
@export var gravity = 9.8; ## the force of gravity on the bullet, (9.8 by default)

func _ready() -> void:
	await get_tree().create_timer(bullet_lifespan).timeout # removes bullet after (bullet_life_span) seconds
	self.queue_free()
	
func _physics_process(delta: float) -> void:
	if(has_gravity): # fall downwards with gravity
		velocity.y += gravity * delta * 60.0
	var collison: KinematicCollision2D = move_and_collide(velocity * delta)
	if collison != null:
		destory()

func enable_gravity(f_gravity: float = 9.8): ## enables gravity and sets it to the specified value (9.8 by default)
	has_gravity = true;
	self.gravity = f_gravity;

func destory() -> void:
	queue_free()

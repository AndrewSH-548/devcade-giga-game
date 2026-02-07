class_name SpikeyPoly
extends Node2D

@onready var ray_front: RayCast2D = $RayFront
@onready var ray_back: RayCast2D = $RayBack
@onready var ray_wall: RayCast2D = $RayWall
@onready var sprite: AnimatedSprite2D = $Sprite

enum Direction {
	RIGHT,
	LEFT,
}

enum {
	MOVING,
	OUTER_CORNER,
	INNER_CORNER,
}

var direction: Direction = Direction.RIGHT
var direction_number: int:
	get():
		if direction == Direction.RIGHT: return 1
		return -1
var speed: float = 64.0
var rotate_speed: float = 12.0
var state: int = MOVING

func _ready() -> void:
	setup_for_direction(direction)

func setup_for_direction(_direction: Direction) -> void:
	direction = _direction
	if direction == Direction.LEFT:
		sprite.flip_h = false
		ray_front.position = Vector2(-13, 0)
		ray_wall.target_position.x *= -1
	ray_back.force_raycast_update()
	ray_front.force_raycast_update()
	ray_wall.force_raycast_update()

func _physics_process(delta: float) -> void:
	match state:
		MOVING:
			process_move_forward(delta)
		OUTER_CORNER:
			process_outer_corner(delta)

func process_outer_corner(delta: float) -> void:
	var goal: float = wrapf(rotation + rotate_speed * delta * direction_number, 0.0, TAU)
	var iterations: int = 0
	while rotation != goal:
		iterations += 1
		if iterations > 100:
			break
		rotation = rotate_toward(rotation, goal, PI / 12)
		if ray_front.is_colliding():
			rotation = snappedf(rotation, PI / 2)
			state = MOVING
			break

func process_move_forward(delta: float) -> void:
	var goal: Vector2 = global_position + Vector2.from_angle(rotation) * speed * delta * direction_number
	var iterations: int = 0
	while global_position != goal:
		iterations += 1
		if iterations > speed:
			break
		global_position = global_position.move_toward(goal, 0.5)
		if is_on_wall():
			global_position += (Vector2(1 * direction_number, -1) * 16).rotated(rotation)
			rotation -= PI / 2 * direction_number
			break
		if is_on_edge():
			state = OUTER_CORNER
			break

func is_on_edge() -> bool:
	return not ray_front.is_colliding() and not ray_back.is_colliding()

func is_on_wall() -> bool:
	return ray_wall.is_colliding()

func delete_poly() -> void:
	queue_free()

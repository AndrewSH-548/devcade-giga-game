@tool
extends CharacterBody2D
class_name FallenRock

var gravity: float = 128.0
var max_fall_speed: float = 256.0
var air_decceleration: float = 64.0

@export var size: Vector2i = Vector2i.ONE:
	set(new):
		size = new
		size = size.clamp(Vector2i.ONE, Vector2i.MAX)
		if texture_rect != null and up != null:
			set_size(new, true)

@onready var up: CollisionShape2D = $Up
@onready var right: CollisionShape2D = $Right
@onready var left: CollisionShape2D = $Left

@onready var texture_rect: NinePatchRect = $TextureRect

func _ready() -> void:
	up.shape = up.shape.duplicate()
	right.shape = right.shape.duplicate()
	left.shape = left.shape.duplicate()
	velocity.y = 256.0
	set_size(size)

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint(): return
	set_size(size)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	velocity.y += gravity * delta
	velocity.y = clampf(velocity.y, -INF, max_fall_speed)
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, air_decceleration * delta)
	move_and_slide()

func set_size(new_size: Vector2i, skip: bool = false):
	if not skip:
		size = new_size
	texture_rect.size = new_size * 32.0
	texture_rect.position = Vector2(-size.x / 2.0 * 32.0, -size.y * 32.0 / 2.0)
	up.shape.size = new_size * 32.0
	up.position.y = -new_size.y / 2.0
	right.shape.size = Vector2(up.shape.size.y, up.shape.size.x)
	right.position.y = up.position.y
	left.shape.size = right.shape.size
	left.position.y = up.position.y

@tool
extends Node2D
class_name Gusher

var physic_bodies: Array[CharacterBody2D] = []
var upwards_push_speed: float = 128.0
var buoyancy_acceleration: float = 512.0
var max_sink_speed: float = 128.0

@onready var hit_area: Obstacle = $HitArea
@onready var hit_collision: CollisionShape2D = $HitArea/Collision
@onready var bouyancy_area: Obstacle = $BouyancyArea
@onready var bouyancy_collision: CollisionShape2D = $BouyancyArea/Collision
@onready var patch: NinePatchRect = $GusherPatch

@export var full_size: Vector2i = Vector2i.ONE * 2:
	set(new):
		full_size = new.clamp(Vector2i.ONE * 2, Vector2i.MAX)
		if hit_collision != null and bouyancy_collision != null:
			update_all_size()
var rise_amount: float = 1.0

func _ready() -> void:
	hit_collision.shape = hit_collision.shape.duplicate()
	bouyancy_collision.shape = bouyancy_collision.shape.duplicate()
	update_all_size()

func _physics_process(delta: float) -> void:
	update_all_size()
	if Engine.is_editor_hint(): return
	for other in physic_bodies:
		if other.velocity.y > -128.0:
			other.velocity.y -= buoyancy_acceleration * delta
		other.velocity.y = minf(other.velocity.y, max_sink_speed)
		#other.velocity.y = move_toward(other.velocity.y, -upwards_push_speed, delta * buoyancy_acceleration)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	rise_amount = (sin(Time.get_ticks_msec() / 1000.0) + 1.0) * 0.5
	update_visual_size()

func update_visual_size() -> void:
	patch.position.y = full_size.y * 32.0 - patch.size.y
	
	patch.size = full_size * 32.0
	patch.size.y *= rise_amount

func update_all_size() -> void:
	var hit: RectangleShape2D = hit_collision.shape
	var bouyancy: RectangleShape2D = bouyancy_collision.shape
	
	hit.size = full_size * 32.0
	bouyancy.size = full_size * 32.0
	
	hit.size.x -= 14.0
	
	hit.size.y *= rise_amount
	bouyancy.size.y *= rise_amount
	
	hit_collision.position = full_size * 16.0
	bouyancy_collision.position = full_size * 16.0
	
	hit_collision.position.y *= rise_amount
	bouyancy_collision.position.y *= rise_amount
	
	hit_collision.position.y = full_size.y * 32.0 - hit_collision.position.y
	bouyancy_collision.position.y = full_size.y * 32.0 - bouyancy_collision.position.y
	
	update_visual_size()

func next_frame() -> void:
	patch.region_rect.position.x += 64.0
	if patch.region_rect.position.x >= 64.0 * 3.0:
		patch.region_rect.position.x = 0.0

func bouyancy_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		physic_bodies.append(body)

func bouyancy_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		physic_bodies.erase(body)

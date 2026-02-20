class_name MagnetRickShawn
extends CharacterBody2D

@onready var rope: Line2D = $Line2D
@onready var trigger: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

@export var is_facing_right: bool
var facing: int:
	get(): return 1 if is_facing_right else -1

var origin: Vector2
var origin_is_rick: bool
var rick: PlayerRickShawn;
var rope_offset: Vector2 = Vector2.ZERO

var magnet_speed: float = 1200
var rope_distance_from_rick: float = 10
var ropes_for_hollows: Array[Line2D] = []
var closest_rope: Line2D

const ROPE_TEXTURE = preload("uid://flc6x8anvjcu")

func _ready() -> void:
	# Magnet is created as a sibling node, so relative pathing should always work.
	rick = get_node("../PlayerRickShawn");
	origin = rick.magnet_launch_position.global_position
	closest_rope = rope
	origin_is_rick = true
	
	# Move appropriate objects left if the magnet is thrown left.
	if (!is_facing_right):
		sprite.flip_h = true;
		trigger.move_local_x(-22);
		move_local_x(-80)
	
	velocity.x = magnet_speed * facing
	rope_offset.x = rope_distance_from_rick * facing

func _physics_process(delta: float) -> void:
	# Drawing the rope each frame. Stretches between rick's hand and the magnet's back.
	match rick.state:
		rick.THROWING:
			rope.clear_points()
			if origin_is_rick:
				rope.add_point(rick.magnet_launch_position.global_position - rope.global_position)
			else:
				rope.add_point(origin - rope.global_position)
			rope.add_point(sprite.position - rope_offset)
			
			if not ropes_for_hollows.is_empty():
				ropes_for_hollows[0].set_point_position(0, rick.magnet_launch_position.global_position - closest_rope.global_position)
			
			self.position += velocity * delta
		rick.PULLING:
			closest_rope.set_point_position(0, rick.magnet_launch_position.global_position - closest_rope.global_position)

func went_throw_hollow(old_position: Vector2) -> void:
	var pre_hollow_line: Line2D = Line2D.new()
	
	get_parent().add_child(pre_hollow_line)
	
	pre_hollow_line.texture = ROPE_TEXTURE
	pre_hollow_line.width = 3.0
	pre_hollow_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	pre_hollow_line.joint_mode = Line2D.LINE_JOINT_ROUND
	pre_hollow_line.sharp_limit = 3.0
	pre_hollow_line.round_precision = 2
	
	ropes_for_hollows.append(pre_hollow_line)
	pre_hollow_line.global_position = old_position
	
	var offset: Vector2 = origin - pre_hollow_line.global_position
	pre_hollow_line.add_point(offset)
	pre_hollow_line.add_point(offset.normalized() * 64)
	
	closest_rope = pre_hollow_line
	
	origin_is_rick = false
	origin = global_position

func rick_passed_through_hollow(_entered: Hollow, _exited: Hollow) -> void:
	if ropes_for_hollows.is_empty():
		return
	var hollow_rope: Line2D = ropes_for_hollows.pop_at(0)
	hollow_rope.queue_free()
	if not ropes_for_hollows.is_empty():
		closest_rope = ropes_for_hollows[0]
	else:
		closest_rope = rope

func _exit_tree() -> void:
	for hollow_rope in ropes_for_hollows:
		if hollow_rope != null:
			hollow_rope.queue_free()

func _on_wall_collision(body: Node) -> void:
	# This should only ever occur when hitting terrain
	if (!body is TileMapLayer): return;
	rick.enter_pull_state()

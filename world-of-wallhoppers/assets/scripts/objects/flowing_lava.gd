@tool
extends TextureRect
class_name FlowingLava

@onready var hit_area: Obstacle = $HitArea
@onready var hit_collision: CollisionShape2D = $HitArea/Collision

var body: StaticBody2D
var area: Area2D

var body_shape: CollisionShape2D
var area_shape: CollisionShape2D

var physic_bodies: Array[CharacterBody2D]

var acceleration: float = 512.0
var target_speed: float = 196.0
var buoyancy_acceleration: float = 320.0
var max_sink_speed: float = 32.0
var max_lavafall_sink_speed: float = 96.0
var upwards_lava_speed: float = 64.0

@export var flow_direction: FLOW_DIRECTION = FLOW_DIRECTION.RIGHT

enum FLOW_DIRECTION {
	NONE,
	RIGHT,
	LEFT,
	DOWN,
	UP,
}

const LAYER_NONE: int = 0
const LAYER_MOVE_OBJECT_ZONE: int = 32
const LAYER_PLAYER_ONLY: int = 64

func _ready() -> void:
	if Engine.is_editor_hint(): return
	stretch_mode = TextureRect.STRETCH_TILE
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	body = StaticBody2D.new()
	area = Area2D.new()
	body_shape = CollisionShape2D.new()
	area_shape = CollisionShape2D.new()
	
	var b_shape: RectangleShape2D = RectangleShape2D.new()
	var a_shape: RectangleShape2D = RectangleShape2D.new()
	
	b_shape.size = size - Vector2.ONE * 2.0
	a_shape.size = size
	
	add_child(body)
	add_child(area)
	
	body.collision_mask = LAYER_NONE
	body.collision_layer = LAYER_PLAYER_ONLY
	
	body.collision_priority = 100.0
	
	area.collision_layer = LAYER_NONE
	area.collision_mask = LAYER_MOVE_OBJECT_ZONE
	
	body.add_child(body_shape)
	area.add_child(area_shape)
	
	body_shape.position = size / 2.0
	area_shape.position = size / 2.0
	hit_area.position = size / 2.0
	
	body_shape.shape = b_shape
	area_shape.shape = a_shape
	hit_collision.shape = area_shape.shape
	
	area_shape.position.y -= 2
	
	set_shader_flow(flow_direction)
	
	area.body_entered.connect(body_entered)
	area.body_exited.connect(body_exited)

func set_shader_flow(flow: FLOW_DIRECTION):
	match flow:
		FLOW_DIRECTION.NONE:
			material.set_shader_parameter("direction", Vector2.ZERO)
		FLOW_DIRECTION.RIGHT:
			material.set_shader_parameter("direction", Vector2.RIGHT)
		FLOW_DIRECTION.LEFT:
			material.set_shader_parameter("direction", Vector2.LEFT)
		FLOW_DIRECTION.DOWN:
			material.set_shader_parameter("direction", Vector2.DOWN)
		FLOW_DIRECTION.UP:
			material.set_shader_parameter("direction", Vector2.UP)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		set_shader_flow(flow_direction)
		return
	
	match flow_direction:
		FLOW_DIRECTION.LEFT, FLOW_DIRECTION.RIGHT:
			for other in physic_bodies:
				var direction: int = 1 if flow_direction == FLOW_DIRECTION.RIGHT else -1
				other.velocity.x = move_toward(other.velocity.x, target_speed * direction, delta * acceleration)
	
	match flow_direction:
		FLOW_DIRECTION.LEFT, FLOW_DIRECTION.RIGHT, FLOW_DIRECTION.NONE:
			for other in physic_bodies:
				other.velocity.y -= buoyancy_acceleration * delta
				other.velocity.y = minf(other.velocity.y, max_sink_speed)
		FLOW_DIRECTION.DOWN:
			for other in physic_bodies:
				other.velocity.y = minf(other.velocity.y, max_lavafall_sink_speed)
		FLOW_DIRECTION.UP:
			for other in physic_bodies:
				other.velocity.y = move_toward(other.velocity.y, -upwards_lava_speed, delta * buoyancy_acceleration)

func body_entered(other_body: Node2D):
	if other_body is CharacterBody2D:
		physic_bodies.append(other_body)

func body_exited(other_body: Node2D):
	if other_body is CharacterBody2D:
		physic_bodies.erase(other_body)

@tool
extends TextureRect
class_name FlowingLava

var body: StaticBody2D
var area: Area2D

var body_shape: CollisionShape2D
var area_shape: CollisionShape2D

var physic_bodies: Array[CharacterBody2D]

var acceleration: float = 512.0
var target_speed: float = 196.0

@export_enum("Right", "Left") var flow_direction: int = 1

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
	
	b_shape.size = size
	a_shape.size = size
	
	add_child(body)
	add_child(area)
	
	body.collision_mask = 0
	body.collision_layer = 1
	
	area.collision_layer = 0
	area.collision_mask = 32
	
	body.add_child(body_shape)
	area.add_child(area_shape)
	
	body_shape.position = size / 2.0
	area_shape.position = size / 2.0
	
	body_shape.shape = b_shape
	area_shape.shape = a_shape
	
	area_shape.position.y -= 2
	
	flip_h = flow_direction == 0
	
	area.body_entered.connect(body_entered)
	area.body_exited.connect(body_exited)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		flip_h = flow_direction == 0
		return
	for other in physic_bodies:
		var direction: int = 1 if flow_direction == 0 else -1
		other.velocity.x = move_toward(other.velocity.x, target_speed * direction, delta * acceleration)

func body_entered(other_body: Node2D):
	if other_body is CharacterBody2D:
		physic_bodies.append(other_body)

func body_exited(other_body: Node2D):
	if other_body is CharacterBody2D:
		physic_bodies.erase(other_body)

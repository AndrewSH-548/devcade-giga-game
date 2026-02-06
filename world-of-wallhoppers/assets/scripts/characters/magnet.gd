extends StaticBody2D

@onready var rope: Line2D = $Line2D
@onready var trigger: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var this: StaticBody2D = $"."

@export var is_facing_right: bool

var rick: CharacterBody2D;
var velocity: Vector2;
var rope_offset: Vector2;

func _ready() -> void:
	# Magnet is created as a sibling node, so relative pathing should always work.
	rick = get_node("../PlayerRickShawn");
	
	# Move appropriate objects left if the magnet is thrown left.
	if (!is_facing_right):
		sprite.flip_h = true;
		trigger.move_local_x(-22);
		move_local_x(-80)
	velocity = Vector2.RIGHT * 5 if is_facing_right else Vector2.LEFT * 5;
	rope_offset = Vector2.RIGHT * 10 if is_facing_right else Vector2.LEFT * 10;
	

func _process(_delta: float) -> void:
	# Drawing the rope each frame. Stretches between rick's hand and the magnet's back.
	rope.clear_points();
	if (rick.is_throwing): rope.add_point(rick.global_position - rope.global_position);
	else: rope.add_point(rick.hanging_position - rope.global_position);
	rope.add_point(sprite.global_position - rope.global_position - rope_offset);
	
	if (!rick.is_hanging): this.position += velocity;

func _on_wall_collision(body: Node) -> void:
	# This should only ever occur when hitting terrain
	if (!body is TileMapLayer): return;
	
	# Set up Rick shawn variables for the hanging state
	rick.is_throwing = false;
	rick.is_hanging = true;
	rick.velocity = Vector2.ZERO;
	rick.rope_distance = (rope.global_position - rick.global_position).length();
	
	pass # Replace with function body.

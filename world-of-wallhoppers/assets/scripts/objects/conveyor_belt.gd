extends Node2D

@onready var ray_cast_2d: RayCast2D = $AnimatedSprite2D/AnimatableBody2D/RayCast2D
@onready var animatable_body_2d: AnimatableBody2D = $AnimatedSprite2D/AnimatableBody2D
@onready var direction_marker: Marker2D = $AnimatedSprite2D/DirectionMarker


@export var conveyor_speed : float = 65; ## the velocity that the conveyor belt will apply to the body on it.

var body = null;

func _process(_delta: float) -> void:
	body = ray_cast_2d.get_collider();
	if(body is CharacterBody2D):
		body.velocity += (direction_marker.global_position - body.global_position).normalized() * conveyor_speed;
	elif(body is RigidBody2D):
		body.linear_velocity += (direction_marker.global_position - body.global_position).normalized() * conveyor_speed;

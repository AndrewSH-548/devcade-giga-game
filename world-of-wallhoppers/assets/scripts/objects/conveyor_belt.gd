@tool
extends Node2D

@export var flipped: bool = false
@onready var push_area: Area2D = $PushArea
@onready var side: Panel = $SpriteOld/Side
@onready var push_shape: CollisionShape2D = $PushArea/PushShape
@onready var sprite: AnimatedSprite2D = $Sprite

var acceleration: float = 5200
var max_speed: Vector2 = Vector2(128.0, 512.0)
var walk_modifier: float = 1.5
var climb_modifier: float = 1.0
var climb_addition: float = 128.0

func _ready() -> void:
	editor_update()
	rotation_degrees = snappedf(rotation_degrees, 90)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_update()
		return
	
	# Get the direction of the conveyor from its angle, snapped to 90 degress and rounded to the hundreths place
	var direction: Vector2 = Vector2.from_angle(snappedf(rotation, PI / 2.0)).snappedf(0.01)
	
	# Don't do anything if direction is zero (which should be impossible)
	if direction == Vector2.ZERO:
		return
	
	# Get the sign of each direction
	var x_direction: float = sign(direction.x)
	var y_direction: float = sign(direction.y)
	# Get modifiers at the correct intensities for directions
	var true_walk_modifier: float = walk_modifier * x_direction
	var true_climb_modifier: float = climb_modifier * y_direction
	# If there is and 0 sign directions, don't modify (use 1.0)
	if x_direction == 0.0: true_walk_modifier = 1.0
	if y_direction == 0.0: true_climb_modifier = 1.0
	
	# For each body that overlaps the conveyor areas...
	for body in push_area.get_overlapping_bodies():
		# Handle CharacterBodies
		if body is CharacterBody2D:
			# Increase velocity towards the max speed in the direction of the conveyor
			body.velocity = body.velocity.move_toward(direction * max_speed, acceleration * delta)
			# Handle Players
			if body is Player:
				# Cast to player (For better coding and debugging)
				var player: Player = body as Player
				# Disable player decceleration for 0.5 seconds
				player.disable_decceleration_timed(0.5)
				# Set the player's walk modifier
				player.walk_speed_frame_modifier_directional = true_walk_modifier
				# Hand Hip specifics
				if player is PlayerHip:
					var hip: PlayerHip = player
					# Set Hip's climb modifier
					hip.frame_climb_speed_modifier = true_climb_modifier
					# Set Hip's climb addition
					hip.frame_climb_velocity_addition = climb_addition * y_direction
		# Handle RigidBodies
		elif body is RigidBody2D:
			# Increase velocity towards the max spedd in the direction of the conveyor
			body.linear_velocity = body.linear_velocity.move_toward(direction * max_speed, acceleration * delta)

func editor_update() -> void:
	side.scale.y = 1.0 if not flipped else -1.0
	sprite.flip_v = flipped

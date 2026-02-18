@tool
class_name Hollow
extends Node2D

@export var connected_to: Hollow
@onready var object_detector: Area2D = $ObjectDetector
@onready var teleport_position: Marker2D = $TeleportPosition

enum Direction {
	LEFT,
	RIGHT,
}

@export var direction: Direction = Direction.RIGHT

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint(): return
	match direction:
		Direction.LEFT: scale.x = -1
		Direction.RIGHT: scale.x = 1

func _ready() -> void:
	if Engine.is_editor_hint(): return
	object_detector.body_entered.connect(on_body_entered_hollow)
	assert(connected_to != null, "Hollow must be connected to another Hollow")

func on_body_entered_hollow(body: Node2D) -> void:
	if Engine.is_editor_hint(): return

	if body is Player:
		var player: Player = body as Player
		player.foot_global_position.x = connected_to.teleport_position.global_position.x
		player.global_position.y = connected_to.teleport_position.global_position.y - (teleport_position.global_position.y - player.global_position.y)
		if player.has_method("on_passed_through_hollow"):
			player.on_passed_through_hollow(self, connected_to)
		return
	if body is MagnetRickShawn:
		var magnet: MagnetRickShawn = body as MagnetRickShawn
		var old_position: Vector2 = magnet.global_position
		magnet.global_position.x = connected_to.teleport_position.global_position.x - (magnet.trigger.global_position.x - magnet.global_position.x)
		magnet.global_position.y = connected_to.teleport_position.global_position.y - (teleport_position.global_position.y - magnet.global_position.y)
		magnet.went_throw_hollow(old_position)
		return

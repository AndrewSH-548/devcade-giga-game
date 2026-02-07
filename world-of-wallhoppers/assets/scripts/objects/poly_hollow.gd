extends Node2D

const SPIKEY_POLY = preload("res://scenes/objects/spikey-poly/spikey-poly.tscn")
@onready var spawn_location: Marker2D = $SpawnLocation
@onready var alt_spawn_location: Marker2D = $ALTSpawnLocation

@export var spawning: bool = false
@export var poly_direction: SpikeyPoly.Direction = SpikeyPoly.Direction.RIGHT

var spawn_frequency: float = 2.5
var timer: Timer = Timer.new()

func _ready() -> void:
	if not spawning:
		return
	rotation = snappedf(rotation, PI / 2)
	add_child(timer)
	timer.timeout.connect(spawn)
	timer.start(spawn_frequency)

func spawn() -> void:
	var poly: SpikeyPoly = SPIKEY_POLY.instantiate()
	get_parent().add_child(poly)
	poly.global_position = spawn_location.global_position
	if poly_direction == SpikeyPoly.Direction.RIGHT:
		poly.global_position = alt_spawn_location.global_position
	poly.rotation = rotation + (PI if poly_direction == SpikeyPoly.Direction.RIGHT else 0.0)
	poly.setup_for_direction(poly_direction)

func on_poly_entered(area: Area2D) -> void:
	if area.get_parent().has_method("delete_poly"):
		area.get_parent().delete_poly()

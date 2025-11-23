extends StaticBody2D
class_name RockWall

const FALLEN_ROCK: PackedScene = preload("res://scenes/objects/fallen_rock/fallen_rock.tscn")
const PLAYER_ONLY_LAYER: int = 64

@onready var rock_timer: Timer = $RockTimer
@onready var rock_destroyer: Area2D = $RockDestroyer

@export_enum("Spawning", "Destroying") var rock_spawning_mode: int = 0
@export var possible_sizes: Array[Vector2i] = [Vector2i(2, 2)]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	assert(possible_sizes.size() != 0, "No rocks set in RockWall's Possible Sizes!")
	rock_timer.timeout.connect(spawn_rock)
	# This makes sure the order of rocks is always the same, even though it's random
	rng.seed = hash(global_position)
	z_index += 1
	collision_mask = 0
	collision_layer = PLAYER_ONLY_LAYER
	if rock_spawning_mode == 0:
		rock_timer.start()
	elif rock_spawning_mode == 1:
		rock_destroyer.body_entered.connect(on_possible_rock_entry)

func spawn_rock() -> void:
	var rock: FallenRock = FALLEN_ROCK.instantiate()
	add_child(rock)
	rock.z_index -= 1
	print("SPAWN")
	rock.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	rock.global_position = global_position
	rock.global_rotation = 0
	rock.size = ensure_valid_size(possible_sizes[rng.randi_range(0, possible_sizes.size() - 1)])
	rock.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func ensure_valid_size(current_size: Vector2i) -> Vector2i:
	current_size.x = maxi(1, current_size.x)
	current_size.y = maxi(1, current_size.y)
	return current_size

func on_possible_rock_entry(body: Node2D) -> void:
	if body is FallenRock:
		print("DESTROY")
		body.queue_free()

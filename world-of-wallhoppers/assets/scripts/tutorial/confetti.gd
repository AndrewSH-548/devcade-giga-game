extends GPUParticles2D
class_name Confetti

const CONFETTI = preload("res://assets/sprites/tutorial/confetti.png")
const CONFETTI_PROCESS_MATERIAL = preload("res://assets/scripts/tutorial/confetti_process_material.tres")

func _ready() -> void:
	emitting = false
	amount = 100
	texture = CONFETTI
	lifetime = 6.0
	explosiveness = 0.99
	speed_scale = 2.0
	process_material = CONFETTI_PROCESS_MATERIAL

func burst() -> void:
	restart()
	emitting = true
	await get_tree().create_timer(lifetime / speed_scale).timeout
	emitting = false

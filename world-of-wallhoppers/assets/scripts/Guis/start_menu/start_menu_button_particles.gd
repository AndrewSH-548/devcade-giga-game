extends StartMenuButton

@export var particle: GPUParticles2D

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	particle.speed_scale = 1.0 if active else 0.0

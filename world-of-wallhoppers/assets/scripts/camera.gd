extends Camera2D
class_name PlayerCamera

var target: CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Changing this if affects when the camera starts scrolling.
	if target.position.y < 250:
		# Changing this actually positions the player onto the screen.
		# The camera snaps very unprofessionally when the if statement and this offset don't match.
		position = Vector2(position.x, target.position.y - 250);

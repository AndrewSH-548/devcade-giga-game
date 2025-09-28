extends Node2D

# When the player touches the obstacle
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		call_deferred("moveplayer", body)

# Handles knockback of the player 
func moveplayer(body: Node2D):
	body.hitstun = true
	if not body.velocity.x == 0:
		# Move the player in the opposite direction of their motion 
		body.velocity.x = -(body.velocity.x/abs(body.velocity.x)) * 20*body.weight # 20 can be changed
	if not body.velocity.y == 0:
		body.velocity.y = -(body.velocity.y/abs(body.velocity.y)) * 20*body.weight
	
	# Create hitstun effect (time can be changed (currently 1 second))
	await get_tree().create_timer(1).timeout
	body.hitstun = false

extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player1Body" or body.name == "Player2Body":
		call_deferred("moveplayer", body)

func moveplayer(body: Node2D):
	body.hitstun = true
	if not body.velocity.x == 0:
		body.velocity.x = -(body.velocity.x/abs(body.velocity.x)) * 20*body.weight
	if not body.velocity.y == 0:
		body.velocity.y = -(body.velocity.y/abs(body.velocity.y)) * 20*body.weight
	
	await get_tree().create_timer(1).timeout
	body.hitstun = false

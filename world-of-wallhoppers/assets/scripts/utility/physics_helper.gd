class_name Phys
extends Node

## Given a Player and a launch height, determines the y velocity needed to reach that height at the peak of the launch
## Negative values have no useful behavior! Be careful with them!
## The returned force is NEGATIVE, since negative y is up!
## If using from foot position, instead of getting the center of the player to a certain height,
## an offset is used to make sure the player's foot position gets to a height,
## This is useful for insuring characters of different sizes can reach the same platform, for example
static func force_to_launch_to_height(player: Player, height: float, from_foot_position: bool = true) -> float:
	if height < 0:
		return 0
	if from_foot_position:
		height += abs(player.foot_global_position.y - player.global_position.y)
	# Velf^2 = Vel0^2 + 2*Acc*(delta pos) -> Vel0 = sqrt(2*Acc*(delta pos) - Velf^2)
	# Velf = Zero
	# Acc = Player's gravity
	# Delta pos = launch height
	# Vel0 = Initial velocity -> What this equation gets:
	return -sqrt(2 * player.gravity * height)

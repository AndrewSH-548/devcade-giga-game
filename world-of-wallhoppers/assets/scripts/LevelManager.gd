extends Node


var current_level: String = "";

func switch_level(level: String):
	match level.to_lower():
		"volcano":
			current_level = level;
		"jungle":
			current_level = level;
		"reef":
			current_level = level
		_:
			print_debug("ERROR: Invalid level -> " + level);

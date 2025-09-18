extends Node2D

@export var target_left_position_x: int = -120;
@export var target_right_position_x: int = 120;


@onready var static_body_2d: StaticBody2D = $StaticBody2D

@onready var target_left: Node2D = $TargetLeft
@onready var target_right: Node2D = $TargetRight

var go_left = true # determines to go left or right
var go_right = false

var tween = get_tree().create_tween()

func _process(delta: float) -> void:
	if go_left: # go to the left target's position
		tween.tween_property(static_body_2d, "position", target_left.position, 1)
	elif go_right: # go to the right target's position
			tween.tween_property(static_body_2d, "position", target_right.position, 1)
	
	if self.position == target_left.position: # change to going right
		go_left == false
		go_right == true
	elif self.position == target_right.position: # change to going left
		go_left == true
		go_right == false

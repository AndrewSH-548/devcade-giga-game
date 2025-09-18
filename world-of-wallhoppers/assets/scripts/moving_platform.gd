extends Node2D

@onready var static_body_2d: StaticBody2D = $StaticBody2D

@onready var target_left: Node2D = $TargetLeft
@onready var target_right: Node2D = $TargetRight


@export var target_left_position_x: int = -120;
@export var target_left_position_y: int = 0;
@export var target_right_position_x: int = 120;
@export var target_right_position_y: int = 0;


var go_left = true; # determines to go left or right
var go_right = false;

var tween; 

func _ready() -> void:
	target_left.position = Vector2(target_left_position_x, target_left_position_y); # set the target's position
	target_right.position = Vector2(target_right_position_x, target_right_position_y);


func _process(delta: float) -> void:
	tween = get_tree().create_tween();
	
	if go_left: # go to the left target's position
		tween.tween_property(static_body_2d, "position", target_left.position, 1).set_trans(Tween.TRANS_LINEAR);
	elif go_right: # go to the right target's position
		tween.tween_property(static_body_2d, "position", target_right.position, 1);


	if static_body_2d.position <= (target_left.position + Vector2(5, 0)): # change to going right
		go_left = false;
		go_right = true;
	elif static_body_2d.position >= (target_right.position + Vector2(-5, 0)): # change to going left
		go_left = true;
		go_right = false;

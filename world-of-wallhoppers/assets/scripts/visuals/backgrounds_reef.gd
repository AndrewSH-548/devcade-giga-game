extends "res://assets/scripts/visuals/backgrounds.gd"

@export var below_backgrounds: Array[CanvasItem]
@export var above_backgrounds: Array[CanvasItem]

@onready var swap_point: Marker2D = $"../SwapPoint"

enum {
	BELOW,
	ABOVE,
}

var visibility_state_p1: int = BELOW
var visibility_state_p2: int = BELOW

func _ready() -> void:
	for background in below_backgrounds:
		background.set_meta(&"VisibleType", &"BELOW")
	for background in above_backgrounds:
		background.set_meta(&"VisibleType", &"ABOVE")
	super._ready()

func _process(delta: float) -> void:
	if level_header == null:
		return
	update_states()
	update_visibilities()
	super._process(delta)

func update_states():
	visibility_state_p1 = BELOW if player_1_camera.get_screen_center_position().y > swap_point.global_position.y else ABOVE
	if player_2_camera == null: return
	visibility_state_p2 = BELOW if player_2_camera.get_screen_center_position().y > swap_point.global_position.y else ABOVE

func update_visibilities():
	for background in player_1_backgrounds:
		match background.get_meta(&"VisibleType"):
			&"BELOW":
				background.visible = visibility_state_p1 == BELOW
			&"ABOVE":
				background.visible = visibility_state_p1 == ABOVE
	if player_2_camera == null: return
	for background in player_2_backgrounds:
		match background.get_meta(&"VisibleType"):
			&"BELOW":
				background.visible = visibility_state_p2 == BELOW
			&"ABOVE":
				background.visible = visibility_state_p2 == ABOVE

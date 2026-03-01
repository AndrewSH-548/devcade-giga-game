extends Label

const DEBUG_PANEL = preload("res://assets/scripts/debugging/debug_panel.tscn")
var panel: DebugPanel

var last_focus: Control = null
var unfocused: bool = true
var header: LevelHeaderBase = null

var values_freecam: bool:
	get(): return panel != null and panel.tools.cam_check_button.is_pressed()

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	custom_minimum_size = Vector2(600, 1000)
	z_index = 100
	panel = DEBUG_PANEL.instantiate()
	add_child(panel)
	await get_tree().physics_frame
	last_focus = get_viewport().gui_get_focus_owner()
	panel.close.pressed.connect(close)
	panel.unfocus.pressed.connect(unfocus)
	close()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("p2_up") and Input.is_action_pressed("p1_down") and Input.is_action_pressed("p1_devcade_green"):
		if unfocused:
			open()
		
	elif Input.is_action_just_pressed("ui_cancel") and not (Input.is_action_pressed("p2_up") and Input.is_action_pressed("p1_down")):
		close()

func open() -> void:
	last_focus = get_viewport().gui_get_focus_owner()
	visible = true
	unfocused = false
	panel.focus_this.call_deferred()

func close() -> void:
	if last_focus != null:
		get_viewport().gui_release_focus()
		last_focus.grab_focus.call_deferred()
	visible = false
	unfocused = true

func unfocus() -> void:
	get_viewport().gui_release_focus()
	if last_focus != null:
		last_focus.grab_focus.call_deferred()
	unfocused = true

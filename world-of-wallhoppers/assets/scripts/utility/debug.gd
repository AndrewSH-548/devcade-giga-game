extends Label

const DEBUG_PANEL = preload("res://assets/scripts/debugging/debug_panel.tscn")
var panel: DebugPanel

var last_focus: Control = null
var unfocused: bool = true
var header: LevelHeaderBase = null

var values_freecam: bool:
	get(): return panel != null and panel.tools.cam_check_button.is_pressed()

const CODE_LENGTH: int = 11
const CODE: Array[StringName] = [
	"up", "up", "left", "right", "crouch", "crouch", "crouch", "devcade_green", "run", "up", "up",
] 
var code_counter: Array[StringName] = []
var accepted_code_events: Array[StringName] = [
	"p1_up",
	"p1_crouch",
	"p1_right",
	"p1_left",
	"p1_run",
	"p1_devcade_green",
]

func _ready() -> void:
	setup_panel()
	setup_focus.call_deferred()
	code_counter.resize(CODE_LENGTH)

func _input(event: InputEvent) -> void:
	code_input(event)

func code_input(event: InputEvent) -> void:
	if event.is_pressed():
		var used_event: StringName = &""
		for event_name in accepted_code_events:
			if event.is_action(event_name):
				used_event = event_name
		
		if used_event == &"":
			return
		
		code_counter.append(used_event.substr(3))
		code_counter.reverse()
		code_counter.resize(CODE_LENGTH)
		code_counter.reverse()
	
	for index: int in range(CODE_LENGTH):
		if code_counter[index] != CODE[index]:
			return
	code_counter.fill(&"")
	open()

func setup_panel() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	custom_minimum_size = Vector2(600, 1000)
	z_index = 100
	panel = DEBUG_PANEL.instantiate()
	add_child(panel)

func setup_focus() -> void:
	last_focus = get_viewport().gui_get_focus_owner()
	panel.close.pressed.connect(close)
	panel.unfocus.pressed.connect(unfocus)
	close()

func open() -> void:
	if not unfocused:
		return
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

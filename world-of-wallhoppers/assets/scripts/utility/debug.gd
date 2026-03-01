extends Label

const BETTER_VCR_9_0_1 = preload("res://assets/fonts/Better VCR 9.0.1.ttf")
const PORTRAIT_HIP = preload("uid://ciopa5mfn4l4a")

var input_shower: Label

func _ready() -> void:
	z_index = 100
	label_settings = LabelSettings.new()
	label_settings.outline_color = Color.BLACK
	label_settings.outline_size = 48
	
	input_shower = Label.new()
	add_child(input_shower)
	input_shower.label_settings = label_settings.duplicate()
	input_shower.label_settings.font_size = 64
	input_shower.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	input_shower.custom_minimum_size.x = 480
	input_shower.custom_minimum_size.y = 320
	
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_pressed("p2_up") and Input.is_action_pressed("p1_down") and Input.is_action_pressed("ui_cancel"):
		visible = true
	elif Input.is_action_just_pressed("ui_cancel") and not (Input.is_action_pressed("p2_up") and Input.is_action_pressed("p1_down")):
		visible = false

func _input(event: InputEvent) -> void:
	
	input_shower.text = event.as_text() + " | " + input_shower.text
	input_shower.text = input_shower.text.substr(0, 100)
	
	if event.is_action_pressed("p2_crouch"):
		var log_file: FileAccess = FileAccess.open("user://logs/godot.log", FileAccess.READ)
		if log_file == null:
			text = "Could not get logs"
			return
		text = log_file.get_as_text()
		log_file.close()

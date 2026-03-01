extends Label

const BETTER_VCR_9_0_1 = preload("res://assets/fonts/Better VCR 9.0.1.ttf")
const PORTRAIT_HIP = preload("uid://ciopa5mfn4l4a")


func _ready() -> void:
	z_index = 100
	label_settings = LabelSettings.new()
	label_settings.outline_color = Color.BLACK
	label_settings.outline_size = 48

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p2_crouch"):
		var log_file: FileAccess = FileAccess.open("user://logs/godot.log", FileAccess.READ)
		if log_file == null:
			text = "Could not get logs"
			return
		text = log_file.get_as_text()
		log_file.close()
	visible = event.is_action("p2_up")

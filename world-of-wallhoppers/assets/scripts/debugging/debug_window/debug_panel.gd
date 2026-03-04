extends Panel
class_name DebugPanel

@onready var close: Button = $VBoxContainer/MarginContainer/HBoxContainer/Close
@onready var unfocus: Button = $VBoxContainer/MarginContainer/HBoxContainer/Unfocus

@onready var tools: Control = $VBoxContainer/TabContainer/Tools

func focus_this() -> void:
	close.grab_focus()

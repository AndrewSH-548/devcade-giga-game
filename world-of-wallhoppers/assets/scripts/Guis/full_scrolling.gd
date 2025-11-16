extends ScrollContainer
class_name FullScrollingContainer

func _input(event: InputEvent) -> void:
	if not has_focus(): return
	if event.is_action("ui_down"):
		pass

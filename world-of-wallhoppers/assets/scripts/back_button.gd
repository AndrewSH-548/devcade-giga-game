extends BaseButton

func _pressed() -> void:
	SceneSwitcher.load_last_scene()

extends Node2D

@export
var viewport : SubViewport

func _ready() -> void:
	var levels = LevelsLoader.get_packed_scenes()
	
	for level in levels:
		for child in viewport.get_children():
			viewport.remove_child(child)

		var new_level = level.instantiate()
		new_level = new_level as Node2D

		new_level.global_position = viewport.size / 2.0

		viewport.add_child(new_level)

		await RenderingServer.frame_post_draw

		var img := viewport.get_texture().get_image();

		# save new texture
		img.save_png(level.resource_path.trim_suffix(".tscn") + "_gui_texture.png")

	get_tree().quit()

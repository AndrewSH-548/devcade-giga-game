extends Control

@export var levels: Array[SceneDesriptors]

@export var grid_container: GridContainer
var button_grab_focus: Script = preload("button_grab_focus.gd")

var isMultiplayer: bool = false;

signal load_multiplayer_level
signal load_singleplayer_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(levels)):
		var new_aspect_ratio_conatiner := AspectRatioContainer.new();

		new_aspect_ratio_conatiner.texture_repeat = AspectRatioContainer.TEXTURE_REPEAT_DISABLED;
		new_aspect_ratio_conatiner.alignment_horizontal = AspectRatioContainer.ALIGNMENT_CENTER;
		new_aspect_ratio_conatiner.alignment_vertical = AspectRatioContainer.ALIGNMENT_CENTER;
		new_aspect_ratio_conatiner.size_flags_vertical = AspectRatioContainer.SIZE_EXPAND_FILL;
		new_aspect_ratio_conatiner.size_flags_horizontal = AspectRatioContainer.SIZE_EXPAND_FILL;

		var level = levels[i]
		var new_button := TextureButton.new()

		new_button.size_flags_vertical = TextureButton.SIZE_EXPAND_FILL;
		new_button.size_flags_horizontal = TextureButton.SIZE_EXPAND_FILL;
		new_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT;

		if i == 0:
			new_button.set_script(button_grab_focus);

		new_button.name = level.name;

		var normal_texture:   Image = level.texture.get_image()
		var pressed_texture:  Image = level.texture.get_image()
		var hover_texture:    Image = level.texture.get_image()
		var disabled_texture: Image = level.texture.get_image()
		var focused_texture:  Image = level.texture.get_image()

		darken_image(pressed_texture, 0.6)

		darken_image(hover_texture, 0.3)

		darken_image(disabled_texture, 1)

		var edge_color: Color;
		edge_color.r = 1.0;
		edge_color.g = 1.0;
		edge_color.b = 1.0;
		edge_color.a = 1.0;

		darken_image(focused_texture, 0.3)

		add_edge(focused_texture, edge_color, 1)

		new_button.texture_normal   = ImageTexture.create_from_image(normal_texture)
		new_button.texture_pressed  = ImageTexture.create_from_image(pressed_texture)
		new_button.texture_hover    = ImageTexture.create_from_image(hover_texture)
		new_button.texture_disabled = ImageTexture.create_from_image(disabled_texture)
		new_button.texture_focused  = ImageTexture.create_from_image(focused_texture)

		var function: Callable = load_level.bind(level)
		new_button.pressed.connect(function)
		
		new_aspect_ratio_conatiner.add_child(new_button);
		grid_container.add_child(new_aspect_ratio_conatiner)


# load the new level with the proper scene type (mutiplayer or not)
func load_level(level: SceneDesriptors) -> void:
	if isMultiplayer:
		load_multiplayer_level.emit(level)
	else:
		load_singleplayer_level.emit(level)

	print("loading level: " + level.name)
	# this works, but depending on how levels are designed, is might be required that the node2d, in this case named level, would have to be changed instead


# adds an edge of color, color, with width, border_width, to an image
func add_edge(image: Image, color: Color, border_width: int):
	var width: int = image.get_width()
	var height: int = image.get_height()

	for x in range(width):
		for o in range(border_width):
			image.set_pixel(x, o, color)
			image.set_pixel(x, height - 1 - o, color)

	for y in range(height):
		for o in range(border_width):
			image.set_pixel(o, y, color)
			image.set_pixel(width - o - 1, y, color)



# chnages the transparency of an image
func change_alpha(image: Image, new_alpha: float):
	if new_alpha < 0:
		new_alpha = 0
	if new_alpha > 1:
		new_alpha = 1

	var width: int = image.get_width()
	var height: int = image.get_height()

	for x in range(width):
		for y in range(height):
			if x == 0 or y == 0 or x == width - 1 or y == height - 1:
				var color = image.get_pixel(x, y)
				color.a = new_alpha
				image.set_pixel(x, y, color)


# darkens an entire image
func darken_image(image: Image, amt: float):
	if amt < 0:
		return

	var width: int = image.get_width()
	var height: int = image.get_height()

	for x in range(width):
		for y in range(height):
			var color := image.get_pixel(x, y)
			color.r -= amt
			color.g -= amt
			color.b -= amt

			if color.r <= 0.0: color.r = 0.0
			if color.g <= 0.0: color.g = 0.0
			if color.b <= 0.0: color.b = 0.0
			
			image.set_pixel(x, y, color)


# brightens an entire image
func brighten_image(image: Image, amt: float):
	if amt < 0:
		return

	var width: int = image.get_width()
	var height: int = image.get_height()

	for x in range(width):
		for y in range(height):
			var color := image.get_pixel(x, y)
			color.r += amt
			color.g += amt
			color.b += amt

			if color.r >= 1.0: color.r = 1.0
			if color.g >= 1.0: color.g = 1.0
			if color.b >= 1.0: color.b = 1.0
			
			image.set_pixel(x, y, color)

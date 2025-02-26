extends Control

@export var levels: Array[SceneDesriptors]

@onready var grid_container: GridContainer = $"CenterContainer/GridContainer"

var multiplayer_scene: PackedScene = preload("res://scenes/multiplayer.tscn")
var singleplayer_scene: PackedScene = preload("res://scenes/singleplayer.tscn")

var singleOrMultiplayer: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in levels:
		var new_button := TextureButton.new()

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
		edge_color.r = 0.8;
		edge_color.g = 0.8;
		edge_color.b = 0.8;
		edge_color.a = 1.0;

		add_edge(focused_texture, edge_color, 1)

		new_button.texture_normal   = ImageTexture.create_from_image(normal_texture)
		new_button.texture_pressed  = ImageTexture.create_from_image(pressed_texture)
		new_button.texture_hover    = ImageTexture.create_from_image(hover_texture)
		new_button.texture_disabled = ImageTexture.create_from_image(disabled_texture)
		new_button.texture_focused  = ImageTexture.create_from_image(focused_texture)

		var function: Callable = load_level.bind(level)
		new_button.pressed.connect(function)
			
		grid_container.add_child(new_button)


# load the new level with the proper scene type (mutiplayer or not)
func load_level(level: SceneDesriptors) -> void:
	if singleOrMultiplayer:
		get_tree().change_scene_to_packed(multiplayer_scene)
	else:
		get_tree().change_scene_to_packed(singleplayer_scene)
	print("loading level: " + level.name)
	# this works, but depending on how levels are designed, is might be required that the node2d, in this case named level, would have to be changed instead


# adds an edge of color, color, with width, border_width, to an image
func add_edge(image: Image, color: Color, border_width: int):
	var width: int = image.get_width()
	var height: int = image.get_height()

	for x in range(width):
		for y in range(height):
			if x < border_width or y < border_width or x > width - border_width or y == height - border_width:
				image.set_pixel(x, y, color)


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

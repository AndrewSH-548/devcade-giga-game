extends Control

@export var levels_list: Array[LevelInfo]
@onready var thumbnail_grid: GridContainer = $VerticalContainer/LevelDisplayMargins/LevelDisplayPanel/ThumbnailGrid
@onready var back_button: Button = $VerticalContainer/TopContainer/Back

const LEVEL_THUMBNAIL = preload("res://scenes/gui/level_thumbnail.tscn")
const COLUMN_AMOUNT = 3

var is_multiplayer: bool = false
var thumbnails: Array[Array]

func _ready() -> void:
	setup(false)

func setup(is_multiplayer_mode: bool):
	is_multiplayer = is_multiplayer_mode
	
	# Used to setup a 2D array of thumbnails
	var thumbnail_number: int = 0
	var current_array = []
	# Loop through level infos...
	for level in levels_list:
		thumbnail_number += 1
		var thumbnail: Button = LEVEL_THUMBNAIL.instantiate()
		thumbnail_grid.add_child(thumbnail)
		thumbnail.setup(level)
		current_array.append(thumbnail)
		if thumbnail_number % COLUMN_AMOUNT == 0 or thumbnail_number == levels_list.size():
			thumbnails.append(current_array)
			current_array = []
	print(thumbnails)
	# Setup controller navigation for the thumbnails
	setup_controller_navigation()

# Makes it so controllers can navigate through the menu
func setup_controller_navigation():
	
	# Stop here if there are no thumbnails
	if thumbnails.is_empty(): return
	
	# Connect back to the top thumbnail that is closest to the top
	back_button.focus_neighbor_bottom = thumbnails.get(0).get(int(thumbnails.get(0).size() / 2)).get_path()
	
	# Connect all the thumbnails to eachother in a sensible way
	for row: int in range(thumbnails.size()):
		for col: int in range(thumbnails.get(row).size()):
			
			var thumbnail: Control = thumbnails[row][col]
			# Connect to the above thumbnail, and if on the top, connect to the "back" button
			if row == 0: thumbnail.focus_neighbor_top = back_button.get_path()
			else: thumbnail.focus_neighbor_top = thumbnails.get(row - 1).get(col).get_path()
			# Connect to the below thumbnail, if it exists, and if not at the bottom
			if (row != thumbnails.size() - 1) and thumbnails.get(row + 1).get(col) != null:
				thumbnail.focus_neighbor_bottom = thumbnails.get(row + 1).get(col).get_path()
			# Connect to the right and left thumbnails, and wrap around the sides
			thumbnail.focus_neighbor_left = thumbnails.get(row).get(wrapi(col - 1, 0, thumbnails.get(row).size())).get_path()
			thumbnail.focus_neighbor_right = thumbnails.get(row).get(wrapi(col + 1, 0, thumbnails.get(row).size())).get_path()

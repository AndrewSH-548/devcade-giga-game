extends Control

@export var levels_list: Array[LevelInfo]
@onready var thumbnail_grid: GridContainer = $VerticalContainer/LevelDisplayMargins/LevelDisplayPanel/ThumbnailGrid
@onready var back_button: Button = $VerticalContainer/TopContainer/Back
@onready var nav_left_button: Button = $VerticalContainer/ArrowContainer/NavBoxes/NavLeft
@onready var nav_right_button: Button = $VerticalContainer/ArrowContainer/NavBoxes/NavRight

const LEVEL_THUMBNAIL = preload("res://scenes/gui/level_thumbnail.tscn")

var is_multiplayer: bool = false
var pages: Array[Page]
var current_page_index: int = 0

class Page:
	
	var thumbnails: Array[Array] = [[]]
	
	const COLUMN_AMOUNT = 3
	const ROW_AMOUNT = 3
	
	var back_button_node: Button
	
	func _init(back_button: Button):
		back_button_node = back_button
	
	func add(thumbnail: Control) -> void:
		# Don't allow a null thumbnail to be added
		assert(thumbnail != null, "Cannot add to null thumbnail to a page!")
		# Don't let a thumbnail be added to a full page
		assert(not is_full(), "Cannot add to a thumbnail to a full page!")
		var current_row: Array = thumbnails.get(thumbnails.size() - 1)
		# Move to a new row when the current is full
		if current_row.size() == COLUMN_AMOUNT:
			current_row = []
			thumbnails.append(current_row)
		# Add thumbnail to the current row
		current_row.append(thumbnail)
	
	func is_full() -> bool:
		return (thumbnails.size() == ROW_AMOUNT and thumbnails.get(ROW_AMOUNT - 1).size() == COLUMN_AMOUNT)
	
	func set_visible(is_visible: bool):
		for row in thumbnails:
			for thumbnail: Control in row:
				thumbnail.visible = is_visible
	
	# Allows controllers to navigate through the thumbnails
	func interconnect():
		# Stop here if there are no thumbnails
		if thumbnails.is_empty(): return
		
		# Connect back to the top thumbnail that is closest to the top
		back_button_node.focus_neighbor_bottom = thumbnails.get(0).get(int(thumbnails.get(0).size() / 2)).get_path()
		
		# Connect all the thumbnails to eachother in a sensible way
		for row: int in range(thumbnails.size()):
			for col: int in range(thumbnails.get(row).size()):
				
				var thumbnail: Control = thumbnails[row][col]
				# Connect to the above thumbnail, and if on the top, connect to the "back" button
				if row == 0: thumbnail.focus_neighbor_top = back_button_node.get_path()
				else: thumbnail.focus_neighbor_top = thumbnails.get(row - 1).get(col).get_path()
				# Connect to the below thumbnail, if it exists, and if not at the bottom
				if (row != thumbnails.size() - 1) and thumbnails.get(row + 1).get(col) != null:
					thumbnail.focus_neighbor_bottom = thumbnails.get(row + 1).get(col).get_path()
				# Connect to the right and left thumbnails, and wrap around the sides
				thumbnail.focus_neighbor_left = thumbnails.get(row).get(wrapi(col - 1, 0, thumbnails.get(row).size())).get_path()
				thumbnail.focus_neighbor_right = thumbnails.get(row).get(wrapi(col + 1, 0, thumbnails.get(row).size())).get_path()

func _ready() -> void:
	setup(false)

# Makes the level thumbnails and connects their varaious functions
func setup(is_multiplayer_mode: bool):
	is_multiplayer = is_multiplayer_mode
	
	var current_page: Page = Page.new(back_button)
	pages.append(current_page)
	
	# Loop through level infos...
	for level in levels_list:
		# Move to a new page when the current is full
		if current_page.is_full():
			current_page = Page.new(back_button)
			pages.append(current_page)
		# Setup thumbnai
		var thumbnail: Button = LEVEL_THUMBNAIL.instantiate()
		thumbnail_grid.add_child(thumbnail)
		thumbnail.visible = false
		thumbnail.setup(level)
		# Add thumbnail to page
		current_page.add(thumbnail)
	
	# Setup navigation for each page
	for page: Page in pages:
		page.interconnect()
	
	# Disable the nav buttons if there is only one page
	if pages.size() == 1:
		nav_left_button.disabled = true
		nav_right_button.disabled = true
	
	# Set current page to visible
	pages[0].set_visible(true)

func navigate(navigation_amount: int):
	# Hide the current page
	pages[current_page_index].set_visible(false)
	# Move to the next page according to navigations amount.
	# Navigation Amount should normally be -1 or 1, but can also be more
	# Nav Amount wraps around to always be inside the pages array
	current_page_index = wrap(current_page_index + navigation_amount, 0, pages.size())
	# Set the new page to visible
	pages[current_page_index].set_visible(true)

# Navigates 1 left (-1). Used by NavLeft button
func nav_left():
	navigate(-1)

# Navigate 1 right (+1). Used by NavRight button
func nav_right():
	navigate(+1)

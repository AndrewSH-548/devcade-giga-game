extends Control
class_name LevelSelect

@export var levels_list: Array[LevelInfo]
@onready var thumbnail_grid: GridContainer = $VerticalContainer/LevelDisplayMargins/LevelDisplayPanel/ThumbnailGrid
@onready var back_button: Button = $VerticalContainer/TopContainer/Back
@onready var nav_left_button: Button = $VerticalContainer/ArrowContainer/NavBoxes/NavLeft
@onready var nav_right_button: Button = $VerticalContainer/ArrowContainer/NavBoxes/NavRight

const LEVEL_THUMBNAIL = preload("res://scenes/gui/level_thumbnail.tscn")
const CHARACTER_SELECT = preload("uid://bypgh8vwm65r6")

var is_multiplayer: bool = false
var pages: Array[Page]
var current_page_index: int = 0

# ------------- HOW TO ADD A LEVEL --------------
#
# 1: Open level_select scene
# 2: Click on the root node (LevelSelect)
# 3: In the INSPECTOR, click on the Array[LevelInfo](size xx) thing, IF IT IS COLLAPSED
# 4: Click "Add Element"
# 5: In the new EMPTY element, click the down arrow, then "New LevelInfo"
# 6: Click on the new LevelInfo, then add the SCENE, NAME, and BORDER COLOR to the LevelInfo

# ---------- HOW TO ADD A THUMBNAIL -------------
#
# 1: Add ThumbnailMarker scene as child of the LEVEL (found in scenes/editor)
# 2: Align the "box" with where you want the thumbnail to START
# 3: Add ThumbnailDestination scene add child of the LEVEL
# 4: Align the "box" with where you want the thumnail movement to END

# Loads the level in level_info and switches scenes to it
func load_level(level_info: LevelInfo):
	# Create a new SessionInfo to store the current level, and other settings
	var session_info: SessionInfo = SessionInfo.new()
	session_info.level_info = level_info
	session_info.is_multiplayer = is_multiplayer
	# Instantiate the Character Select
	var character_select: CharacterSelect = CHARACTER_SELECT.instantiate()
	# Give the Character Select the SessionInfo, then add it to the tree
	get_tree().root.add_child(character_select)
	character_select.setup(session_info)
	# Delete Level Select Scene (self)
	queue_free()

# Holds the thumbnails for a single page,
# as well as provides methods for constructing itself
class Page:
	
	var thumbnails: Array[Array] = [[]]
	# Please change these if you change the thumbnails!!!
	const COLUMN_AMOUNT = 3
	const ROW_AMOUNT = 3
	
	var back_button_node: Button
	
	func _init(back_button: Button) -> void:
		back_button_node = back_button
	
	# Adds a thumbnail to the page
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
	
	# Returns true if the page cannot hold any mroe thumbnails
	# This is dictated by ROW_AMOUNT and COLUMN_AMOUNT
	func is_full() -> bool:
		return (thumbnails.size() == ROW_AMOUNT and thumbnails.get(ROW_AMOUNT - 1).size() == COLUMN_AMOUNT)
	
	# Makes buttons visible and active or invisible and inactive, depending on is_visible
	func set_visible(is_visible: bool) -> void:
		connect_back()
		for row in thumbnails:
			for thumbnail: Button in row:
				thumbnail.visible = is_visible
				thumbnail.disabled = not is_visible
	
	# Connects this page to the "back" button, for controller navigation
	# This should be called whenever the page changes, as the back_button's
	# Connection should be to the current page
	func connect_back() -> void:
		# Connect back to the top thumbnail that is closest to the top
		var top_row: Array = thumbnails.get(0)
		back_button_node.focus_neighbor_bottom = top_row.get(int(top_row.size() / 2)).get_path()
	
	# Allows controllers to navigate through the thumbnails
	# This should be called AFTER the all of the thumbnails are added
	func interconnect() -> void:
		# Stop here if there are no thumbnails
		if thumbnails.is_empty(): return
		
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
	
	func focus_middle() -> void:
		var middle_row: Array = thumbnails.get(int(thumbnails.size() / 2))
		var middle_thumbnail: Control = middle_row.get(int(middle_row.size() / 2))
		middle_thumbnail.grab_focus()

func _ready() -> void:
	setup()

# Makes the level thumbnails and connects their varaious functions
func setup():
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
		thumbnail.disabled = true
		thumbnail.pressed.connect(load_level.bind(level))
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
	
	# Set current page to visible and focus middle thumbnail
	pages[0].set_visible(true)
	pages[0].focus_middle()

# Moves forward / backward pages by navigation_amount
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

func _input(event: InputEvent) -> void:
	# Allow the player to press cancel to go back to the start
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("p2_cancel"):
		load_start_screen()

func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

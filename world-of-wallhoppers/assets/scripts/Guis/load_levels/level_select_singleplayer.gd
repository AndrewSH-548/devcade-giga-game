extends Control 

@export var levels: Array[SceneDesriptors]

@export var grid_container: GridContainer

var isMultiplayer: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelsLoader.create_buttons(grid_container, levels, load_level)


# load the new level within the single player scene
func load_level(level: SceneDesriptors) -> void:
	print("loading level: " + level.name)
	
	var level_root_node = level.scene.instantiate()
	SceneSwitcher.switch_scene(level_root_node)

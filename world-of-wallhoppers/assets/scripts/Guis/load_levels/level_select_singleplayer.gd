extends Control 

@export var grid_container: GridContainer

@export var singleplayer_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scenes := LevelsLoader.get_scenes_descriptions()

	LevelsLoader.create_buttons(grid_container, scenes, load_level)


# load the new level within the single player scene
func load_level(level: SceneDesriptors) -> void:
	var level_root_node = level.scene.instantiate() as Node2D
	level_root_node.position = Vector2(132.0, 297.0)
	
	var singleplayer_scene_instance = singleplayer_scene.instantiate()
	var sub_veiwport = singleplayer_scene_instance.get_child(0).get_child(0)
	sub_veiwport.add_child(level_root_node)
	
	SceneSwitcher.switch_scene(singleplayer_scene_instance)

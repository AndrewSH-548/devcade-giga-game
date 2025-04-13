# singleton scene switcher
extends Node

var last_scene : Node = null
var current_scene : Node = null

func _ready() -> void:
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func switch_scene_packed(packed_scene: PackedScene) -> void:
	var scene = packed_scene.instantiate()
	switch_scene(scene)
	
	
func switch_scene_file(scene_path: String) -> void:
	var packed_scene = load(scene_path)
	var scene = packed_scene.instantiate()
	switch_scene(scene)


func switch_scene(scene: Node) -> void:
	call_deferred("_switch_scene_deferred", scene)


func load_last_scene() -> void:
	_load_last_scene_deferred()


func _load_last_scene_deferred() -> void:
	var temp = last_scene
	last_scene = current_scene
	current_scene = temp
	
	get_tree().root.remove_child(last_scene)
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene


func _switch_scene_deferred(new_scene: Node) -> void:
	if last_scene != null:
		last_scene.free()
	last_scene = current_scene

	current_scene = new_scene
	
	get_tree().root.remove_child(last_scene)
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

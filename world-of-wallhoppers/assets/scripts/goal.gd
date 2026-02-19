extends Node
## add any node to the goals array and this script will find attached area2ds and connect to their area_entered signal,
## it is better to just enter the area2d itself, but this is easier i think

## one parameter: the player number (an integer)
var game_finish: Signal

@export var player_1_hitbox: Area2D
@export var player_2_hitbox: Area2D

@export var goals: Array[Node]
var goal_areas: Array[Area2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# find all the Area2D nodes within the nodes in the goals array
	for node in goals:
		goal_areas += get_area_2ds(node)

	for i in range(len(goal_areas)):
		goal_areas[i].area_entered.connect(on_area_enter)


## When one of the player(s) hits the goal, the game should end. [br]
## This function handles the emitition of the signal of that [br]
## parameter [b]player_number[/b]: the player number that hit/entered a goal area
func end_game(player_number: int) -> void:
	game_finish.emit(player_number)
	# TODO: add implientation code so that the game ends and reports nessisary data in the future
	get_tree().change_scene_to_file("res://scenes/win_scene.tscn"); 

## If one of the areas contained in {goal_areas} is entered by another area, [br]
## This function is called, with the area that caused the signal to be emited [br]
## parameter [b]area[/b]: the area that caused the signal to be emited  
func on_area_enter(area: Area2D) -> void:
	if area == player_1_hitbox:
		end_game(1)
	if area == player_2_hitbox:
		end_game(2)


## Find and return all the Area2D child nodes of the [b]object[/b] parameter (including the object itself)
func get_area_2ds(object: Node) -> Array[Area2D]:
	var areas: Array[Area2D] = []
	var children: Array[Node] = object.get_children()
	
	if object.is_class("Area2D"):
		areas.append(object)

	for child in children:
		areas += get_area_2ds(child)

	return areas

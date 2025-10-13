@abstract
extends Node2D
class_name TutorialPart

@warning_ignore("unused_signal")
signal finished

var is_finished: bool = false
var updating: bool = false
var fade_timer: Timer

func update(_delta: float):
	pass

func fade():
	fade_timer = Timer.new()
	add_child(fade_timer)

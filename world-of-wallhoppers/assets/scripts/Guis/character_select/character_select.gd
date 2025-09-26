extends Control

@export var characters: Array[CharacterPortraitInfo]
@onready var character_wheel: Control = $MainVertical/CharacterWheel
const CHARACTER_PORTRAIT = preload("uid://br12fqlynos76")

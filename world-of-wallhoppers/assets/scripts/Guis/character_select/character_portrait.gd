extends Button
class_name CharacterPortrait

@onready var element_icon: TextureRect = $PanelContainer/MainMargins/Vertical/ImageAspectKeeper/CharacterClipper/ElementIcon
@onready var portrait_image: TextureRect = $PanelContainer/MainMargins/Vertical/ImageAspectKeeper/CharacterClipper/CharacterMargins/PortraitImage
@onready var character_name: Label = $PanelContainer/MainMargins/Vertical/NamePanel/Name

var self_index: int = 0
# In Radians (0 -> TAU or 2PI)
var rotation_position: float = 0

func setup(info: CharacterPortraitInfo) -> void:
	element_icon.texture = info.element_sprite
	portrait_image.texture = info.portrait_sprite
	character_name.text = info.character_name

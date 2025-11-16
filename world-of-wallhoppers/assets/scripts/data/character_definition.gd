extends Resource
class_name CharacterDef

var name: StringName
var scene: PackedScene
var dial_position: DialPosition

enum DialPosition {
	TOP,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

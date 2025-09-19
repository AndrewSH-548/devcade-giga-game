extends MainLevelHeader

func place_level(level: Node2D) -> void:
	$ViewportContainerP1/SubViewport.add_child(level)

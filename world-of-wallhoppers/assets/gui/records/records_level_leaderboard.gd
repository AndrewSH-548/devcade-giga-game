extends Control
class_name RecordsLevelLeaderboard

@onready var title: Label = $Vertical/Title
@onready var records: VBoxContainer = $Vertical/Scroll/Records
@onready var scroll: ScrollContainer = $Vertical/Scroll

func setup(level: LevelDefinition):
	TimeManager.load_leaderboards_from_disk()
	title.text = "<    " + level.name + "    >"
	
	var board: LevelLeaderboard = TimeManager.leaderboards[level.name]
	var count: int = 0
	
	for record in board.best_records:
		count += 1
		var display: SingleRecordDispay = LevelLeaderboard.SINGLE_RECORD_DISPLAY.instantiate()
		records.add_child(display)
		
		var spacer: Control = HSeparator.new()
		records.add_child(spacer)
		spacer.modulate.a = 0.0
		spacer.custom_minimum_size.y = 12.0
		
		display.setup(record, count)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		scroll.scroll_vertical -= 24
	if Input.is_action_pressed("ui_down"):
		scroll.scroll_vertical += 24

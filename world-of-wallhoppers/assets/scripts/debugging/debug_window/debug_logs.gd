extends Control

@onready var refresh: Button = $LogVBox/LogButtonsMargin/LogButtonHBox/Refresh

@onready var log_text: RichTextLabel = $LogVBox/LogMargins/LogText

var scroll_speed: float = 10.0

func _ready() -> void:
	refresh.pressed.connect(refresh_log)
	refresh_log.call_deferred()

func refresh_log() -> void:
	var log_file: FileAccess = FileAccess.open("user://logs/godot.log", FileAccess.READ)
	if log_file == null:
		log_text.text = "Could not load logs"
		return
	log_text.text = log_file.get_as_text()
	log_file.close()
	highlight()

func highlight() -> void:
	log_text.text = highlight_word(log_text.text, "ERROR", Color(1.0, 0.339, 0.273, 1.0))
	log_text.text = highlight_word(log_text.text, "WARNING", Color.ORANGE)
	
	log_text.text = highligh_between(log_text.text, '"', '"', Color.WHEAT)

func highlight_word(text: String, word: String, color: Color) -> String:
	var i: int = 0
	var cycles: int = 0
	while i < text.length():
		cycles += 1
		if cycles > 10000:
			break
		if text[i] == word[0]:
			if text.substr(i, word.length()) == word:
				var addition: String = "[color=" + color.to_html(false) + "]" + word + "[/color]"
				text = text.substr(0, i) + addition + text.substr(i + word.length())
				i += addition.length()
		i += 1
	return text

func highligh_between(text: String, start: String, end: String, color: Color) -> String:
	var highlighting: bool = false
	var i: int = 0
	while i < text.length():
		
		if text[i] == start[0] and not highlighting:
			var addition: String = "[color=" + color.to_html() + "]"
			text = text.insert(i, addition)
			i += addition.length()
			highlighting = true
		elif text[i] == end[0] and highlighting:
			var addition: String = "[/color]"
			text = text.insert(i, addition)
			i += addition.length()
			highlighting = false
		
		i += 1
	
	return text

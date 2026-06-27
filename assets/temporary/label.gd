@tool
extends Label

@export var min_font_size: int = 8
@export var max_font_size: int = 14

func _ready():
	# Prevent the label from expanding to fit text
	size_flags_horizontal = SIZE_SHRINK_END
	clip_text = true
	autowrap_mode = TextServer.AUTOWRAP_OFF
	resized.connect(_fit_text)
	#text_changed.connect(_fit_text)  # if text changes at runtime

func _fit_text():
	var available_width = 54
	var available_height = 10

	# Guard: if size isn't set yet, wait
	if available_width <= 0 or available_height <= 0:
		await get_tree().process_frame
		_fit_text()
		return

	var font = get_theme_font("font")
	var font_size = max_font_size

	while font_size > min_font_size:
		var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		if text_size.x <= available_width and text_size.y <= available_height:
			break
		font_size -= 1

	add_theme_font_size_override("font_size", font_size)

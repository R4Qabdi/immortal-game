extends CanvasLayer

func _input(event: InputEvent) -> void:
	var is_mouse_click = event is InputEventMouseButton and event.pressed
	var is_key_press = event is InputEventKey and event.pressed
	
	if is_mouse_click or is_key_press:
		change_scene()

func _ready() -> void:
	$valorant.play("lit")
	await wait(0.25)
	$valorant.play("loop")
	await wait(1)
	$valorant.play("washed")
	await wait(0.583)
	
	change_scene()
func change_scene():
	tween_fade_modulate()
	await wait(0.25)
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func tween_fade_modulate():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($fade,"modulate:a", 1.0,0.2)
	

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

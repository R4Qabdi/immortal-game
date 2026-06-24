extends Control
var viewport_size

func _ready() -> void:
	viewport_size = get_viewport_rect()
	print("viewport siz :: "+str(viewport_size))
	print("viewport transform:::"+str(get_global_rect()))
	#play the songs, load settings, and load the fucking assets, also load the save files
	print(DisplayServer.get_display_safe_area())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_pressed() -> void:
	$animp.play("option")

func _on_backoption_pressed() -> void:
	$animp.play_backwards("option")

func _on_credit_pressed() -> void:
	$animp.play("credit")

func _on_backcredit_pressed() -> void:
	$animp.play_backwards("credit")

func _on_exit_pressed() -> void:
	$animp.play("sure")

func _on_no_pressed() -> void:
	$animp.play_backwards("sure")

func _on_yes_pressed() -> void:
	get_tree().quit()

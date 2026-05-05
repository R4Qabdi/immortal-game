extends Control

@export var masterSlider: HSlider
@export var musicSlider: HSlider
@export var sfxSlider: HSlider
var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

func _ready() -> void:
	readyAudioSliders()
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
	

func readyAudioSliders() -> void:
	masterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	musicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfxSlider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))

func _on_temp_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(value)
	)

func _on_temp_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value)
	)

func _on_temp_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value)
	)

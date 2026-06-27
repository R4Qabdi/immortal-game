extends Control
var viewport_size
@onready var transition = %transition

func _ready() -> void:
	%audioplayer.stream=preload("res://assets/audio/music/rynos-theme.ogg")
	%audioplayer.play()
	viewport_size = get_viewport_rect()
	print("viewport siz :: "+str(viewport_size))
	print("viewport transform:::"+str(get_global_rect()))
	#play the songs, load settings, and load the fucking assets, also load the save files
	print(DisplayServer.get_display_safe_area())

func _on_option_pressed() -> void:
	$optionpanel.visible = true

func _on_backoption_pressed() -> void:
	$optionpanel.visible = false

func _on_credit_pressed() -> void:
	$creditspanel.visible = true

func _on_backcredit_pressed() -> void:
	$creditspanel.visible = false

func _on_exit_pressed() -> void:
	$sure.visible = true

func _on_no_pressed() -> void:
	$sure.visible = false

func _on_library_pressed() -> void:
	$librarypanel.visible = true

func _on_backlibrary_pressed() -> void:
	$librarypanel.visible = false

func _on_start_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/game/arena.tscn")
	var arena:PackedScene = preload("res://scenes/game/arena.tscn")
	transition.change_current_scene_to(self, arena)

func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_sfxv_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)

func _on_musicv_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)

func _on_masterv_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

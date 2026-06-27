extends Control

const settings_path = "user://settings.save"
var settings : Dictionary = {
	"masterv" = 1.0,
	"musicv" = 1.0,
	"sfxv" = 1.0,
}

func _ready() -> void:
	load_settings()

func load_settings() -> void :
	read_settings()

func read_settings() ->void:
	if FileAccess.file_exists(settings_path):
		var file = FileAccess.open(settings_path, FileAccess.READ)
		settings = file.get_var()
		file.close()

func write_settings() : 
	var file = FileAccess.open(settings_path, FileAccess.WRITE)
	file.store_var(settings)
	file.close()

func _on_masterv_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
	settings["masterv"] = value
	write_settings()

func _on_musicv_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)
	settings["musicv"] = value
	write_settings()

func _on_sfxv_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)
	settings["sfxv"] = value
	write_settings()

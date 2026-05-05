extends Control


func _ready() -> void:
	
	#play the songs, load settings, and load the fucking assets, also load the save files
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_pressed() -> void:
	$animp.play("option")

func _on_backoption_pressed() -> void:
	$animp.play_backwards("option")

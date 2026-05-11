extends Node2D

@onready var king = preload("res://scenes/piece.tscn")

func _ready() -> void:
	await wait(2.5)
	var origin_square = get_node_or_null("../squares/e1").position
	var newking = king.instantiate()
	add_child(newking)
	newking.position = origin_square

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

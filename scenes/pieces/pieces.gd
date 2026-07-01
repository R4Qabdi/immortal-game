extends Node2D
class_name Pieces

@onready var piece = preload("res://scenes/pieces/piece.tscn")
@onready var squares = $"../squares"
@onready var inputsystem = $"../inputsystem"

var matrix_pieces: Array = []
var wave_count :int = 1

var enemy_spawn_square:Array[String]=[]
var enemy_onboard :Array[Piece]=[] 
var enemy_move_count :int = 1

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		# ini khusus buat debug ajaqq
		if event.keycode == KEY_Q:
			print(matrix_pieces)

func _ready() -> void:
	randomize()
	
	await wait(2)
	enemy_spawn_square = [
		squares.get_node_or_null("a7").name,
		squares.get_node_or_null("b7").name,
		squares.get_node_or_null("c7").name,
		squares.get_node_or_null("d7").name,
		squares.get_node_or_null("e7").name,
		squares.get_node_or_null("f7").name,
		squares.get_node_or_null("g7").name,
		squares.get_node_or_null("h7").name,
		squares.get_node_or_null("h8").name,
		squares.get_node_or_null("g8").name,
		squares.get_node_or_null("f8").name,
		squares.get_node_or_null("e8").name,
		squares.get_node_or_null("d8").name,
		squares.get_node_or_null("c8").name,
		squares.get_node_or_null("b8").name,
		squares.get_node_or_null("a8").name,
	]
	setup_initial_pieces()
	global.piece_requested.connect(_on_piece_requested)

func setup_initial_pieces():
	var layout = {
		"e1": "king",
		"c2": "pawn"
	}
	
	for tile_name in layout:
		var origin_tile = squares.get_node_or_null(tile_name)
		if origin_tile:
			add_piece(layout[tile_name], origin_tile, false)
			await wait(0.05)
	
	var enemy_layout :Dictionary = get_enemy_by_wave()
	print(enemy_layout)
		#get_enemy_by_wave(wave)
	for tile_name in enemy_layout:
		var origin_tile = squares.get_node_or_null(tile_name)
		if origin_tile:
			add_piece(enemy_layout[tile_name], origin_tile, true)
			await wait(0.05)
	update_matrix()

func update_matrix():
	matrix_pieces.clear()
	var board_node = squares
	if not board_node:
		return
		
	var index: int = 0
	for i in board_node.matrix_board:
		matrix_pieces.append([])
		for j in i:
			matrix_pieces[index].append(j.piece)
		index += 1

func add_piece(type: String, which_square: Square, is_enemy: bool):
	var newpiece: Piece = piece.instantiate()
	add_child(newpiece)
	newpiece.name = type
	newpiece.type = type
	which_square.piece = newpiece
	newpiece.current_square = which_square
	newpiece.is_enemy = is_enemy
	if is_enemy:
		enemy_onboard.append(newpiece)
	newpiece.global_position = which_square.global_position

func get_enemy_by_wave() -> Dictionary:
	var available_square = enemy_spawn_square
	var enemies : Dictionary = {}
	if wave_count < 4:
		available_square.pop_back()
		available_square.pop_back()
		available_square.pop_front()
		available_square.pop_front()
		for i in range(wave_count + 2):
			var enemy : Dictionary = {available_square.pop_at(randi_range(0,available_square.size()-1)) : "pawn"}
			enemies.merge(enemy)
	return enemies

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _on_piece_requested(type: String, which_square: Square, is_enemy: bool):
	add_piece(type, which_square, is_enemy)
	update_matrix()
	global.piece_added.emit(type, which_square, is_enemy)

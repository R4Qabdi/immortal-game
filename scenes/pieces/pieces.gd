extends Node2D
class_name Pieces

@onready var piece = preload("res://scenes/pieces/piece.tscn")
@onready var squares = $"../squares"
var matrix_pieces: Array = []

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		# ini khusus buat debug ajaqq
		if event.keycode == KEY_Q:
			print(matrix_pieces)
		

func _ready() -> void:
	
	await wait(1.5)
	setup_initial_pieces()
	global.piece_requested.connect(_on_piece_requested)

func setup_initial_pieces():
	var layout = {
		"e1": "king", "d1": "queen", "c1": "bishop", "f1": "bishop",
		"b1": "knight", "g1": "knight", "a1": "rook", "h1": "rook",
		"a2": "pawn", "b2": "pawn", "c2": "pawn", "d2": "pawn",
		"e2": "pawn", "f2": "pawn", "g2": "pawn", "h2": "pawn", "e3": "pawn"
	}
	
	for tile_name in layout:
		var origin_tile = squares.get_node_or_null(tile_name)
		if origin_tile:
			add_piece(layout[tile_name], origin_tile, false)
			await wait(0.05)
	var enemy_layout = {
		"a7" : "pawn", 
		"b4" : "pawn", 
		"c3" : "pawn"
	}
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
	newpiece.current_square = which_square
	newpiece.is_enemy = is_enemy
	which_square.piece = newpiece
	newpiece.global_position = which_square.global_position

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _on_piece_requested(type: String, which_square: Square, is_enemy: bool):
	add_piece(type, which_square, is_enemy)
	update_matrix()
	global.piece_added.emit(type, which_square, is_enemy)

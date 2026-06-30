extends Node2D

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

func random_enemy_move():
	await wait(0.5)
	execute_enemy_turn(enemy_move_count)

func execute_enemy_turn(number_of_moves: int):
	var moves_left = number_of_moves
	
	# CRITICAL: Track which specific pieces have already moved this turn
	var moved_pieces_this_turn: Array = [] 
	
	while moves_left > 0:
		var all_legal_moves: Array = []
		
		# 1. Recalculate legal moves based on the current board state
		for piece in enemy_onboard:
			if is_instance_valid(piece):
				
				# EXCEPTION: If the piece already moved this turn, skip it entirely
				if piece in moved_pieces_this_turn:
					continue
					
				var valid_squares: Array[Square] = piece.check_valid_square()
				for square in valid_squares:
					all_legal_moves.append([piece, square])
		
		# 2. Break early if no UNMOVED pieces have any legal moves left
		if all_legal_moves.is_empty():
			print("Enemy has no more valid moves available for its remaining pieces.")
			break
			
		# 3. Pick and execute ONE random move from an unmoved piece
		var chosen_move = all_legal_moves.pick_random()
		var piece_to_move = chosen_move[0]
		var target_square = chosen_move[1]
		
		# 4. Lock this piece down so it cannot be picked again for the rest of this loop
		moved_pieces_this_turn.append(piece_to_move)
		
		resolve_move(piece_to_move, target_square)
		
		# 5. Wait for the visual movement to complete
		if piece_to_move.has_signal("movement_finished"):
			await piece_to_move.movement_finished
		else:
			await get_tree().create_timer(0.4).timeout 
		
		moves_left -= 1
	
	# 6. Turn over. The tracking array naturally empties when the function ends.
	inputsystem.is_yourturn = true
	print("Player's turn!")

func resolve_move(selected_piece: Piece, target: Square) -> void:
	var square_lama = selected_piece.current_square
	
	selected_piece.movecount += 1
	selected_piece.current_square = target
	selected_piece.is_dragging = false
	
	# Trigger movement/capture logic
	selected_piece.dropping(square_lama, target) 
	inputsystem.is_yourturn = true
	
	# Update your underlying board data representation
	update_matrix()

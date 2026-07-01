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
	InventoryInstructions._unit_pieces_requested.connect(_on_unit_pieces_requested)

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

func add_piece(type: String, which_square: Square, is_enemy: bool, unitPiece: global.UnitCardPieces = null):
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
	#if unitPiece != null:
		#var unitFunc: Callable = unitPiece.pieceAddFunc
		#unitFunc.call(newpiece)
	var unitFunc: Callable = global.addUnitBoss
	unitFunc.call(newpiece)

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

func _on_unit_pieces_requested(squares: Array[Square], unitCard: global.unitCards, is_enemy: bool):
	var unitCardPieces: Array[global.UnitCardPieces] = global.unitCardsData[unitCard].pieces
	if unitCardPieces.size() != squares.size():
		print_debug("Error: Mismatch between number of squares and unit pieces data.")
		return
	for i in range(unitCardPieces.size()): # each square corresponds to a piece in the unitCardPieces array
		var unitPiece = unitCardPieces[i]
		var square = squares[i]
		var typeString = global.piecesData[unitPiece.pieceType].name
		add_piece(typeString, square, is_enemy, unitPiece)

#inputsystem.gd
extends Node2D

@onready var piece_manager = $"../pieces"

#piece inputs
var previous_square : Square
var current_square : Square
var selected_piece : Piece
var press_pos : Vector2
var is_dragging : bool
var piece_was_just_selected : bool = false 

#gamerule general
var wave_count:int = 1
var moves:int = 1
var is_yourturn : bool = true

var overheat_moves : Array[Square]

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and is_yourturn:
			_on_press(event.position)
		else:
			_on_release(event.position)
	elif event is InputEventScreenDrag and is_yourturn:
		_on_drag(event.position)

func _on_press(pos: Vector2) -> void:
	is_dragging = false
	piece_was_just_selected = false
	press_pos = pos 
	check_square(pos)
	
	# Handle selections right when the finger hits the screen
	if current_square and current_square.piece and not current_square.piece.is_enemy:
		
		# 1. Tapping a DIFFERENT friendly piece? Clear the old selection first.
		if selected_piece and selected_piece != current_square.piece:
			selected_piece.select_toggle()
			selected_piece.update_show_valid_moves()
			selected_piece = null
		
		# 2. Select the piece under the finger
		if not selected_piece:
			selected_piece = current_square.piece
			selected_piece.check_valid_square() 
			selected_piece.select_toggle()
			selected_piece.update_show_valid_moves()
			piece_was_just_selected = true # Flagged so _on_release knows it's a brand new selection

func _on_drag(pos: Vector2) -> void:
	if not selected_piece:
		return
	
	if not is_dragging and press_pos.distance_to(pos) > 10.0:
		is_dragging = true
	
	if is_dragging:
		selected_piece.dragging()
		selected_piece.update_show_valid_moves()

func _on_release(pos: Vector2) -> void:
	check_square(pos)
	if not selected_piece:
		return
		
	# 3. THE SAME SQUARE RULE (Your Tap-To-Move Trigger)
	# Triggers if the piece is cleanly tapped OR dragged and dropped back on its home square
	if current_square == selected_piece.current_square:
		selected_piece.reset() # Snaps texture back to normal grid space if it was being dragged
		
		# If it's a clean tap, but NOT the first selection tap, it acts as a manual toggle-deselect
		if not piece_was_just_selected and not is_dragging:
			selected_piece.select_toggle()
			selected_piece.update_show_valid_moves()
			selected_piece = null
			
		is_dragging = false
		return
	
	# 4. Moving to ANY other square (Empty, Enemy, or Out of bounds)
	resolve_move(current_square)

func resolve_move(target : Square) -> void:
	is_dragging = false
	if not selected_piece: 
		return
	
	var square_lama = selected_piece.current_square 
	var square_baru = target
	
	var is_blocked_by_friendly = square_baru and square_baru.piece and not square_baru.piece.is_enemy
	
	# If the target is out of bounds, blocked by teammates, or an illegal rule move:
	if not square_baru or is_blocked_by_friendly or not _attempt_move(selected_piece, square_baru):
		selected_piece.reset()
		selected_piece.select_toggle()
		selected_piece.update_show_valid_moves()
		selected_piece = null
	else:
		# Valid move execution path
		is_yourturn = false
		selected_piece.movecount += 1
		selected_piece.current_square = square_baru
		square_lama.piece = null
		square_baru.piece = selected_piece
		
		selected_piece.is_dragging = false
		selected_piece.dropping(square_lama, square_baru)
		
		piece_manager.random_enemy_move()
		
		if piece_manager:
			piece_manager.update_matrix()
			
		selected_piece = null
		
	current_square = null

func check_square(pos: Vector2) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collision_mask = 0b1
	var results = space_state.intersect_point(query)
	if results.size() > 0:
		current_square = results[0]["collider"].get_parent()
	else:
		current_square = null

func _attempt_move(piece: Piece, to: Square) -> bool:
	if not piece:
		return false
	var valid_squares = piece.check_valid_square()
	return valid_squares.has(to)

func push_overheat_moves(move: Square) -> void:
	if overheat_moves.size() < 5:
		overheat_moves.append(move)

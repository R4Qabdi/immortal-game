extends Node2D

@onready var piece = preload("res://scenes/piece.tscn")
var matrix_pieces : Array = []
#ingfo tentang matrix
# 0 = kosong
# 1 = raja 
# 2 = pion
# 3 = kuda
# 4 = peluncur
# 5 = benteng
# 6 = ratu
# enemy pieces itu dalam bentuk negatif

func _ready() -> void:
	await wait(1.5)
	var origin_tile = get_node_or_null("../squares/e1")
	if origin_tile:
		add_piece("king", origin_tile, false)
	origin_tile = get_node_or_null("../squares/d1")
	if origin_tile:
		add_piece("queen", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/c1")
	if origin_tile:
		add_piece("bishop", origin_tile, false)
	origin_tile = get_node_or_null("../squares/f1")
	if origin_tile:
		add_piece("bishop", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/b1")
	if origin_tile:
		add_piece("knight", origin_tile, false)
	origin_tile = get_node_or_null("../squares/g1")
	if origin_tile:
		add_piece("knight", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/a1")
	if origin_tile:
		add_piece("rook", origin_tile, false)
	origin_tile = get_node_or_null("../squares/h1")
	if origin_tile:
		add_piece("rook", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/e2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	origin_tile = get_node_or_null("../squares/d2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/c2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	origin_tile = get_node_or_null("../squares/f2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/b2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	origin_tile = get_node_or_null("../squares/g2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	await wait(0.1)
	origin_tile = get_node_or_null("../squares/a2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	origin_tile = get_node_or_null("../squares/h2")
	if origin_tile:
		add_piece("pawn", origin_tile, false)
	
	update_matrix()

func update_matrix():
	matrix_pieces.clear()
	var temp:Array
	var index:int = 0
	for i in get_parent().get_node("squares").matrix_board:
		matrix_pieces.append([])
		for j in i:
			matrix_pieces[index].append(j.piece)
		index += 1

func add_piece(type : String, which_square, is_enemy : bool):
	
	var newpiece: Piece = piece.instantiate()
	add_child(newpiece)
	newpiece.name = type
	newpiece.type = type
	newpiece.current_square = which_square
	which_square.piece = newpiece
	var origin_position = which_square.position 
	newpiece.position = origin_position
	

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

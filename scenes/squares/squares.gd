extends Node2D
class_name Board

const dark = preload("res://assets/temporary/darksquare.png")
const light = preload("res://assets/temporary/lightsquare.png")

@onready var square_scene = preload("res://scenes/squares/square.tscn")

var dropped_square: Square
var selected_square: Square
var unaffected_selected_square: Square
var selected_piece: Piece
var hovered_square: Square = null # VARIABEL BARU: Pelacak posisi mouse
var highlighted_squares: Array[Square]

var is_dragging: bool = false
var is_dropping: bool = false

var matrix_board: Array = [[], [], [], [], [], [], [], []]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		print_matrix_pretty()

func print_matrix_pretty():
	var matrix_board_name_row : Array
	#var matrix_board_name : Array
	for i in matrix_board:
		for j in i:
			matrix_board_name_row.append(j.name)
		#matrix_board_name.append(matrix_board_name_row)
		print(matrix_board_name_row)
		matrix_board_name_row.clear()
		#print(matrix_board[i])

func _ready() -> void:
	boardspawn()
	InventoryInstructions.inventory_card_selected.connect(_on_inventory_card_selected)

func deselect_last_square_with(target_square: Square):
	var is_same_piece: bool = false
	if selected_square != null:
		if selected_square.piece != null and selected_square.piece == target_square.piece:
			is_same_piece = true
		if selected_square.piece and not is_same_piece:
			#print("same piece")
			selected_square.piece.deselect()
			#pass
	unaffected_selected_square = target_square
	selected_square = target_square
	
	if is_same_piece:
		selected_square = null
		#selected_piece = null

func boardspawn():
	const squaresize = 44
	const posawal = Vector2(64+6, 32)
	await wait(0.01)
	var is_white: bool = true
	var ganti_pokoknya: bool = false
	var pos = posawal
	var row = 9
	var col = 1
	
	for i in [1,2,3,4,5,6,7,8,7,6,5,4,3,2,1]:
		col += 1
		for j in range(i):
			await wait(0.01)
			row += -1
			col += -1
			pos += Vector2(-squaresize, squaresize)
			tilespawn(pos, is_white, int_to_ascii(col) + str(row), 8-row)
			
		if i == 8: 
			ganti_pokoknya = true
		if !ganti_pokoknya:
			col += i
			row = 9
			pos = posawal + Vector2(squaresize*i, 0)
		else:
			col = 8
			row = i
			pos = posawal + Vector2(squaresize*7, squaresize*(9-i))
		is_white = !is_white

func tilespawn(location: Vector2, texture_type: bool, tname: String, row: int):
	var newsquare: Square = square_scene.instantiate()
	add_child(newsquare)
	newsquare.position = location
	newsquare.name = tname
	if texture_type: 
		newsquare.tile.texture = light
	else: 
		newsquare.tile.texture = dark
	var col = matrix_board[row].size()
	newsquare.row = row
	newsquare.col = col
	matrix_board[row].append(newsquare)

func int_to_ascii(index: int):
	return char(96+index)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _process(_delta: float) -> void:
	if is_dragging and selected_piece:
		selected_piece.dragging()

func _on_inventory_card_selected(card: InventoryCard) -> void:
	clear_placeable_preview()
	if card and card.cardType == global.cardType.UNIT:
		highlighted_squares = get_highlighting_squares_for_card(card)
		show_placeable_preview()
	await get_tree().create_timer(0.5).timeout

func get_highlighting_squares_for_card(_card: InventoryCard) -> Array[Square]:
	var found_squares: Array[Square] = []
	# only include bottom 4 squares of the board (row index 0 to 3) that are empty
	for row in range(4):
		for square in matrix_board[row]:
			if square.piece == null:
				found_squares.append(square)
	return found_squares

func show_placeable_preview() -> void:
	for square in highlighted_squares:
		if square:
			square.set_preview(true)
	print_debug("Placeable squares preview shown: ", len(highlighted_squares))
	for i in range(min(3, len(highlighted_squares))):
		print_debug("Sample ", i + 1, ": ", highlighted_squares[i])

func clear_placeable_preview() -> void:
	if not highlighted_squares:
		return
	for square in highlighted_squares:
		square.set_preview(false)
	highlighted_squares.clear()

#func execute_drop():
	#is_dragging = false
	#if not selected_piece:
		#return
		#
	#if not dropped_square or dropped_square == unaffected_selected_square or dropped_square.piece != null or not validation():
		#selected_piece.reset()
	#else:
		#selected_piece.movecount += 1
		#
		## 1. Ambil referensi square lama sebelum datanya dihapus
		#var square_lama = unaffected_selected_square
		#var square_baru = dropped_square
		#
		## 2. Pindahkan data referensi logika board & piece
		#selected_piece.current_square = square_baru  # <--- Ganti current_square pada piece
		#square_lama.piece = null
		#square_baru.piece = selected_piece
		#
		## 4. Jalankan animasi perpindahan visual
		#selected_piece.is_dragging = false
		#selected_piece.dropping(square_lama, square_baru)
		#
		## Update matrix piece data
		#var pieces_manager = get_parent().get_node_or_null("pieces")
		#if pieces_manager:
			#pieces_manager.update_matrix()
		#
	#selected_piece = null
	#dropped_square = null
#
#func validation() -> bool:
	#if selected_piece and dropped_square:
		## Kembalikan nilai true / false secara mutlak (mencegah bug kembalian kosong/null)
		#return selected_piece.check_valid_square().has(dropped_square)
	#return false

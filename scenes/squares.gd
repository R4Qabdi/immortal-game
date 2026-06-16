extends Node2D
class_name Board

const dark = preload("res://assets/temporary/darksquare.png")
const light = preload("res://assets/temporary/lightsquare.png")

@onready var square = preload("res://scenes/square.tscn")

var dropped_square: Square
var selected_square: Square
var unaffected_selected_square: Square
var selected_piece: Piece
var hovered_square: Square = null # VARIABEL BARU: Pelacak posisi mouse

var is_dragging: bool = false
var is_dropping: bool = false

var matrix_board: Array = [[], [], [], [], [], [], [], []]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		print_matrix_pretty()

func print_matrix_pretty():
	for i in range(8):
		print(matrix_board[i])

func _ready() -> void:
	boardspawn()

func deselect_last_square_with(target_square: Square):
	var is_same_piece: bool = false
	if selected_square != null:
		if selected_square.piece != null and selected_square.piece == target_square.piece:
			is_same_piece = true
		if selected_square.piece and not is_same_piece:
			selected_square.piece.deselect()
			#pass
	unaffected_selected_square = target_square
	selected_square = target_square
	
	if is_same_piece:
		selected_square = null

func boardspawn():
	const squaresize = 44
	const posawal = Vector2(64+6, 100)
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
	var newsquare: Square = square.instantiate()
	add_child(newsquare)
	newsquare.position = location
	newsquare.name = tname
	if texture_type: 
		newsquare.tile.texture = light
	else: 
		newsquare.tile.texture = dark
	matrix_board[row].append(newsquare)

func int_to_ascii(index: int):
	return char(96+index)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _process(_delta: float) -> void:
	if is_dragging and selected_piece:
		selected_piece.dragging()

func execute_drop():
	is_dragging = false
	if not selected_piece:
		return
		
	if not dropped_square or dropped_square == unaffected_selected_square or dropped_square.piece != null or not validation():
		selected_piece.reset()
	else:
		selected_piece.movecount += 1
		
		# 1. Ambil referensi square lama sebelum datanya dihapus
		var square_lama = unaffected_selected_square
		var square_baru = dropped_square
		
		# 2. Pindahkan data referensi logika board & piece
		selected_piece.current_square = square_baru  # <--- Ganti current_square pada piece
		square_lama.piece = null
		square_baru.piece = selected_piece
		
		# 4. Jalankan animasi perpindahan visual
		selected_piece.dropping(square_lama, square_baru)
		
		# Update matrix piece data
		var pieces_manager = get_parent().get_node_or_null("pieces")
		if pieces_manager:
			pieces_manager.update_matrix()
		
	selected_piece = null
	dropped_square = null

func validation() -> bool:
	if selected_piece and dropped_square:
		# Kembalikan nilai true / false secara mutlak (mencegah bug kembalian kosong/null)
		return selected_piece.check_valid_square().has(dropped_square)
	return false

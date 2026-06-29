extends Node2D
class_name Square

@onready var labubu: Sprite2D = $labubu
@onready var tile: Sprite2D = $tile
@onready var dots: Area2D = $dots
var is_hovered: bool = false
var piece: Piece = null
var board: Board
var soft_select : Piece

func _ready() -> void:
	board = get_parent() as Board
	tile.modulate.a = 0
	await wait(0.1)
	tween_anim_modulate(tile, 0.5, Tween.EASE_IN)
	hyper_elastic_move(tile, tile.position)

func _input(event: InputEvent) -> void:
	#if event is InputEventScreenDrag
	if not board:
		return
	if event is InputEventKey and event.pressed and not event.is_echo():
		# ini khusus buat debug ajaqq
		if event.keycode == KEY_Q and is_hovered:
			print(dots.collision_layer)
			if piece:
				piece.check_valid_square()
			if piece and piece.type == "pawn":
				if piece.movecount == 0:
					piece.valid_pawn_moves(true)
				else :
					piece.valid_pawn_moves(false)
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.is_pressed() and is_hovered:
			## START DRAG: Hanya jalan kalau di atas petak yang ada pionnya
			#if piece:
				#if piece.is_enemy==false:
					#board.selected_piece = piece
					#board.is_dragging = true
					#piece.on_click()
					##piece.select_toggle()
					#board.deselect_last_square_with(self)
			#else:
				#board.deselect_last_square_with(self)
		#elif not event.is_pressed() and board.is_dragging:
			## STOP DRAG (RELEASED): Jika dilepas, suruh Board cek hovered_square terakhir
			#if board.hovered_square:
				#board.dropped_square = board.hovered_square
			#else:
				#board.dropped_square = null
			#board.execute_drop()
		

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func tween_anim_modulate(target, duration, easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "modulate:a", 1.0, duration)

func hyper_elastic_move(target, destination: Vector2):
	var tween = create_tween()
	var direction = (destination - target.position - Vector2(64, 64)).normalized()
	var overshoot_point = destination + (direction * 50)
	
	tween.tween_property(target, "position", overshoot_point, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", destination, 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_area_mouse_entered() -> void:
	$tile.modulate = Color.LIGHT_BLUE
	is_hovered = true
	if board:
		board.hovered_square = self # Catat kotak aktif yang di-hover mouse ke Board

func _on_area_mouse_exited() -> void:
	$tile.modulate = Color.WHITE
	is_hovered = false
	if board and board.hovered_square == self:
		board.hovered_square = null # Hapus dari catatan Board jika keluar kotakss

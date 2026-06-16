extends Node2D
class_name Piece

@onready var texture = $texture
@onready var labubu = $labubu
@onready var king_area = $kingmove

var type: String
var is_selected: bool = false
var hp: int 
var previous_square: Square
var current_square: Square
var movecount : int = 0
var is_enemy: bool = false
var debug_lines: Array[Dictionary] = []
var previous_valid_squares: Array[Square]
var current_valid_squares: Array[Square]

func _ready() -> void:
	texture.modulate.a = 0
	await wait(0.1)
	update_my_square_layer()
	texture.texture = load("res://assets/temporary/pieces/" + type + "-normal.png")
	texture.position -= Vector2(0, 64)
	tween_anim_modulate(texture, 0.5, Tween.EASE_IN)
	tween_anim_spawn(texture, 1, Tween.EASE_OUT)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func tween_anim_spawn(target, duration, easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(target, "position", target.position + Vector2(0, 64), duration)

func tween_anim_modulate(target, duration, easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "modulate:a", 1.0, duration)

func tween_to_move(target, to, duration, easing, trans):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(trans)
	tween.tween_property(target, "position", to, duration)

func select_texture(it_is_selected : bool):
	if it_is_selected: 
		texture.texture = load("res://assets/temporary/pieces/" + type + "-selected.png")
	else:
		texture.texture = load("res://assets/temporary/pieces/" + type + "-normal.png")

func select_toggle():
	is_selected = !is_selected
	#check_valid_square()
	update_show_valid_moves()
	

func deselect():
	is_selected = false
	print("deselected")
	
	texture.texture = load("res://assets/temporary/pieces/" + type + "-normal.png")

func dragging():
	select_texture(false)
	texture.scale = Vector2(3, 3)
	var viewportsize = get_viewport_rect().size
	const Y_OFFSET = -18
	var mouse_pos = get_global_mouse_position()+Vector2(0,Y_OFFSET)
	var clamp_y = clamp(mouse_pos.y, 36, viewportsize.y - 36)
	var clamp_x = clamp(mouse_pos.x, 36, viewportsize.x - 36)
	texture.global_position = Vector2(clamp_x, clamp_y)

func dropping(from_square:Square, to_square: Square):
	previous_square = from_square
	is_selected = false
	#print("new square")
	current_square = to_square
	
	# Pindahkan posisi root Node2D milik piece ke square baru
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "global_position", to_square.global_position, 0.2)
	
	# Kembalikan offset texture secara lokal
	texture.position = Vector2(0, -16)
	texture.scale = Vector2(2, 2)
	
	#update layer square
	update_my_square_layer(true)
	

func reset():
	select_toggle()
	select_texture(is_selected)
	# Pulangkan offset texture lokal ke (0, -16) di dalam current_square semula
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(texture, "position", Vector2(0, -16), 0.15)
	
	texture.scale = Vector2(2, 2)
	#deselect()

func _draw() -> void:
	# Gambar semua garis yang terdaftar
	for line in debug_lines:
		var local_start = to_local(line.start)
		var local_end = to_local(line.end)
		draw_line(local_start, local_end, line.color, 2.0)

func tambah_debug_line(dari: Vector2, ke: Vector2, warna: Color):
	debug_lines.append({"start": dari, "end": ke, "color": warna})
	queue_redraw()

func update_my_square_layer(is_occupied: bool = true):
	if current_square:
		var square_area = current_square.dots
		if is_occupied:
			square_area.collision_layer = 6 # Set ke Layer 3 dan 2 (Ada Piece)
		else:
			square_area.collision_layer = 2 # Set ke Layer 2 (Kosong)
	if previous_square:
		print(previous_square)
		var square_area = previous_square.dots
		square_area.collision_layer = 2 # Set ke Layer 2 (Kosong)

# =========================================================================
# UTAMA: DISTRIBUSI VALIDASI BERDASARKAN TIPE BIDAK
# =========================================================================
func check_valid_square() -> Array[Square]:
	
	current_square.dots.collision_layer = 0
	match type:
		"pawn": valid_pawn_moves(movecount < 1)
		#"rook": valid_rook_moves()
		#"bishop": valid_bishop_moves()
		#"queen": alid_queen_moves()
		#"knight": valid_knight_moves()
		#"king": valid_king_moves()
	current_square.dots.collision_layer = 0b110
	
	print("Bidak: ", type, " | Jumlah Langkah Valid Ditemukan: ", current_valid_squares.size())
	print(current_valid_squares)
	return current_valid_squares

func update_show_valid_moves():
	if is_selected:
		for valid_square in current_valid_squares:
			valid_square.labubu.visible = true
	else:
		if previous_valid_squares:
			for previous_valid_square in previous_valid_squares:
				print("previous square"+str(previous_valid_square))
				previous_valid_square.labubu.visible = false
	previous_valid_squares = current_valid_squares

# =========================================================================
# UTILITY: MENCOCOL SQUARE DI KOORDINAT TERTENTU SAAT RAYCAST KOSONG
# =========================================================================
func cari_square_di_posisi(posisi_target: Vector2) -> Square:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(posisi_target - Vector2(0, 1), posisi_target + Vector2(0, 1))
	query.collision_mask = 2 # Mengincar Layer 2 (Square)
	query.collide_with_areas = true
	
	var hasil = space_state.intersect_ray(query)
	if hasil.size() > 0 and hasil.collider.owner is Square:
		return hasil.collider.owner as Square
	return null

# =========================================================================
# PAWN MOVES (Pion)
# =========================================================================
func valid_pawn_moves(is_first_move: bool) -> void:
	var valid_moves: Array[Square] = []
	if is_first_move : 
		var direction = global_position+ Vector2(0,-88)
		var space_state = get_world_2d().direct_space_state
		var excluded = []
		while true:
			var query = PhysicsRayQueryParameters2D.create(global_position,direction)
			query.exclude = excluded
			query.collide_with_areas = true
			query.collision_mask = 0b110
			var results = space_state.intersect_ray(query)
			if results.is_empty():
				break
			
			if results["collider"].collision_layer & (1 << 2):  # detect a piece
				#commented because pawn cannot capture forward
				#if results["collider"].collision_layer & (1 << 1):  # is an enemy piece
					#valid_moves.append(results["collider"].get_parent())  # valid capture
					#excluded.append(results["rid"])
				break  # stop either way
			
			valid_moves.append(results["collider"].get_parent())
			excluded.append(results["rid"])
	else :
		var direction = global_position+ Vector2(0,-44)
		var space_state = get_world_2d().direct_space_state
		var excluded = []
		while true:
			var query = PhysicsRayQueryParameters2D.create(global_position,direction)
			query.exclude = excluded
			query.collide_with_areas = true
			query.collision_mask = 0b110
			var results = space_state.intersect_ray(query)
			if results.is_empty():
				break
			
			if results["collider"].collision_layer & (1 << 2):  # detect a piece
				#commented because pawn cannot capture forward
				#if results["collider"].collision_layer & (1 << 1):  # is an enemy piece
					#valid_moves.append(results["collider"].get_parent())  # valid capture
					#excluded.append(results["rid"])
				break  # stop either way
			
			valid_moves.append(results["collider"].get_parent())
			excluded.append(results["rid"])
	#-------
	#capture logic
	#-------
	
	current_valid_squares = valid_moves


# =========================================================================
# QUEEN MOVES (Ratu)
## =========================================================================
#func valid_queen_moves() -> Array[Square]:
	#var valid_moves: Array[Square] = []
	#valid_moves.append_array(valid_rook_moves())
	#valid_moves.append_array(valid_bishop_moves())
	#return valid_moves
#
## =========================================================================
## KING MOVES (Raja - Deteksi Menggunakan Area2D Lingkaran)
## =========================================================================
#func valid_king_moves() -> Array[Square]:
	#var valid_moves: Array[Square] = []
	#
	#if not king_area:
		#print("Peringatan: Node KingArea (Area2D) tidak ditemukan!")
		#return valid_moves
		#
	#var areas = king_area.get_overlapping_areas()
	#
	#for area in areas:
		#if area.owner is Square:
			#var sq = area.owner as Square
			#var jarak = global_position.distance_to(sq.global_position)
			#
			#if jarak > 5 and jarak < 65:
				#if sq.piece == null or (sq.piece.is_enemy != self.is_enemy):
					#valid_moves.append(sq)
					#tambah_debug_line(global_position, sq.global_position, Color.GREEN)
					#
	#return valid_moves
#
## =========================================================================
## KNIGHT / HORSE MOVES (Kuda)
## =========================================================================
#func valid_knight_moves() -> Array[Square]:
	#var valid_moves: Array[Square] = []
	#var space_state = get_world_2d().direct_space_state
	#var start_pos = global_position
	#
	#var lompatan_l = [
		#Vector2(-44, -88), Vector2(44, -88),
		#Vector2(-88, -44), Vector2(88, -44),
		#Vector2(-88, 44),  Vector2(88, 44),
		#Vector2(-44, 88),  Vector2(44, 88)
	#]
	#
	#for titik in lompatan_l:
		#var target_pos = start_pos + titik
		#var query = PhysicsRayQueryParameters2D.create(target_pos - Vector2(0,1), target_pos + Vector2(0,1))
		#query.collision_mask = 2 
		#query.collide_with_areas = true
		#
		#var result = space_state.intersect_ray(query)
		#
		#if result.size() > 0:
			#var collider = result.collider
			#if collider.owner is Square:
				#var sq = collider.owner as Square
				#if sq.piece == null or (sq.piece.is_enemy != self.is_enemy):
					#valid_moves.append(sq)
					#tambah_debug_line(start_pos, target_pos, Color.GREEN)
				#else:
					#tambah_debug_line(start_pos, target_pos, Color.ORANGE)
					#
	#return valid_moves
#
## =========================================================================
## BISHOP MOVES (Gajah)
## =========================================================================
#func valid_bishop_moves() -> Array[Square]:
	#var valid_moves: Array[Square] = []
	#var space_state = get_world_2d().direct_space_state
	#var start_pos = global_position
	#
	#var arah_diagonal = [
		#Vector2(-1, -1), Vector2(1, -1),
		#Vector2(-1, 1),  Vector2(1, 1)
	#]
	#
	#for arah in arah_diagonal:
		#for i in range(1, 9):
			#var jarak = i * 44
			#var target_pos = start_pos + (arah * jarak)
			#
			#var query = PhysicsRayQueryParameters2D.create(start_pos, target_pos)
			#query.collision_mask = 0b110
			#query.collide_with_areas = true
			#
			#var result = space_state.intersect_ray(query)
			#
			#if result.size() > 0:
				#var collider = result.collider
				#if collider.collision_layer & 2 and collider.owner is Square:
					#var sq = collider.owner as Square
					#if sq.piece == null:
						#valid_moves.append(sq)
						#tambah_debug_line(start_pos, target_pos, Color.GREEN)
					#else:
						#if sq.piece.is_enemy != self.is_enemy:
							#valid_moves.append(sq)
							#tambah_debug_line(start_pos, target_pos, Color.RED)
						#break
				#elif collider.collision_layer & 4:
					#break
			#else:
				#break
				#
	#return valid_moves
#
## =========================================================================
## ROOK MOVES (Benteng)
## =========================================================================
#func valid_rook_moves() -> Array[Square]:
	#var valid_moves: Array[Square] = []
	#var space_state = get_world_2d().direct_space_state
	#var start_pos = global_position
	#
	#var arah_lurus = [
		#Vector2(0, -1), Vector2(0, 1),
		#Vector2(1, 0),  Vector2(-1, 0)
	#]
	#
	#for arah in arah_lurus:
		#for i in range(1, 9):
			#var jarak = i * 44 
			#var target_pos = start_pos + (arah * jarak)
			#
			#var query = PhysicsRayQueryParameters2D.create(start_pos, target_pos)
			#query.collision_mask = 6 
			#query.collide_with_areas = true
			#
			#var result = space_state.intersect_ray(query)
			#
			#if result.size() > 0:
				#var collider = result.collider
				#if collider.collision_layer & 2 and collider.owner is Square:
					#var sq = collider.owner as Square
					#if sq.piece == null:
						#valid_moves.append(sq)
						#tambah_debug_line(start_pos, target_pos, Color.GREEN)
					#else:
						#if sq.piece.is_enemy != self.is_enemy:
							#valid_moves.append(sq)
							#tambah_debug_line(start_pos, target_pos, Color.RED)
						#break 
				#elif collider.collision_layer & 4:
					#break
			#else:
				#break
				#
	#return valid_moves

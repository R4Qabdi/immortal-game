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

func select_toggle():
	is_selected = !is_selected
	if is_selected: 
		texture.texture = load("res://assets/temporary/pieces/" + type + "-selected.png")
	else:
		texture.texture = load("res://assets/temporary/pieces/" + type + "-normal.png")

func deselect():
	is_selected = false
	texture.texture = load("res://assets/temporary/pieces/" + type + "-normal.png")

func dragging():
	texture.scale = Vector2(3, 3)
	var viewportsize = get_viewport_rect().size
	var mouse_pos = get_global_mouse_position()
	var clamp_y = clamp(mouse_pos.y, 36, viewportsize.y - 36)
	var clamp_x = clamp(mouse_pos.x, 36, viewportsize.x - 36)
	texture.global_position = Vector2(clamp_x, clamp_y)

func dropping(to_square: Square):
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
	
	deselect()

func reset():
	# Pulangkan offset texture lokal ke (0, -16) di dalam current_square semula
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(texture, "position", Vector2(0, -16), 0.15)
	
	texture.scale = Vector2(2, 2)
	deselect()

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
		var square_area = current_square.dots
		square_area.collision_layer = 2 # Set ke Layer 2 (Kosong)

# =========================================================================
# UTAMA: DISTRIBUSI VALIDASI BERDASARKAN TIPE BIDAK
# =========================================================================
func check_valid_square() -> Array[Square]:
	var moves: Array[Square] = []
	match type:
		"pawn": moves = valid_pawn_moves(movecount < 1)
		#"rook": moves = valid_rook_moves()
		#"bishop": moves = valid_bishop_moves()
		#"queen": moves = valid_queen_moves()
		#"knight", "horse": moves = valid_knight_moves()
		#"king": moves = valid_king_moves()
	
	print("Bidak: ", type, " | Jumlah Langkah Valid Ditemukan: ", moves.size())
	print(moves)
	return moves


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
func valid_pawn_moves(is_first_move: bool) -> Array[Square]:
	var valid_moves: Array[Square] = []
	var space_state = get_world_2d().direct_space_state
	
	debug_lines.clear()
	var start_pos = global_position
	
	# --- LANGKAH 1 (Maju 1 Kotak / sejauh 44 pixel) ---
	var target_langkah_1 = start_pos + Vector2(0, -44)
	var query_1 = PhysicsRayQueryParameters2D.create(start_pos, target_langkah_1)
	query_1.collision_mask = 6 
	query_1.collide_with_areas = true
	query_1.collide_with_bodies = false
	
	var result_1 = space_state.intersect_ray(query_1)
	var jalan_1_terblokir: bool = false
	var warna_1 = Color.GREEN
	
	if result_1.size() > 0:
		var collider = result_1.collider
		if collider.collision_layer & 2 and collider.owner is Square:
			var sq1 = collider.owner as Square
			if sq1.piece == null:
				valid_moves.append(sq1)
			else:
				jalan_1_terblokir = true
				warna_1 = Color.RED
		elif collider.collision_layer & 4:
			jalan_1_terblokir = true
			warna_1 = Color.RED
	else:
		# PERBAIKAN: Jika raycast kosong, cari object Square-nya secara manual
		var objek_di_target = cari_square_di_posisi(target_langkah_1)
		if objek_di_target and objek_di_target.piece == null:
			valid_moves.append(objek_di_target)
			warna_1 = Color.GREEN
		else:
			warna_1 = Color.RED
		
	tambah_debug_line(start_pos, target_langkah_1, warna_1)

	# --- LANGKAH 2 (Maju 2 Kotak, Hanya untuk Langkah Pertama) ---
	if is_first_move and not jalan_1_terblokir:
		var target_langkah_2 = start_pos + Vector2(0, -88)
		var query_2 = PhysicsRayQueryParameters2D.create(target_langkah_1, target_langkah_2)
		query_2.collision_mask = 6
		query_2.collide_with_areas = true
		query_2.collide_with_bodies = false
		
		var result_2 = space_state.intersect_ray(query_2)
		var warna_2 = Color.GREEN
		
		if result_2.size() > 0:
			var collider = result_2.collider
			if collider.collision_layer & 2 and collider.owner is Square:
				var sq2 = collider.owner as Square
				if sq2.piece == null:
					valid_moves.append(sq2)
				else:
					warna_2 = Color.RED
			elif collider.collision_layer & 4:
				warna_2 = Color.RED
		else:
			# PERBAIKAN: Cari objek Square secara manual jika raycast kosong
			var objek_di_target_2 = cari_square_di_posisi(target_langkah_2)
			if objek_di_target_2 and objek_di_target_2.piece == null:
				valid_moves.append(objek_di_target_2)
				warna_2 = Color.GREEN
			else:
				warna_2 = Color.RED
			
		tambah_debug_line(target_langkah_1, target_langkah_2, warna_2)

	# --- SERANGAN DIAGONAL ---
	var arah_makan = [Vector2(-44, -44), Vector2(44, -44)]
	
	for arah in arah_makan:
		var target_diagonal = start_pos + arah
		var query_diag = PhysicsRayQueryParameters2D.create(start_pos, target_diagonal)
		query_diag.collision_mask = 2 
		query_diag.collide_with_areas = true
		query_diag.collide_with_bodies = false
		
		var result_diag = space_state.intersect_ray(query_diag)
		var warna_diag = Color.BLUE
		
		if result_diag.size() > 0:
			var collider = result_diag.collider
			if collider.owner is Square:
				var target_square = collider.owner as Square
				if target_square.piece and target_square.piece.is_enemy != self.is_enemy:
					valid_moves.append(target_square)
					warna_diag = Color.RED
				else:
					warna_diag = Color.ORANGE
		else:
			warna_diag = Color.BLUE
					
		tambah_debug_line(start_pos, target_diagonal, warna_diag)
		
	return valid_moves

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

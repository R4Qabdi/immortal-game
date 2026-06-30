extends Node2D
class_name Piece

@onready var texture = $texture
@onready var labubu = $labubu
@onready var king_area = $kingmove

const SCALE = Vector2(2.0,2.0)

var type: String
var is_selected: bool = false
var is_dragging: bool = false
var hp: int 
var previous_square: Square
var current_square: Square
var movecount : int = 0
var is_enemy: bool = false
var debug_lines: Array[Dictionary] = []
var previous_valid_squares: Array[Square]
var current_valid_squares: Array[Square]

var itemEffect:Dictionary

func _ready() -> void:
	texture.modulate.a = 0
	texture.scale = SCALE
	await wait(0.1)
	update_my_square_layer()
	if !is_enemy:
		texture.texture = load("res://assets/arts/pieces/" + type + "-normal.png")
	else : 
		texture.texture = load("res://assets/arts/pieces/" + type + "-normal.png")
		texture.modulate = Color.BLACK
	
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
		#print("select texture")
		texture.texture = load("res://assets/arts/pieces/" + type + "-selected.png")
	else:
		#print("deselect texture")
		texture.texture = load("res://assets/arts/pieces/" + type + "-normal.png")

func select_toggle():
	is_selected = !is_selected
	#print("toggled to : "+str(is_selected))

func on_click():
	#print("is clicked")
	#update layer square
	check_valid_square()
	
	select_toggle()
	select_texture(is_selected)
	update_show_valid_moves()

func deselect():
	is_selected = false
	#print("deselected")
	select_texture(is_selected)
	update_show_valid_moves()

func dragging():
	#select_texture(false)
	texture.scale = SCALE*2
	texture.z_index = 10
	var viewportsize = get_viewport_rect().size
	const Y_OFFSET = -18
	var mouse_pos = get_global_mouse_position()+Vector2(0,Y_OFFSET)
	var clamp_y = clamp(mouse_pos.y, 0, viewportsize.y)
	
	var clamp_x = clamp(mouse_pos.x, 0, viewportsize.x)
	texture.global_position = Vector2(clamp_x, clamp_y)

func dropping(from_square:Square, to_square: Square):
	previous_square = from_square
	#print("new square")
	current_square = to_square
	self.global_position = to_square.position
	texture.global_position = from_square.position
	# Pindahkan posisi root Node2D milik piece ke square baru
	texture.scale = SCALE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(texture, "global_position", to_square.global_position + Vector2(0, -16), 0.3)
	
	# Kembalikan offset texture secara lokal
	tween.tween_callback(func():
		texture.position = Vector2(0, -16)
		texture.z_index = 0
	)
	update_my_square_layer()
	deselect()

func reset():
	#select_toggle()
	#select_texture(is_selected)
	# Pulangkan offset texture lokal ke (0, -16) di dalam current_square semula
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(texture, "position", Vector2(0, -16), 0.15)
	
	texture.scale = SCALE
	texture.z_index = 0
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

func update_my_square_layer():
	if !is_enemy:
		if current_square:
			var square_area = current_square.dots
			square_area.collision_layer = 6 # Set ke Layer 3 dan 2 (Ada Piece)
		if previous_square:
			#print(previous_square)
			var square_area = previous_square.dots
			square_area.collision_layer = 2 # Set ke Layer 2 (Kosong)
	else : 
		if current_square:
			var square_area = current_square.dots
			square_area.collision_layer = 4 # Set ke Layer 3 dan 2 (Ada Piece)
		if previous_square:
			#print(previous_square)
			var square_area = previous_square.dots
			square_area.collision_layer = 2 # Set ke Layer 2 (Kosong)
		

# =========================================================================
# UTAMA: DISTRIBUSI VALIDASI BERDASARKAN TIPE BIDAK
# =========================================================================
func check_valid_square() -> Array[Square]:
	#current_valid_squares.clear()
	current_square.dots.collision_layer = 0
	
	
	
	match type:
		"pawn": current_valid_squares = valid_pawn_moves(movecount < 1)
		"rook": current_valid_squares = valid_rook_moves()
		"bishop": current_valid_squares = valid_bishop_moves()
		"queen": current_valid_squares = valid_queen_moves()
		"knight": current_valid_squares = valid_knight_moves()
		"king": current_valid_squares = valid_king_moves()
	current_square.dots.collision_layer = 0b110
	
	print("Bidak: ", type, " | Jumlah Langkah Valid Ditemukan: ", current_valid_squares.size())
	print(current_valid_squares)
	return current_valid_squares

func update_show_valid_moves():
	#print("update valid")
	if is_selected:
		for valid_square in current_valid_squares:
			#print("njir")
			valid_square.labubu.visible = true
	else:
		if previous_valid_squares :
			for previous_valid_square in previous_valid_squares:
				#print("previous square"+str(previous_valid_square))
				previous_valid_square.labubu.visible = false
	if current_valid_squares != previous_valid_squares : 
		previous_valid_squares = current_valid_squares
	#current_valid_squares.clear()

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
	var capture_direction_left = global_position+ Vector2(-44,-44)
	var capture_direction_right = global_position+ Vector2(44,-44)
	var space_state = get_world_2d().direct_space_state
	var excluded = []
	var query_left = PhysicsRayQueryParameters2D.create(global_position,capture_direction_left)
	var query_right = PhysicsRayQueryParameters2D.create(global_position,capture_direction_right)
	query_left.collide_with_areas = true
	query_right.collide_with_areas = true
	query_left.collision_mask = 0b100
	query_right.collision_mask = 0b100
	var result_left = space_state.intersect_ray(query_left)
	var result_right = space_state.intersect_ray(query_right)
	if result_left :
		if result_left["collider"].collision_layer == 0b100:
			valid_moves.append(result_left["collider"].get_parent())
	if result_right:
		if result_right["collider"].collision_layer == 0b100:
			valid_moves.append(result_right["collider"].get_parent())
	
	return valid_moves


# =========================================================================
# QUEEN MOVES (Ratu)
## =========================================================================
func valid_queen_moves() -> Array[Square]:
	var valid_moves: Array[Square] = []
	valid_moves.append_array(valid_bishop_moves())
	valid_moves.append_array(valid_rook_moves())
	return valid_moves

## =========================================================================
## KING MOVES (Raja - Deteksi Menggunakan Area2D Lingkaran)
## =========================================================================
func valid_king_moves() -> Array[Square]:
	var valid_moves: Array[Square] = []
	
	var areas = king_area.get_overlapping_areas()
	
	for area in areas:
		if area.owner is Square:
			var sq = area.owner as Square
			var jarak = global_position.distance_to(sq.global_position)
			
			if jarak > 5 and jarak < 65:
				if sq.piece == null or (sq.piece.is_enemy != self.is_enemy):
					valid_moves.append(sq)
					#tambah_debug_line(global_position, sq.global_position, Color.GREEN)
					
	return valid_moves

## =========================================================================
## KNIGHT / HORSE MOVES (Kuda)
## =========================================================================
func valid_knight_moves() -> Array[Square]:
	var valid_moves: Array[Square] = []
	var kudamove : Array =[
		Vector2(88, -44),
		Vector2(-88, -44),
		Vector2(-88, 44),
		Vector2(88, 44),
		Vector2(44, -88),
		Vector2(-44, -88),
		Vector2(-44, 88),
		Vector2(44, 88),
	]
	for i in kudamove :
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = Vector2(global_position+i)
		query.collide_with_areas = true
		query.collision_mask = 0b110
		var results = space_state.intersect_point(query)
		#print(results)
		if results:
			if results[0]["collider"].collision_layer == 0b10 or results[0]["collider"].collision_layer == 0b100:
				valid_moves.append(results[0]["collider"].get_parent())
	return valid_moves


## =========================================================================
## BISHOP MOVES (Gajah)
## =========================================================================
func valid_bishop_moves() -> Array[Square]:
	#current_valid_squares.clear()
	var valid_moves: Array[Square] = []
	
	var direction :Array[Vector2] = [
		global_position+Vector2(44*8,44*8),
		global_position+Vector2(44*8,-44*8),
		global_position+Vector2(-44*8, 44*8),
		global_position+Vector2(-44*8, -44*8),
	]
	var space_state = get_world_2d().direct_space_state
	var excluded = []
	for i in direction : 
		while true:
			var query = PhysicsRayQueryParameters2D.create(global_position, i)
			query.exclude = excluded
			query.collide_with_areas = true
			query.collision_mask = 0b110
			var results = space_state.intersect_ray(query)
			if results.is_empty():
				break
			
			var layer = results["collider"].collision_layer
			if layer & (1 << 2):
				if not (layer & (1 << 1)):  # enemy squares lack the "walkable" bit — true enemy check
					valid_moves.append(results["collider"].get_parent())
					excluded.append(results["rid"])
				break
			
			valid_moves.append(results["collider"].get_parent())
			excluded.append(results["rid"])
	
	return valid_moves

## =========================================================================
## ROOK MOVES (Benteng)
## =========================================================================
func valid_rook_moves() -> Array[Square]:
	#current_valid_squares.clear()
	var valid_moves: Array[Square] = []
	
	var direction :Array[Vector2] = [
		global_position+Vector2(0,44*8),
		global_position+Vector2(0,-44*8),
		global_position+Vector2(44*8, 0),
		global_position+Vector2(-44*8, 0),
	]
	var space_state = get_world_2d().direct_space_state
	var excluded = []
	for i in direction : 
		while true:
			var query = PhysicsRayQueryParameters2D.create(global_position, i)
			query.exclude = excluded
			query.collide_with_areas = true
			query.collision_mask = 0b110
			var results = space_state.intersect_ray(query)
			if results.is_empty():
				break
			
			var layer = results["collider"].collision_layer
			if layer & (1 << 2):
				if not (layer & (1 << 1)):  # enemy squares lack the "walkable" bit — true enemy check
					valid_moves.append(results["collider"].get_parent())
					excluded.append(results["rid"])
				break
			
			valid_moves.append(results["collider"].get_parent())
			excluded.append(results["rid"])
	
	return valid_moves

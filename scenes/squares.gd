extends Node2D
class_name Board
const dark = preload("res://assets/temporary/darksquare.png")
const light = preload("res://assets/temporary/lightsquare.png")
const MOUSE_RAYCAST_MASK = 1

@onready var square = preload("res://scenes/square.tscn")

var matrix_board: Array=[
	[],
	[],
	[],
	[],
	[],
	[],
	[],
	[]
]
# RUSAK BANGET RAYCASTNYA BANGKE< AKU GABISA FIX
# NANTI AJALAH KONTOL
#func mouse_raycast():
	#var mouse_pos = get_global_mouse_position()
	#
	#var space_state = get_world_2d().direct_space_state
	#
	#var query = PhysicsRayQueryParameters2D.new()
	#query.collision_mask = MOUSE_RAYCAST_MASK
	#query.from = mouse_pos
	#query.to = mouse_pos
	#query.collide_with_areas = true
	#query.collide_with_bodies = false
	#
	#var results = space_state.intersect_ray(query)
	#
	#if results.size() > 0:
		#print(results)
		#var area = results.collider
		##print("Hit Area2D:", area.name)
		#return area.get_parent()
	#return null

func _ready() -> void:
	boardspawn()
	#legacy_boardspawn()

func legacy_boardspawn():
	const squaresize = 44
	var pos = Vector2(64-44,100)
	var row = 9
	var col = 0
	for i in range(1,65):
		print(i)
		var newsquare = square.instantiate()
		add_child(newsquare)
		if i % 8 == 1:
			row -=1
			col =0
			pos.y += squaresize
			pos.x = squaresize
		if (row % 2) == 0:
			if (i % 2) == 0:
				newsquare.tile.texture = light
				col +=1
			else:
				newsquare.tile.texture = dark
				col +=1
		else:
			if (i % 2) == 0:
				newsquare.tile.texture = dark
				col +=1
			else:
				newsquare.tile.texture = light
				col +=1
		newsquare.position = pos
		pos.x += squaresize
		newsquare.name = int_to_ascii(col) + str(row)
		await wait(0.01)

func boardspawn():
	const squaresize = 44
	const posawal = Vector2(64+6, 100)
	await wait(0.01)
	var is_white :bool= true
	var ganti_pokoknya :bool= false
	var pos = posawal
	var row = 9
	var col = 1
	
	for i in [1,2,3,4,5,6,7,8,7,6,5,4,3,2,1]:
		col +=1
		for j in range(i):
			await wait(0.01)
			row += -1
			col += -1
			pos += Vector2(-squaresize, squaresize)
			tilespawn(pos, is_white, int_to_ascii(col) + str(row))
			
		if i == 8 : 
			ganti_pokoknya = true
		if !ganti_pokoknya :
			col += i
			row = 9
			pos = posawal + Vector2(squaresize*i,0)
		else :
			col = 8
			row = i
			pos = posawal + Vector2(squaresize*7, squaresize*(9-i))
		is_white = !is_white

func tilespawn(location : Vector2, texture : bool, tname : String):
	var newsquare: Square = square.instantiate()
	add_child(newsquare)
	newsquare.position = location
	newsquare.name = tname
	if texture : newsquare.tile.texture = light
	else : newsquare.tile.texture = dark

func int_to_ascii(index : int):
	return char(96+index)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _process(delta: float) -> void:
	pass

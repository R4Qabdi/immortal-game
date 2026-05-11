extends Node2D

const dark = preload("res://assets/temporary/darksquare.png")
const light = preload("res://assets/temporary/lightsquare.png")
const MOUSE_RAYCAST_MASK = 1

@onready var square = preload("res://scenes/square.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var tile = mouse_raycast()
			print(tile)
			if tile:
				tile.labubu.visible = !(tile.get_node("labubu").visible)
			
# RUSAK BANGET RAYCASTNYA BANGKE< AKU GABISA FIX
# NANTI AJALAH KONTOL
func mouse_raycast():
	var mouse_pos = get_global_mouse_position()
	
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsRayQueryParameters2D.new()
	query.collision_mask = MOUSE_RAYCAST_MASK
	query.from = mouse_pos
	query.to = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var results = space_state.intersect_ray(query)
	
	if results.size() > 0:
		print(results)
		var area = results.collider
		#print("Hit Area2D:", area.name)
		return area.get_parent()
	return null

func _ready() -> void:
	const squaresize = 44
	var pos = Vector2(64,100)
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
			pos.x = squaresize-18+64
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

func int_to_ascii(index : int):
	return char(96+index)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _process(delta: float) -> void:
	pass

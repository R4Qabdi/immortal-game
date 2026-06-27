extends Node2D

var previous_square : Square
var current_square : Square

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_on_press(event.position)
		else:
			_on_release(event.position)
	elif event is InputEventScreenDrag:
		_on_drag(event.position)

func _on_press(event):
	check_square()
	#print("press" + str(event))

func _on_release(event):
	if current_square:
		if current_square.piece:
			if current_square.piece.is_enemy == false:
				current_square.piece.select_toggle()

func _on_drag(event):
	print("drag" + str(event))

func check_square():
	#print("cek square")
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = Vector2(get_global_mouse_position())
	query.collide_with_areas = true
	query.collision_mask = 0b1
	var results = space_state.intersect_point(query)
	if results.size()>0:
		var square = results[0]["collider"].get_parent()
		push_square(square)

func push_square(square:Square):
	#print("pushed")
	previous_square = current_square
	current_square = square

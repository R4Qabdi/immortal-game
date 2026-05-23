extends Node2D
class_name Square

@onready var labubu :Sprite2D= $labubu
@onready var tile :Sprite2D= $tile
var is_hovered :bool= false
var piece :Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and is_hovered:
			if piece:
				print(piece.name)
				piece.select_toggle()
			else:
				print("gaada")
				

func _ready() -> void:
	tile.modulate.a = 0
	#$animp.play("muncul")
	await wait(0.1)
	tween_anim_modulate(tile, 0.5, Tween.EASE_IN)
	#tween_anim_spawn(self, 2, Tween.EASE_IN_OUT)
	#tween_egolegol(3)
	hyper_elastic_move(tile,tile.position)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func tween_anim_spawn(target, duration, easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(target,"position", target.position -Vector2(64,64), duration)
func tween_anim_modulate(target,duration,easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target,"modulate:a", 1.0,duration)

func hyper_elastic_move(target, destination: Vector2):
	var tween = create_tween()
	
	var direction = (destination - target.position-Vector2(64,64)).normalized()
	var overshoot_point = destination + (direction * 50) # Extra 50 pixels
	
	tween.tween_property(target, "position", overshoot_point, 0.5)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", destination, 2)\
	.set_trans(Tween.TRANS_ELASTIC)\
	.set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	pass

func _on_area_mouse_entered() -> void:
	is_hovered = true
	#print("hovering : " + self.name)

func _on_area_mouse_exited() -> void:
	is_hovered = false

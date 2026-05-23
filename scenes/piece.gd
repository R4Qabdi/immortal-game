extends Node2D
class_name Piece
@onready var texture = $texture
@onready var labubu = $labubu
var type :String
var is_selected :bool = false
var hp : int 

func _ready() -> void:
	texture.modulate.a=0
	await wait(0.1)
	texture.texture=load("res://assets/temporary/pieces/"+type+"-normal.png")
	texture.position -= Vector2(0,64)
	tween_anim_modulate(texture, 0.5, Tween.EASE_IN)
	tween_anim_spawn(texture, 1, Tween.EASE_OUT)

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func _process(delta: float) -> void:
	pass

func tween_anim_spawn(target, duration, easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(target,"position", target.position +Vector2(0,64), duration)
func tween_anim_modulate(target,duration,easing):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target,"modulate:a", 1.0,duration)

func select_toggle():
	is_selected = !is_selected
	if is_selected: 
		texture.texture=load("res://assets/temporary/pieces/"+type+"-selected.png")
	else:
		texture.texture=load("res://assets/temporary/pieces/"+type+"-normal.png")

func deselect():
	is_selected = false

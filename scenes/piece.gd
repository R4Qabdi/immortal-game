extends Node2D

@onready var texture = $texture
@onready var labubu = $labubu

func _ready() -> void:
	self.modulate.a=0
	await wait(0.1)
	self.position -= Vector2(0,64)
	tween_anim_modulate(self, 0.5, Tween.EASE_IN)
	tween_anim_spawn(self, 1, Tween.EASE_OUT)

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

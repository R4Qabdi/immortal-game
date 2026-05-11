extends Node2D
@onready var labubu = $labubu
@onready var tile = $tile

func _ready() -> void:
	#$animp.play("muncul")
	await wait(0.1)
	tween_anim_modulate(self, 0.5, Tween.EASE_IN)
	#tween_anim_spawn(self, 2, Tween.EASE_IN_OUT)
	#tween_egolegol(3)
	hyper_elastic_move(self,self.position + Vector2(-64,-64))

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

func hyper_elastic_move(target: Node2D, destination: Vector2):
	var tween = create_tween()
	
	var direction = (destination - target.position).normalized()
	var overshoot_point = destination + (direction * 50) # Extra 50 pixels
	
	tween.tween_property(target, "position", overshoot_point, 0.5)\
	.set_trans(Tween.TRANS_QUAD)\
	.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", destination, 2)\
	.set_trans(Tween.TRANS_ELASTIC)\
	.set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	pass

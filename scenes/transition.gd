extends ColorRect

@onready var current_scene
@onready var audioplayer = %audioplayer

func _ready() -> void:
	current_scene = $"../../current/mainmenu"

func change_current_scene_to(from, scene:PackedScene):
	current_scene = from
	
	self.visible = true
	tween_anim_modulate(self, 0.5,Tween.EASE_IN,1)
	await wait(0.5)
	
	from.queue_free()
	var instance = scene.instantiate()
	get_parent().get_parent().get_node("current").add_child(instance)
	
	tween_anim_modulate(self, 0.5,Tween.EASE_IN,0)
	await wait(0.5)
	self.visible = false

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func tween_anim_modulate(target, duration:float, easing, opacity:float):
	var tween = create_tween()
	tween.set_ease(easing)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(target, "modulate:a", opacity, duration)

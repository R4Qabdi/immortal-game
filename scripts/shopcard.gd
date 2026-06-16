extends TextureButton

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon

func setup(title:String, icon:String):
	texture_normal = load("res://assets/bg/card bg.png")
	texture_pressed = load("res://assets/bg/card bg on.png")
	texture_hover = load("res://assets/bg/card bg hover.png")
	itemName.text = title
	itemIcon.texture = load(icon)

extends TextureButton

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
var cardName:String

func _ready() -> void:
	ShopInstructions.reroll_cards.connect(_on_reroll)

func setup(title:String, icon:String):
	texture_normal = load("res://assets/bg/card bg.png")
	texture_pressed = load("res://assets/bg/card bg on.png")
	texture_hover = load("res://assets/bg/card bg hover.png")
	cardName = title
	itemName.text = title
	itemIcon.texture = load(icon)

func _on_pressed() -> void:
	disabled = true

func _on_reroll():
	disabled = false

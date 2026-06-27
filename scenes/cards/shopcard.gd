extends TextureButton
class_name ShopCard

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
var cardName:String
var cardType:int
var desc:String
var descWindow = load("res://scenes/card_details.tscn")
signal buy_Card(type:int, card:String)

func _ready() -> void:
	ShopInstructions.reroll_cards.connect(_on_reroll)
	

func setup(type:int ,title:String, icon:String):
	texture_normal = load("res://assets/bg/card bg.png")
	texture_pressed = load("res://assets/bg/card bg on.png")
	texture_hover = load("res://assets/bg/card bg hover.png")
	cardName = title
	cardType = type
	itemName.text = title
	itemIcon.texture = load(icon)

func _on_pressed() -> void:
	var details:CardDetails = descWindow.instantiate()
	add_child(details)
	details.setup(cardType, cardName, desc, 1)

func _on_reroll():
	disabled = false

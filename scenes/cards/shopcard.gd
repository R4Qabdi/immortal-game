extends TextureButton
class_name ShopCard

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
var cardName
var cardType:global.cardType
var strTitle
var desc:String
var detailsOverlayLayer
var descWindow = load("res://scenes/card_details.tscn")

func _ready() -> void:
	ShopInstructions.reroll_cards.connect(_on_reroll)
	detailsOverlayLayer = CanvasLayer.new()
	

func setup(type:global.cardType, title:Variant, icon:String):
	if type == global.cardType.ITEM:
		strTitle = global.ItemsData[title].name
	else:
		strTitle = global.UnitsData[title].name
	cardName = title
	cardType = type
	itemName.text = strTitle
	#itemIcon.texture = load(icon)

func _on_pressed() -> void:
	var details:CardDetails = descWindow.instantiate()
	detailsOverlayLayer.add_child(details)
	add_child(detailsOverlayLayer)
	details.setup(cardType, cardName, desc, 1)
	detailsOverlayLayer.layer = 100
	details.position = position

func _on_reroll():
	disabled = false

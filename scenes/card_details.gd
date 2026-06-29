extends TextureRect
class_name CardDetails

@onready var cardName:Label = $VBoxContainer/name
@onready var cardDesc:Label = $VBoxContainer/desc
@onready var buyButton:TextureButton = $"VBoxContainer/HBoxContainer/Buy Button"
@onready var useButton:TextureButton = $"VBoxContainer/HBoxContainer/Use Button"
var cardType: global.cardType
var cardEnum

func setup(type:global.cardType, card:Variant, desc:String, where:int):
	var strCard
	if type == global.cardType.ITEM:
		strCard = global.ItemsData[card].name
	else:
		strCard = global.UnitsData[card].name
	
	if where == 0:
		useButton.show()
		buyButton.hide()
	else:
		useButton.hide()
		buyButton.show()
	
	cardName.text = strCard
	cardDesc.text = desc
	cardType = type
	cardEnum = card

func _on_buy_button_pressed() -> void:
	ShopInstructions.buy_card.emit(cardType, cardEnum)
	queue_free()

func _on_use_button_pressed() -> void:
	if cardType == global.cardType.ITEM:
		var idx = InventoryInstructions.heldItems.find(cardEnum)
		InventoryInstructions.heldItems.remove_at(idx)
		queue_free()
	
	else:
		var idx = InventoryInstructions.heldUnits.find(cardEnum)
		InventoryInstructions.heldUnits.remove_at(idx)
		queue_free()

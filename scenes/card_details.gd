extends TextureRect
class_name CardDetails

@onready var cardName:Label = $VBoxContainer/name
@onready var cardDesc:Label = $VBoxContainer/desc
@onready var buyButton:TextureButton = $"VBoxContainer/HBoxContainer/Buy Button"
@onready var useButton:TextureButton = $"VBoxContainer/HBoxContainer/Use Button"
var cardType:int

func setup(type:int, card:String, desc:String, where:int):
	if where == 0:
		useButton.show()
		buyButton.hide()
	else:
		useButton.hide()
		buyButton.show()
	
	cardName.text = card
	cardDesc.text = desc
	cardType = type

func _on_buy_button_pressed() -> void:
	ShopInstructions.buy_card.emit(cardType, cardName.text)
	queue_free()

func _on_use_button_pressed() -> void:
	if cardType == 0:
		var idx = InventoryInstructions.playerItems.find(cardName)
		InventoryInstructions.playerItems.remove_at(idx)
		queue_free()
	
	else:
		var idx = InventoryInstructions.playerUnits.find(cardName)
		InventoryInstructions.playerUnits.remove_at(idx)
		queue_free()

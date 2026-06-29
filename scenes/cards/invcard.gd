extends TextureButton
class_name InventoryCard

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
@onready var card: InventoryCard = $"."
var cardName
var cardType:global.cardType
var desc:String
var descWindow = load("res://scenes/card_details.tscn")

func setup(title:Variant, type:global.cardType):
	var strTitle
	if type == global.cardType.ITEM:
		strTitle = global.ItemsData[title].name
	else:
		strTitle = global.UnitsData[title].name
	cardName = title
	cardType = type
	itemName.text = strTitle
	itemIcon.texture = load("res://assets/icons/"+strTitle+".png")
	#InventoryInstructions.inventory_card_selected.connect(_on_inventory_card_selected)

func _get_drag_data(at_position: Vector2) -> Variant:
	var texture = itemIcon.texture
	var preview = duplicate()
	set_drag_preview(preview)
	return card

func _on_pressed() -> void:
	var details:CardDetails = descWindow.instantiate()
	add_child(details)
	details.setup(cardType, cardName, desc, 0)

func card_activated():
	if cardType == global.cardType.ITEM:
		var idx = InventoryInstructions.heldItems.find(cardName)
		InventoryInstructions.heldItems.remove_at(idx)
	else:
		var idx = InventoryInstructions.heldUnits.find(cardName)
		InventoryInstructions.heldUnits.remove_at(idx)
	InventoryInstructions.use_card.emit(cardType, cardName)
	queue_free()

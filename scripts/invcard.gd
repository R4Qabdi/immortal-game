extends TextureButton
#ESA'S
@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
@onready var card: InventoryCard = $"."
var cardName:String
var cardType:int
var desc:String
var descWindow = load("res://scenes/card_details.tscn")

func setup(title:String, type:int):
	cardType = type
	cardName = title
	itemName.text = title
	itemIcon.texture = load("res://assets/icons/"+title+".png")

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
	queue_free()

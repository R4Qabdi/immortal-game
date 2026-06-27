extends TextureButton
class_name InventoryCard

var cardName:String
var cardType:int
var desc:String
var descWindow = load("res://scenes/card_details.tscn")

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
@onready var card: InventoryCard = $"."
func setup(title:String, type:int):
	texture_normal = load("res://assets/bg/card bg.png")
	texture_pressed = load("res://assets/bg/card bg on.png")
	texture_hover = load("res://assets/bg/card bg hover.png")
	itemName.text = title
	itemIcon.texture = load("res://assets/icons/"+title+".png")
	cardType = type
	cardName = title

func _get_drag_data(at_position: Vector2) -> Variant:
	var texture = itemIcon.texture
	var preview = duplicate()
	set_drag_preview(preview)
	return card
	
func card_activated():
	queue_free()

func _on_pressed() -> void:
	var details:CardDetails = descWindow.instantiate()
	add_child(details)
	details.setup(cardType, cardName, desc, 0)

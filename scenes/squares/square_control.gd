extends Control

@onready var square: Square = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is InventoryCard:
		if data.cardType == global.cardType.ITEM:
			if data.get_card_requirements(square):
				return true
		elif square.piece == null:
			return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data.cardType == global.cardType.UNIT:
		global.piece_requested.emit(data.itemName.text, square, false)
		data.card_activated()
	else:
		if square.piece != null:
			square.piece.itemEffect.append(data.cardName)
		else:
			square.itemEffect.append(data.cardName)
		data.card_activated()

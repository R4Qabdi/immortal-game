extends Control

@onready var square: Square = $".."

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
			print_debug(data.cardReq)
		else:
			square.itemEffect.append(data.cardName)
		data.card_activated()

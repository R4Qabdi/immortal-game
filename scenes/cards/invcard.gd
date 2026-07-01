extends TextureButton
class_name InventoryCard

@onready var itemName:Label = $Label
@onready var itemIcon:TextureRect = $Icon
@onready var card: InventoryCard = $"."
var cardName
var cardType:global.cardType
var cardReq:Array
var desc:String
var is_selected: bool = false

var descWindow = load("res://scenes/card_details.tscn")
var normal_texture = preload("res://assets/bg/card bg.png")
var selected_texture = preload("res://assets/bg/card bg on.png")

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
	cardReq = global.ItemsData[title].useOn
	#InventoryInstructions.inventory_card_selected.connect(_on_inventory_card_selected)

func _get_drag_data(at_position: Vector2) -> Variant:
	var texture = itemIcon.texture
	var preview = duplicate()
	set_drag_preview(preview)
	return card

func _on_pressed() -> void:
	set_selected_visual(true)
	InventoryInstructions.inventory_card_selected.emit(self)
	is_selected = true
	# if not get_details_child_idkkkkk:
	# 	return
	# var details:CardDetails = descWindow.instantiate()
	# add_child(details)
	# details.setup(cardType, cardName, desc, 0)

func set_selected_visual(selected: bool) -> void:
	if selected: # make different
		itemIcon.modulate = Color(1, 1, 1, 0.2)
	else:	# make normal
		itemIcon.modulate = Color(1, 1, 1, 1)

func card_activated():
	if cardType == global.cardType.ITEM:
		var idx = InventoryInstructions.heldItems.find(cardName)
		InventoryInstructions.heldItems.remove_at(idx)
	else:
		var idx = InventoryInstructions.heldUnits.find(cardName)
		InventoryInstructions.heldUnits.remove_at(idx)
	InventoryInstructions.use_card.emit(cardType, cardName)
	queue_free()

func get_card_requirements(tile:Square) -> bool:
	match cardReq[0]:
		global.useTypes.OWN:
			if tile.piece == null:
				return false
			elif tile.piece.is_enemy:
				return false
			elif len(cardReq) > 1:
				if tile.piece.type == global.piecesData[cardReq[0]].name:
					return true
			else:
				return true
		global.useTypes.ENEMY:
			if tile.piece == null:
				return false
			elif not tile.piece.is_enemy:
				return false
			elif len(cardReq) > 1:
				if tile.piece.type == global.piecesData[cardReq[0]].name:
					return true
			else:
				return true
		global.useTypes.SQUARE:
			if tile.piece != null:
				return false
			else:
				return true
		global.useTypes.SELF:
			return true
	return false

func deselect_card(): # triggered by Inventory
	is_selected = false
	set_selected_visual(false)

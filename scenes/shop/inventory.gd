extends HBoxContainer
class_name Inventory
var card = load("res://scenes/cards/invcard.tscn")

func _ready() -> void:
	InventoryInstructions.change_inventory.connect(_on_inventory_change)
	redrawInv(InventoryInstructions.heldItems, global.cardType.ITEM)

func redrawInv(ownedCards:Array, type:global.cardType):
	var spawned:int = 0
	var spName
	while spawned < len(ownedCards):
		if type == global.cardType.ITEM:
			spName = global.ItemsData[ownedCards[spawned]].name
		else:
			spName = global.UnitsData[ownedCards[spawned]].name
		
		var spawnedCard:InventoryCard = card.instantiate()
		add_child(spawnedCard)
		spawnedCard.name = spName
		spawnedCard.setup(ownedCards[spawned], type)
		spawned += 1

func clearInv():
	var spawned:int = 0
	var allChildren = get_children()
	while spawned < len(allChildren):
		allChildren[spawned].queue_free()
		spawned += 1

func _on_inventory_change(type:global.cardType):
	var cards
	if type == global.cardType.ITEM:
		cards = InventoryInstructions.heldItems
	else:
		cards = InventoryInstructions.heldUnits
	#print_debug(len(cards))	
	clearInv()
	redrawInv(cards, type)
	

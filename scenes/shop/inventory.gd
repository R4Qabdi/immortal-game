extends HBoxContainer
class_name Inventory
var card = load("res://scenes/cards/invcard.tscn")

func _ready() -> void:
	InventoryInstructions.change_inventory.connect(_on_inventory_change)
	ShopInstructions.shop_exit.connect(_on_shop_exit)
	redrawInv(InventoryInstructions.heldItems, 0)	
	#var spawnedCard:InventoryCard = card.instantiate()
	#add_child(spawnedCard)
	#spawnedCard.setup("cowardice")

func redrawInv(ownedCards:Array, type:int):
	var spawned:int = 0	
	while spawned < len(ownedCards):
		var spawnedCard:InventoryCard = card.instantiate()
		add_child(spawnedCard)
		spawnedCard.name = ownedCards[spawned]
		spawnedCard.setup(ownedCards[spawned], type)
		spawned += 1

func clearInv():
	var spawned:int = 0
	var allChildren = get_children()
	while spawned < len(allChildren):
		allChildren[spawned].queue_free()
		spawned += 1

func _on_inventory_change(type:int):
	var cards
	if type == 0:
		cards = InventoryInstructions.playerItems
	else:
		cards = InventoryInstructions.playerUnits
	#print_debug(len(cards))	
	clearInv()
	redrawInv(cards, type)
	

func _on_shop_exit():
	InventoryInstructions.change_inventory.emit(0)

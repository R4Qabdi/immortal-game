extends HBoxContainer

func _ready() -> void:
	InventoryInstructions.change_inventory.connect(_on_inventory_change)

func redrawInv(ownedCards:Array, type:int):
	var card = load("res://scenes/invcard.tscn")
	var spawned:int = 0
	
	#if type == 1:
		#var
	
	while spawned < len(ownedCards):
		var spawnedCard = card.instatiate()
		add_child(spawnedCard)
		spawnedCard.setup(ownedCards[spawned])
		spawned += 1

func _on_inventory_change(type:int):
	var cards
	if type == 0:
		cards = InventoryInstructions.playerItems
	else:
		cards = InventoryInstructions.playerUnits
	redrawInv(cards, type)

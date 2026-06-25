extends HBoxContainer

var card = load("res://scenes/invcard.tscn")

func _ready() -> void:
	InventoryInstructions.change_inventory.connect(_on_inventory_change)
	redrawInv(InventoryInstructions.playerItems, 0)
	#var spawnedCard:InventoryCard = card.instantiate()
	#add_child(spawnedCard)
	#spawnedCard.setup("cowardice")

func redrawInv(ownedCards:Array, type:int):
	var spawned:int = 0
	
	#if type == 1:
		#var
	
	while spawned < len(ownedCards):
		var spawnedCard:InventoryCard = card.instantiate()
		add_child(spawnedCard)
		spawnedCard.name = ownedCards[spawned]
		spawnedCard.setup(ownedCards[spawned])
		spawnedCard.scale = Vector2(0.592, 0.592)
		spawned += 1

func _on_inventory_change(type:int):
	var cards
	if type == 0:
		cards = InventoryInstructions.playerItems
	else:
		cards = InventoryInstructions.playerUnits
	print_debug(len(cards))
	redrawInv(cards, type)

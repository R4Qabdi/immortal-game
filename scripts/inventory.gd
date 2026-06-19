extends HBoxContainer

func updateInv(ownedCards:Array, type:int):
	var card = load("res://scenes/invcard.tscn")
	var spawned:int = 0
	
	#if type == 1:
		#var
	
	while spawned < len(ownedCards):
		var spawnedCard = card.instatiate()
		add_child(spawnedCard)
		spawnedCard.setup(ownedCards[spawned])
		spawned += 1

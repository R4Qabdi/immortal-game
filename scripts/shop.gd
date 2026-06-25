extends Control
class_name Shop

@onready var wSelectionBG:TextureRect = $"Shop BG"
@onready var nextButton:BaseButton = $"Shop BG/Buttons Container/Continue"
@onready var UC1:TextureButton = $"Shop BG/Units Container/Unit Card1"
@onready var UC2:TextureButton = $"Shop BG/Units Container/Unit Card2"
@onready var UC3:TextureButton = $"Shop BG/Units Container/Unit Card3"
@onready var IC1:TextureButton = $"Shop BG/Items Container/Item Card1"
@onready var IC2:TextureButton = $"Shop BG/Items Container/Item Card2"
@onready var IC3:TextureButton = $"Shop BG/Items Container/Item Card3"

var picked:bool
var nextScene:String
var selected:Array = []
var selectedIcons:Array = []
var selectedCDs:Array = []
const units:Array = ["queen", "rook", "bishop", "knight", "pawn", "guards", "wizard", "wall"]
const items:Array = [
	"astral projection", "berserk", "I can't stop", "oops", "skipped leg day", 
	"voodoo", "cowardice", "black hole", "life insurance"
	]
const unitIcons:Array = [
	"res://assets/icons/queen.png", "res://assets/icons/rook.png", 
	"res://assets/icons/bishop.png", "res://assets/icons/knight.png", 
	"res://assets/icons/pawn.png", "res://assets/icons/guards.png", 
	"res://assets/icons/wizard.png", "res://assets/icons/wall.png"
	]
const itemIcons:Array = [
	"res://assets/icons/astral projection.png", "res://assets/icons/berserk.png",
	"res://assets/icons/I can't stop.png", "res://assets/icons/oops.png",
	"res://assets/icons/skipped leg day.png", "res://assets/icons/voodoo.png",
	"res://assets/icons/cowardice.png", "res://assets/icons/black hole.png",
	"res://assets/icons/life insurance.png"
	]

func _ready() -> void:
	setup(ShopInstructions.data)

func setup(instructions:Dictionary) -> void:
	nextScene = "res://scenes/" + instructions["next"] + ".tscn"
	#nextButton.disabled = true
	if selected.size() >= 3:
		selected = []
		selectedCDs = []
		selectedIcons = []
	
	wSelectionBG.show()
	while selected.size() < 3:
		var pick = units.pick_random()
		if pick not in selected:
			var index = units.find(pick)
			selected.append(pick)
			selectedCDs.append(0)
			selectedIcons.append(unitIcons[index])
	
	UC1.setup(selected[0], selectedIcons[0])
	UC2.setup(selected[1], selectedIcons[1])
	UC3.setup(selected[2], selectedIcons[2])
	selected = []
	selectedCDs = []
	selectedIcons = []
	
	while selected.size() < 3:
		var pick = items.pick_random()
		if pick not in selected:
			var index = items.find(pick)
			selected.append(pick)
			selectedCDs.append(0)
			selectedIcons.append(itemIcons[index])
	
	IC1.setup(selected[0], selectedIcons[0])
	IC2.setup(selected[1], selectedIcons[1])
	IC3.setup(selected[2], selectedIcons[2])
	

func _process(_delta: float) -> void:
	pass

func FillData(itemID:String, cd:float):
	ShopInstructions.playerData = {}
	ShopInstructions.playerData = {
		"type": ShopInstructions.data["type"],
		"ID": itemID,
		"CDs": cd
	}

func on_card_bought(type:int, card:String):
	if type == 0:
		InventoryInstructions.playerUnits.append(card)
	else:
		InventoryInstructions.playerItems.append(card)
	
	FillData(card, 0.0)

func _on_continue_pressed() -> void:
	ShopInstructions.shop_exit.emit()
	queue_free()

func _on_upgrade_pressed() -> void:
	hide()
	InventoryInstructions.change_inventory.emit(1)

func _on_reroll_pressed() -> void:
	setup(ShopInstructions.data)
	ShopInstructions.reroll_cards.emit()
	

func _on_item_card_1_pressed() -> void:
	on_card_bought(0, IC1.cardName)

func _on_item_card_2_pressed() -> void:
	on_card_bought(0, IC2.cardName)

func _on_item_card_3_pressed() -> void:
	on_card_bought(0, IC3.cardName)

func _on_unit_card_1_pressed() -> void:
	on_card_bought(1, UC1.cardName)

func _on_unit_card_2_pressed() -> void:
	on_card_bought(1, UC2.cardName)

func _on_unit_card_3_pressed() -> void:
	on_card_bought(1, UC3.cardName)

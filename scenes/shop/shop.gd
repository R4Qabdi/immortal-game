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

var cards
var picked:bool
var nextScene:String
var selected:Array = []
var selectedIcons:Array = []
var selectedCDs:Array = []
var units:Array = []
var items:Array = []

func _ready() -> void:
	setup()
	ShopInstructions.back_to_shop.connect(_on_back_to_shop)
	ShopInstructions.buy_card.connect(_on_card_bought)

func setup() -> void:
	units = global.unitCards.keys()
	items = global.itemCards.keys()
	if selected.size() >= 3:
		selected = []
		selectedCDs = []
		selectedIcons = []
	
	wSelectionBG.show()
	while selected.size() < 3:
		var pick:global.unitCards = global.unitCards.values().pick_random()
		if not selected.has(pick) and not InventoryInstructions.heldUnits.has(pick):
			selected.append(pick)
			selectedIcons.append("res://assets/icons/"+units[pick]+".png")
	
	UC1.setup(global.cardType.UNIT, selected[0], selectedIcons[0])
	UC2.setup(global.cardType.UNIT, selected[1], selectedIcons[1])
	UC3.setup(global.cardType.UNIT, selected[2], selectedIcons[2])
	selected = []
	selectedCDs = []
	selectedIcons = []
	
	while selected.size() < 3:
		var pick:global.itemCards = global.itemCards.values().pick_random()
		if not selected.has(pick) and not InventoryInstructions.heldItems.has(pick):
			selected.append(pick)
			selectedIcons.append("res://assets/icons/"+items[pick]+".png")
	
	IC1.setup(global.cardType.ITEM, selected[0], selectedIcons[0])
	IC2.setup(global.cardType.ITEM, selected[1], selectedIcons[1])
	IC3.setup(global.cardType.ITEM, selected[2], selectedIcons[2])

func _on_card_bought(type:global.cardType, card:Variant):
	if type == global.cardType.ITEM:
		InventoryInstructions.heldItems.append(card)
	else:
		InventoryInstructions.heldUnits.append(card)

func _on_continue_pressed() -> void:
	ShopInstructions.shop_exit.emit()
	InventoryInstructions.change_inventory.emit(global.cardType.ITEM)
	queue_free()

func _on_upgrade_pressed() -> void:
	hide()
	InventoryInstructions.change_inventory.emit(global.cardType.UNIT)

func _on_reroll_pressed() -> void:
	setup()
	ShopInstructions.reroll_cards.emit()

func _on_back_to_shop():
	show()
	InventoryInstructions.change_inventory.emit(global.cardType.ITEM)

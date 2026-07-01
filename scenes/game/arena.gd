extends Node2D

var tile
var shopOverlayLayer
var shopMenu = load("res://scenes/shop/shop.tscn")
@onready var shopButton:TextureButton = $"hud/shop button"
@onready var shopBack:TextureButton = $"hud/Back to Shop"
@onready var inventory:Inventory = $hud/bottom/cardhandler/HBoxContainer
@onready var squares: Board = $squares
#@onready var pieces:Pieces = $pieces

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var pick:global.unitCards = global.unitCards.keys().pick_random()
	#print_debug(pick)
	#print_debug(typeof(pick))
	shopOverlayLayer = CanvasLayer.new()
	ShopInstructions.shop_exit.connect(_on_shop_exit)
	shopBack.disabled = true
	shopBack.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shop_button_pressed() -> void:
	var menu = shopMenu.instantiate()
	shopOverlayLayer.add_child(menu)
	add_child(shopOverlayLayer)
	shopButton.disabled = true
	shopButton.hide()
	shopBack.show()
	shopBack.disabled = false

func _on_shop_exit():
	shopOverlayLayer.queue_free()
	shopOverlayLayer = CanvasLayer.new()
	shopButton.show()
	shopButton.disabled = false
	shopBack.disabled = true
	shopBack.hide()

#func newSelect():
	#newSquare
	##validasi if baru ada piece
	#if selected.piece: #validasi jika udah pernah ada select piece
		#selected.unselect()
	#selected = newSquare
	#selected.select()

func _on_back_to_shop() -> void:
	ShopInstructions.back_to_shop.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not event.pressed:
		if inventory.selectedCard != null:
			print_debug("Inventory card deselected due to touch outside")
			InventoryInstructions.inventory_card_selected.emit(null)

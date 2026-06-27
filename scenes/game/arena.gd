extends Node2D

var tile
var shopOverlayLayer
var shopMenu = load("res://scenes/shop/shop.tscn")
@onready var shopButton:TextureButton = $"shop button"
@onready var shopBack:TextureButton = $"Back to Shop"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shopOverlayLayer = CanvasLayer.new()
	ShopInstructions.shop_exit.connect(_on_shop_exit)
	shopBack.disabled = true
	shopBack.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	ShopInstructions.data = {
		"type": 0,
		"next": "arena",
	}
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

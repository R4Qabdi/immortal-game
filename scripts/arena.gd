extends Node2D

var tile
var shopOverlayLayer
var shopMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shopOverlayLayer = CanvasLayer.new()
	shopMenu = load("res://scenes/shop.tscn")

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
	get_tree().root.add_child(shopOverlayLayer)
	#get_tree().paused = true

#func newSelect():
	#newSquare
	##validasi if baru ada piece
	#if selected.piece: #validasi jika udah pernah ada select piece
		#selected.unselect()
	#selected = newSquare
	#selected.select()

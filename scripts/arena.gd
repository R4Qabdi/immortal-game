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
	var prefTile:int = 0
	for i in range(8):
		for j in range(8):
			if prefTile == 0:
				#tile.color = Color.WHITE
				prefTile = 1
				# spawn tile
				# tile.pos.x = tile.size.x * j
				# tile.pos.y = tile.size.x * -1
			else:
				#tile.color = Color.BLACK
				prefTile = 0
				# spawn tile
				# tile.pos.x = tile.size.x * j
				# tile.pos.y = tile.size.x * -1
		

func _on_texture_button_pressed() -> void:
	ShopInstructions.data = {
		"type": 0,
		"next": "arena",
	}
	var menu = shopMenu.instantiate()
	shopOverlayLayer.add_child(menu)
	get_tree().root.add_child(shopOverlayLayer)
	#get_tree().paused = true

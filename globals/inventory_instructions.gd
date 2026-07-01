extends Node

var maxItems:int = 6
var heldItems:Array[global.itemCards] = []
var heldUnits:Array[global.unitCards] = []

signal change_inventory(type:global.cardType)
signal inventory_card_selected(card:InventoryCard)
signal use_card(type:global.cardType, card:Variant)
signal _unit_drop_attempted(square: Square, card: InventoryCard)
signal _unit_pieces_requested(squares: Array[Square], unitCard: global.unitCards, is_enemy: bool)

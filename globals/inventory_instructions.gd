extends Node

var heldItems:Array[global.itemCards] = []
var heldUnits:Array[global.unitCards] = []

signal change_inventory(type:global.cardType)
signal inventory_card_selected(card:InventoryCard)
signal use_card(type:global.cardType, card:Variant)

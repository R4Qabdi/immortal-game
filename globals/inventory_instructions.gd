extends Node

var heldItems:Array = []
var heldUnits:Array = []

signal change_inventory(type:int)
signal inventory_card_selected(card: InventoryCard)
signal use_card(type:int, card:String)

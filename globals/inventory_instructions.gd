extends Node

var playerItems:Array = []
var playerUnits:Array = []

signal change_inventory(type:int)
signal use_card(type:int, card:String)

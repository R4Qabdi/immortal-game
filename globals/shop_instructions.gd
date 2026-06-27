extends Node

var data:Dictionary = {}
var playerData:Dictionary = {}

signal reroll_cards()
signal shop_exit()
signal back_to_shop()
signal buy_card(type:int, card:String)

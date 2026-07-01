extends Node

signal piece_requested(type: String, which_square: Square, is_enemy: bool)
signal piece_added(type: String, which_square: Square, is_enemy: bool)

enum pieceTypes {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}

class PieceData:
	var name: String
	func _init(p_name: String):
		name = p_name
var piecesData: Dictionary[pieceTypes, PieceData] = {
	pieceTypes.PAWN: PieceData.new("Pawn"),
	pieceTypes.ROOK: PieceData.new("Rook"),
	pieceTypes.KNIGHT: PieceData.new("Knight"),
	pieceTypes.BISHOP: PieceData.new("Bishop"),
	pieceTypes.QUEEN: PieceData.new("Queen"),
	pieceTypes.KING: PieceData.new("King")
}
# example usage:
# var pawnName = piecesData[pieceTypes.PAWN].name

enum cardType {ITEM, UNIT}

enum unitCards {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, GUARDS, WIZARD, WALL}

class UnitData:
	var name: String
	func _init(p_name: String):
		name = p_name
var UnitsData: Dictionary[unitCards, UnitData] = {
	unitCards.PAWN: UnitData.new("Pawn"),
	unitCards.ROOK: UnitData.new("Rook"),
	unitCards.KNIGHT: UnitData.new("Knight"),
	unitCards.BISHOP: UnitData.new("Bishop"),
	unitCards.QUEEN: UnitData.new("Queen"),
	unitCards.GUARDS: UnitData.new("Guards"),
	unitCards.WIZARD: UnitData.new("Wizard"),
	unitCards.WALL: UnitData.new("Wall")
}

enum itemCards {
	ASTRAL_PROJECTION, BERSERK, I_CANT_STOP, OOPS, SKIPPED_LEG_DAY, 
	VOODOO, BULLY, BLACK_HOLE, LIFE_INSURANCE
	}

class ItemData:
	var name: String
	var funcName: Callable
	func _init(p_name: String, p_funcName:Callable):
		name = p_name
		funcName = p_funcName

var ItemsData: Dictionary[itemCards, ItemData] = {}

func _ready() -> void:
	ItemsData = {
		itemCards.ASTRAL_PROJECTION: ItemData.new("astral projection", ItemEffectsInstructions.AstralProject),
		itemCards.BERSERK: ItemData.new("berserk", ItemEffectsInstructions.Berserk),
		itemCards.I_CANT_STOP: ItemData.new("I can't stop", ItemEffectsInstructions.CantStop),
		itemCards.OOPS: ItemData.new("oops", ItemEffectsInstructions.Oops),
		itemCards.SKIPPED_LEG_DAY: ItemData.new("skipped leg day", ItemEffectsInstructions.ThinLegs),
		itemCards.VOODOO: ItemData.new("voodoo", ItemEffectsInstructions.Voodoo),
		itemCards.BULLY: ItemData.new("bully", ItemEffectsInstructions.Bully),
		itemCards.BLACK_HOLE: ItemData.new("black hole", ItemEffectsInstructions.BlackHole),
		itemCards.LIFE_INSURANCE: ItemData.new("life insurance", ItemEffectsInstructions.Insurance)
	}

extends Node

signal piece_requested(type: String, which_square: Square, is_enemy: bool)
signal piece_added(type: String, which_square: Square, is_enemy: bool)
#signal applyItems(on_what:Variant, specification:String)

enum pieceTypes {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
enum useTypes {OWN, ENEMY, SQUARE, SELF}

class PieceData:
	var name: String
	func _init(p_name: String):
		name = p_name
var piecesData: Dictionary[pieceTypes, PieceData] = {
	pieceTypes.PAWN: PieceData.new("pawn"),
	pieceTypes.ROOK: PieceData.new("rook"),
	pieceTypes.KNIGHT: PieceData.new("knight"),
	pieceTypes.BISHOP: PieceData.new("bishop"),
	pieceTypes.QUEEN: PieceData.new("queen"),
	pieceTypes.KING: PieceData.new("king")
}
# example usage:
# var pawnName = piecesData[pieceTypes.PAWN].name

enum cardType {ITEM, UNIT}

enum unitCards {NONE, PAWN, ROOK, KNIGHT, BISHOP, QUEEN, GUARDS, WIZARD, WALL, BOSS}

class UnitCardData:
	var name: String
	func _init(p_name: String):
		name = p_name
var UnitsData: Dictionary[unitCards, UnitData] = {
	unitCards.PAWN: UnitData.new("pawn"),
	unitCards.ROOK: UnitData.new("rook"),
	unitCards.KNIGHT: UnitData.new("knight"),
	unitCards.BISHOP: UnitData.new("bishop"),
	unitCards.QUEEN: UnitData.new("queen"),
	unitCards.GUARDS: UnitData.new("guards"),
	unitCards.WIZARD: UnitData.new("wizard"),
	unitCards.WALL: UnitData.new("wall")
}

enum itemCards {
	NONE, ASTRAL_PROJECTION, BERSERK, I_CANT_STOP, OOPS, SKIPPED_LEG_DAY, 
	VOODOO, BULLY, BLACK_HOLE, LIFE_INSURANCE
	}

class ItemData:
	var name: String
	var funcName: Callable
	var useOn: Array
	func _init(p_name: String, p_funcName:Callable, p_use:Array):
		name = p_name
		funcName = p_funcName
		useOn = p_use

var ItemsData: Dictionary[itemCards, ItemData] = {}

func _ready() -> void:
	ItemsData = {
		itemCards.NONE: ItemData.new(
			"none", 
			Callable(),
			[]
			),
		itemCards.ASTRAL_PROJECTION: ItemData.new(
			"astral projection", 
			ItemEffectsInstructions.AstralProject,
			[useTypes.OWN]
			),
		itemCards.BERSERK: ItemData.new(
			"berserk", 
			ItemEffectsInstructions.Berserk, 
			[useTypes.SELF]
			),
		itemCards.I_CANT_STOP: ItemData.new(
			"I can't stop", 
			ItemEffectsInstructions.CantStop, 
			[useTypes.OWN, pieceTypes.ROOK]
			),
		itemCards.OOPS: ItemData.new(
			"oops", 
			ItemEffectsInstructions.Oops,
			[useTypes.OWN, pieceTypes.KING]
			),
		itemCards.SKIPPED_LEG_DAY: ItemData.new(
			"skipped leg day", 
			ItemEffectsInstructions.ThinLegs,
			[useTypes.SELF]
			),
		itemCards.VOODOO: ItemData.new(
			"voodoo", 
			ItemEffectsInstructions.Voodoo,
			[useTypes.ENEMY]
			),
		itemCards.BULLY: ItemData.new(
			"cocky", 
			ItemEffectsInstructions.Bully,
			[useTypes.OWN]
			),
		itemCards.BLACK_HOLE: ItemData.new(
			"black hole", 
			ItemEffectsInstructions.BlackHole,
			[useTypes.SQUARE]
			),
		itemCards.LIFE_INSURANCE: ItemData.new(
			"life insurance", 
			ItemEffectsInstructions.Insurance,
			[useTypes.SELF]
			)
	}

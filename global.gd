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
	var pieces: Array[UnitCardPieces] = []
	func _init(p_name: String, p_piecesData: Array[UnitCardPieces] = []): # optional p_piecesData array for multiple pieces.
		name = p_name
		pieces = p_piecesData
class UnitCardPieces:
	var rowDistance: int
	var colDistance: int
	var pieceType: pieceTypes
	var pieceAddFunc: Callable

	func _init(p_pieceType: pieceTypes, p_rowDistance: int = 0, p_colDistance: int = 0, p_addFunc: Callable = Callable()):
		rowDistance = p_rowDistance
		colDistance = p_colDistance
		pieceType = p_pieceType
		pieceAddFunc = p_addFunc

@onready var unitCardsData: Dictionary[unitCards, UnitCardData] = {
	unitCards.NONE: UnitCardData.new("none"),
	unitCards.PAWN: UnitCardData.new("pawn", [UnitCardPieces.new(pieceTypes.PAWN)]),
	unitCards.ROOK: UnitCardData.new("rook", [UnitCardPieces.new(pieceTypes.ROOK)]),
	unitCards.KNIGHT: UnitCardData.new("knight", [UnitCardPieces.new(pieceTypes.KNIGHT)]),
	unitCards.BISHOP: UnitCardData.new("bishop", [UnitCardPieces.new(pieceTypes.BISHOP)]),
	unitCards.QUEEN: UnitCardData.new("queen", [UnitCardPieces.new(pieceTypes.QUEEN)]),
	unitCards.GUARDS: UnitCardData.new("guards",
		[
			UnitCardPieces.new(pieceTypes.PAWN, 0, 0),
			UnitCardPieces.new(pieceTypes.PAWN, 1, -1),
			UnitCardPieces.new(pieceTypes.PAWN, 1, 1)
		]
	),
	unitCards.WIZARD: UnitCardData.new("wizard",
		[
			UnitCardPieces.new(pieceTypes.BISHOP)
		]
	),
	unitCards.WALL: UnitCardData.new("wall",
		[
			UnitCardPieces.new(pieceTypes.ROOK)
		]
	),
	unitCards.BOSS: UnitCardData.new("boss",
		[
			UnitCardPieces.new(pieceTypes.QUEEN, 0, 0, addUnitBoss)
		]
	)
}

func addUnitBoss(newpiece: Piece):
	newpiece.hp *= 10
	print_debug("add unit boss")

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

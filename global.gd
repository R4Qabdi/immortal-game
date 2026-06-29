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

enum unitCards {PAWN, ROOK, KNIGHT, BISHOP, QUEEN}

enum itemCards {}

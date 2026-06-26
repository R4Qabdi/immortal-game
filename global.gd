extends Node

signal piece_requested(type: String, which_square: Square, is_enemy: bool)
signal piece_added(type: String, which_square: Square, is_enemy: bool)
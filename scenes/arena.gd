extends Node2D


#func newSelect():
	#newSquare
	##validasi if baru ada piece
	#if selected.piece: #validasi jika udah pernah ada select piece
		#selected.unselect()
	#selected = newSquare
	#selected.select()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

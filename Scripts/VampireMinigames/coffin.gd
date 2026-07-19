extends CharacterBody3D

func _ready() -> void:
	hide()



signal coffin_interacted(coffin)

func interacted():
	coffin_interacted.emit(self)

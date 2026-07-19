extends CharacterBody3D

@export var answer = 20

func _ready() -> void:
	hide()

signal coffin_interacted(coffin)

func interacted():
	coffin_interacted.emit(self)

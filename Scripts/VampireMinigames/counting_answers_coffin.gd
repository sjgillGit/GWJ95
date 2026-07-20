extends CharacterBody3D

@export var answer = 20
@onready var label_3d: Label3D = $Label3D

func _ready() -> void:
	hide()

signal coffin_interacted(coffin)

func interacted():
	coffin_interacted.emit(self)

func set_text():
	label_3d.text = str(answer)

	# Make text black
	label_3d.modulate = Color.BLACK

	# Make text bigger
	label_3d.font_size = 64  # Adjust to your desired size

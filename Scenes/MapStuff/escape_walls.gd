extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = 50
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Manager.mode == "escape":
		show()
		position.y = 0

extends StaticBody3D

@onready var cutscene_manager: Node3D = $"../CutsceneManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interacted():
	if Manager.treasure_room_event == true:
		pass
	else:
		Manager.treasure_room_event = true
		Manager.mode = "escape"
		cutscene_manager.treasure_room_cutscene()

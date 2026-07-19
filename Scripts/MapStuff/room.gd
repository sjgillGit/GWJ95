extends Node3D

@export var special_room = "false"
@export var target_position = Vector3(0,0,0)
@onready var VampireGame: Node3D = $"../../../VampireGame"
@onready var cutscene_manager: Node3D = $"../../../CutsceneManager"
@onready var player: Tetris_player = $"../../../Player"



#special rooms are start, vampire, skeleton, treasure, and possibly goblins

#var x_camera_pos = position.x
#var z_camera_paos = position.z + 8
#
var camera_pos = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_pos  = Vector3(target_position.x,20,target_position.z + 8)
	position = target_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func detect_special():
	if special_room != "false":
		if special_room == "start":
			pass
		elif special_room == "skeleton":
			if Manager.skeleton_key == false:
				cutscene_manager.skeleton_cutscene_explore()
			elif Manager.skeleton_escape_done == false:
				cutscene_manager.skeleton_cutscene_escape()
		elif special_room == "vampire":
			if Manager.vampire_key == false:
				cutscene_manager.vampire_cutscene_explore()
			elif Manager.vampire_escape_done == false:
				cutscene_manager.vampire_cutscene_escape()

			
		elif special_room == "treasure":
			pass
				

extends Node3D

@onready var player = $"../Player"
@onready var first_spawner: Node3D = $"../Map/Rooms/Treasure Room/SlimeSpawner1"

func _ready():
	for spawner in get_tree().get_nodes_in_group("slime_spawners"):
		spawner.escape_reset.connect(_on_escape_reset)


func _on_escape_reset():
	print("RESET ESCAPE")

	player.reset_position()

	first_spawner.reset_chain()
	for spawner in get_tree().get_nodes_in_group("slime_spawners"):
		spawner.clear_slime()
	set_variables_escape()
	first_spawner.spawn_slime()

func set_variables_escape():
	Manager.mode = "escape" #explore or escape
	Manager.setting = "map" #map or arena
	Manager.vampire_key = true
	Manager.skeleton_key = true
	Manager.treasure_room_event = true
	Manager.vampire_escape_done = false
	Manager.skeleton_escape_done = false
	Manager.duo_explore_done = true
	Manager.duo_escape_done = false
	Manager.current_enemy = ""

func lose():
	if Manager.mode == "explore":
		Manager.mode = "explore" #explore or escape
		Manager.setting = "map" #map or arena
		Manager.vampire_key = false
		Manager.skeleton_key = false
		Manager.treasure_room_event = false
		Manager.vampire_escape_done = false
		Manager.skeleton_escape_done = false
		Manager.duo_explore_done = false
		Manager.duo_escape_done = false
		Manager.current_enemy = ""
		player.position = Vector3(-40,1,0)
	else:
		set_variables_escape()

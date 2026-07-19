extends Node3D
@onready var bat_hunt_scene: Node3D = $BatHuntScene
@onready var pong: Node3D = $Pong
@onready var player: CharacterBody3D = $Player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_bat_hunt_scene_1():
	Manager.current_enemy = "vampire"
	Manager.setting = "arena"
	bat_hunt_scene.start_game()

func start_pong_1():
	Manager.current_enemy = "skeleton"
	pong.start_game()


func reverse_to_map_1():
	Manager.duo_explore_done = true
	Manager.setting = "map"
	player.position = Vector3(90,0,-30)
	Manager.current_enemy = ""


func start_bat_hunt_scene_2():
	Manager.current_enemy = "vampire"
	Manager.setting = "arena"
	bat_hunt_scene.start_game()

func start_pong_2():
	Manager.current_enemy = "skeleton"
	pong.start_game()


func reverse_to_map_2():
	Manager.duo_escape_done = true
	Manager.setting = "map"
	player.position = Vector3(30,0,30)
	Manager.current_enemy = ""

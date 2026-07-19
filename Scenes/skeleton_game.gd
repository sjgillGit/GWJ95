extends Node3D
@onready var tetris: Node3D = $Tetris
@onready var fishing: Node2D = $Fishing
@onready var player: CharacterBody3D = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_tetris_1():
	Manager.setting = "arena"
	tetris.start_game()

func start_fishing_1():
	fishing.start_game()


func reverse_to_map_1():
	Manager.skeleton_key = true
	Manager.setting = "map"
	player.position = Vector3(30,0,30)
	Manager.current_enemy = ""


func start_tetris_2():
	Manager.setting = "arena"
	tetris.start_game()

func start_fishing_2():
	fishing.start_game()


func reverse_to_map_2():
	Manager.skeleton_escape_done = true
	Manager.setting = "map"
	player.position = Vector3(90,0,-30)
	Manager.current_enemy = ""

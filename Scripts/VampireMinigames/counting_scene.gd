extends Node3D

@onready var spawner = $BatCounterSpawner
@onready var coffin_1: CharacterBody3D = $Coffin1
@onready var coffin_2: CharacterBody3D = $Coffin2
@onready var coffin_3: CharacterBody3D = $Coffin3
@onready var cutscene_manager: Node3D = $"../../CutsceneManager"
@onready var win_lost_manager: Node3D = $"../../WinLostManager"

var bat_count := 0
var answer_options = []


func _ready() -> void:
	coffin_1.coffin_interacted.connect(_on_coffin_interacted)
	coffin_2.coffin_interacted.connect(_on_coffin_interacted)
	coffin_3.coffin_interacted.connect(_on_coffin_interacted)
	coffin_1.hide()
	coffin_2.hide()
	coffin_3.hide()
	coffin_1.position = Vector3(0,-20,0)
	coffin_2.position = Vector3(0,-20,0)
	coffin_3.position = Vector3(0,-20,0)
	spawner.bat_spawned.connect(_on_bat_spawned)
	spawner.spawning_finished.connect(_on_spawning_finished)
	
	

	var total_bats = randi_range(10,20) if Manager.mode == "explore" else randi_range(15,25)

	spawner.total_bats = total_bats
	spawner.spawn_delay = 0.4 if Manager.mode == "explore" else 0.3

func start_game():
	position = Vector3(0,0,0)
	spawner.start_spawning()


func _on_bat_spawned():
	bat_count += 1


func _on_spawning_finished():

	generate_answers(bat_count)

func generate_answers(bat_count):
	answer_options.clear()
	var possible = []
	for i in range(11):
		i += 10 if Manager.mode == "explore" else 15
		possible.append(i)
	
	answer_options.append(bat_count)
	answer_options.append(possible.pick_random())
	answer_options.append(possible.pick_random())
	
	answer_options.shuffle()
	
	coffin_1.answer = answer_options[0]
	coffin_2.answer = answer_options[1]
	coffin_3.answer = answer_options[2]
	
	coffin_1.show()
	coffin_2.show()
	coffin_3.show()
	
	coffin_1.set_text()
	coffin_2.set_text()
	coffin_3.set_text()
	
	coffin_1.position = Vector3(-5,0,0)
	coffin_2.position = Vector3(0,0,0)
	coffin_3.position = Vector3(5,0,0)

	
func _on_coffin_interacted(coffin):
	if coffin.answer == bat_count:
		print("Correct!")
		coffin_1.hide()
		coffin_2.hide()
		coffin_3.hide()
		position = Vector3(0,-20,0)
		if Manager.mode == "explore":
			cutscene_manager.vampire_cutscene_coffinshuffle_1()
		else:
			cutscene_manager.vampire_cutscene_coffinshuffle_2()
	else:
		print("Wrong!")
		win_lost_manager.lose()
	
	

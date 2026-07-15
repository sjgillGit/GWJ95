extends Node3D

@onready var spawner = $BatCounterSpawner

var bat_count := 0
var answer_options = []


func _ready() -> void:
	spawner.bat_spawned.connect(_on_bat_spawned)
	spawner.spawning_finished.connect(_on_spawning_finished)

	var total_bats = randi_range(10,20)

	spawner.total_bats = total_bats
	spawner.direction = "left"
	spawner.spawn_delay = 0.4

	spawner.start_spawning()


func _on_bat_spawned():
	bat_count += 1


func _on_spawning_finished():
	print("Finished spawning!")
	print("Total bats:", bat_count)

	generate_answers(bat_count)

func generate_answers(bat_count):
	pass

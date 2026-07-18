extends Node3D

signal bat_spawned
signal spawning_finished


@export var bat_scene: PackedScene

var total_bats := 12
var spawn_delay := 0.4

var bats_spawned := 0
var spawning := false


func start_spawning():
	bats_spawned = 0
	spawning = true
	spawn_loop()


func spawn_loop():
	while spawning and bats_spawned < total_bats:
		spawn_bat()
		bats_spawned += 1
		bat_spawned.emit()

		await get_tree().create_timer(spawn_delay).timeout
	
	spawning = false
	spawning_finished.emit()


func spawn_bat():
	var bat = bat_scene.instantiate()
	add_child(bat)

	bat.facing = "left" if Manager.mode == "explore" else ["left", "right"].pick_random()
	
	if bat.facing == "left":
		bat.position = Vector3(15, randf_range(0, 5), randf_range(-3, 3))
	else:
		bat.position = Vector3(-15, randf_range(0, 5), randf_range(-3, 3))

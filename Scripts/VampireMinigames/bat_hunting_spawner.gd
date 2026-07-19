extends Node3D

@export var bat_scene: PackedScene


var total_waves = 3
var bats_per_wave = 3

var bat_delay = 0.5
var wave_delay = 2.0

var current_wave = 0
var bats_alive = 0



func _ready() -> void:
	start_waves()


func start_waves():
	while current_wave < total_waves:
		current_wave += 1
		
		
		await spawn_wave()
		
		# wait until all bats are gone
		while bats_alive > 0:
			await get_tree().process_frame
		
		
		await get_tree().create_timer(wave_delay).timeout
	


func spawn_wave():
	for i in range(bats_per_wave):
		spawn_bat()
		
		await get_tree().create_timer(bat_delay).timeout


func spawn_bat():
	var bat = bat_scene.instantiate()
	add_child(bat)
	
	var rand_direction = ["left","right"].pick_random()
	bat.facing = rand_direction
	bat.global_position = position
	
	bats_alive += 1
	


func _on_bat_died():
	bats_alive -= 1

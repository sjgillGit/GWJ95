extends Node3D

@onready var vampire_game: Node3D = $"../VampireGame"
@onready var player: Tetris_player = $"../Player"
@onready var slime_spawner_1: Node3D = $"../Map/Rooms/Treasure Room/SlimeSpawner1"

var stop_movement = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stop_movement == true:
		player.stop_movement = true
	else:
		player.stop_movement = false

func vampire_cutscene_explore():
	stop_movement = true
	print("Vampire: So... another visitor.")
	await wait_for_interact()

	print("Vampire: Let's play a little game.")
	await wait_for_interact()

	print("Vampire: Survive if you can.")
	await wait_for_interact()
	stop_movement = false

	vampire_game.start_counting_1()

	
	
func vampire_cutscene_coffinshuffle_1():
	print("Damn, looks like you can count higher than 10...")
	await wait_for_interact()
	
	print("But try to keep up with this masterful shuffling!")
	await wait_for_interact()
	vampire_game.start_coffinshuffle_1()


func vampire_cutscene_escape():
	pass

func skeleton_cutscene_explore():
	pass

func skeleton_cutscene_escape():
	pass

func treasure_room_cutscene():
	stop_movement = true
	await get_tree().create_timer(0.5).timeout
	slime_spawner_1.spawn_slime()
	stop_movement = false








func wait_for_interact():
	while true:
		await get_tree().process_frame

		if Input.is_action_just_pressed("Interact"):
			return

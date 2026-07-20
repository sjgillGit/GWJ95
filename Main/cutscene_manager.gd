extends Node3D

@onready var vampire_game: Node3D = $"../VampireGame"
@onready var player = $"../Player"
@onready var slime_spawner_1: Node3D = $"../Map/Rooms/Treasure Room/SlimeSpawner1"

@onready var skeleton_game: Node3D = $"../SkeletonGame"
@onready var textbox: Node2D = $"../Textbox"
@onready var vampire: CharacterBody3D = $"../Vampire"
@onready var skeleton = $"../Skeleton"

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var duo_game: Node3D = $"../DuoGame"


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
	textbox.display_text("Vampire: So... another visitor.")
	await wait_for_interact()

	textbox.display_text("Vampire: Let's play a little game.")
	await wait_for_interact()

	textbox.display_text("Vampire: Survive if you can.")
	await wait_for_interact()
	
	textbox.hide_text()
	
	stop_movement = false
	transition_start()
	
	vampire_game.start_counting_1()

	transition_end()

	
	
func vampire_cutscene_coffinshuffle_1():
	textbox.display_text("Damn, looks like you can count higher than 10...")
	await wait_for_interact()
	
	textbox.display_text("But try to keep up with this masterful shuffling!")
	await wait_for_interact()
	textbox.hide_text()
	vampire_game.start_coffinshuffle_1()



func vampire_cutscene_escape():
	stop_movement = true
	textbox.display_text("I'm Not gonna let you beat me again!!")
	await wait_for_interact()
	textbox.hide_text()
	stop_movement = false
	transition_start()
	vampire_game.start_counting_2()
	transition_end()

func vampire_cutscene_coffinshuffle_2():
	await wait_for_interact()
	textbox.display_text("Damn, looks like you can count higher than 10...")
	await wait_for_interact()
	
	textbox.display_text("But try to keep up with this masterful shuffling!")
	await wait_for_interact()
	textbox.hide_text()
	vampire_game.start_coffinshuffle_2()

func skeleton_cutscene_explore():
	stop_movement = true
	textbox.display_text("IGOTTA BONE TO PICK WITH YA")
	await wait_for_interact()
	textbox.hide_text()
	stop_movement = false
	transition_start()
	skeleton_game.start_tetris_1()
	transition_end()

func skeleton_cutscene_fishing_1():
	textbox.display_text("GRRRRRR, ITS TIME I TEACH YOU A LESSON...")
	await wait_for_interact()
	textbox.display_text("IN THE ULTIMATE DEADLY FISHING GAME!!!")
	await wait_for_interact()
	textbox.hide_text()
	transition_start()
	skeleton_game.start_fishing_1()
	transition_end()

func skeleton_cutscene_escape():
	stop_movement = true
	textbox.display_text("IGOTTA BONE TO PICK WITH YA")
	await wait_for_interact()
	textbox.hide_text()
	stop_movement = false
	transition_start()
	skeleton_game.start_tetris_2()
	transition_end()
	
func skeleton_cutscene_fishing_2():
	textbox.display_text("GRRRRRR, ITS TIME I TEACH YOU A LESSON...")
	await wait_for_interact()
	textbox.display_text("IN THE ULTIMATE DEADLY FISHING GAME!!!")
	await wait_for_interact()
	textbox.hide_text()
	transition_start()
	skeleton_game.start_fishing_2()
	transition_end()






func duo_cutscene_explore():
	stop_movement = true

	vampire.position = Vector3(90,0,-32)
	skeleton.position = Vector3(90,0,-28)
	textbox.display_text("You are strong, but can you take both of us?")
	await wait_for_interact()
	textbox.display_text("I HAVENT FORGIVEN YOU JUST YET!")
	await wait_for_interact()
	textbox.hide_text()
	stop_movement = false

	transition_start()
	duo_game.start_bat_hunt_scene_1()
	transition_end()



func duo_cutscene_escape():
	pass


func treasure_room_cutscene():
	stop_movement = true
	await get_tree().create_timer(0.5).timeout
	slime_spawner_1.spawn_slime()
	stop_movement = false




func transition_start():
	sprite_2d.position = Vector2(650,1100)
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(650, 300), 0.5)

	await tween.finished
	
func transition_end():
	sprite_2d.position = Vector2(650,300)
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(650, -500), 0.5)

	await tween.finished


func wait_for_interact():
	while true:
		await get_tree().process_frame

		if Input.is_action_just_pressed("Interact"):
			return

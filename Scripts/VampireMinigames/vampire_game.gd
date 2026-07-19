extends Node3D

@onready var vampire: CharacterBody3D = $Vampire
@onready var coffinshuffle_scene: Node3D = $CoffinshuffleScene
@onready var counting_scene: Node3D = $CountingScene
@onready var door_symbols_scene: Node3D = $DoorSymbolsScene
@onready var bat_hunt_scene: Node3D = $BatHuntScene

@onready var player = $"../Player"
@onready var camera_3d: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_counting_1(): #this one will be both the bat counting and the coffinshuffle
	Manager.current_enemy = "vampire"
	Manager.setting = "arena"
	player.position = Vector3(30,0,150)
	camera_3d.position = Vector3(0,7.5,13)
	await get_tree().create_timer(1).timeout
	vampire.hide()
	await get_tree().create_timer(0.5).timeout
	vampire.position = Vector3(0,1,-10)
	vampire.show()
	counting_scene.start_game()

func start_coffinshuffle_1():
	coffinshuffle_scene.position = Vector3(0,0,0)
	coffinshuffle_scene.show_coffins()
	await get_tree().create_timer(0.5).timeout
	vampire.position = coffinshuffle_scene.coffin_positions[coffinshuffle_scene.correct_coffin] if Manager.mode == "explore" else coffinshuffle_scene.coffin_positions_escape[coffinshuffle_scene.correct_coffin]
	vampire.position.z += 4
	await get_tree().create_timer(0.5).timeout
	var target = vampire.position + Vector3(0, 0, -4)
	var tween = create_tween()
	tween.tween_property(vampire, "position", target, 0.3)
	await get_tree().create_timer(0.5).timeout
	vampire.hide()
	print("game started")
	coffinshuffle_scene.start_game()

func reverse_to_map_1():
	Manager.vampire_key = true
	Manager.setting = "map"
	player.position = Vector3(30,0,-30)
	Manager.current_enemy = ""
	
	

func vampire_cutscene_coffinshuffle_2():
	pass

	




func wait_for_interact():
	while true:
		await get_tree().process_frame

		if Input.is_action_just_pressed("Interact"):
			return

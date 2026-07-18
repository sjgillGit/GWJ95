extends Node3D

@onready var vampire: CharacterBody3D = $Vampire
@onready var coffinshuffle_scene: Node3D = $CoffinshuffleScene
@onready var counting_scene: Node3D = $CountingScene
@onready var door_symbols_scene: Node3D = $DoorSymbolsScene
@onready var bat_hunt_scene: Node3D = $BatHuntScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	
	vampire.position = Vector3(0,0,0)
	
	print("Vampire: So... another visitor.")
	await wait_for_interact()

	print("Vampire: Let's play a little game.")
	await wait_for_interact()

	print("Vampire: Survive if you can.")
	await wait_for_interact()
	
	coffinshuffle_scene.start_game()
	print("Can you find where I am?")
	




func wait_for_interact():
	while true:
		await get_tree().process_frame

		if Input.is_action_just_pressed("Interact"):
			return

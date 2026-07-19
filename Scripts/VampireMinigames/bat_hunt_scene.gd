extends Node3D

@onready var bat_hunting_spawner: Node3D = $BatHuntingSpawner
@onready var camera_3d: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	camera_3d.make_current()
	show()
	bat_hunting_spawner.start_waves()
	
	

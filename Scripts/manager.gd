extends Node3D

var mode = "explore" #explore or escape
@onready var VampireGame = $VampireGame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(VampireGame)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	pass
func skeleton():
	pass
func vampire():
	VampireGame.start()
func treasure():
	pass

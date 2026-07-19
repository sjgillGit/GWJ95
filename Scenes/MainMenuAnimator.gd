extends AnimationPlayer

@export var menu2D: Control

func _ready():
	menu2D.game_starting.connect(on_game_starting)

func on_game_starting():
	menu2D.visible = false
	play("stf_exterior/GameStartAnim")

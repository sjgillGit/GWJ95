extends AnimationPlayer

@export var menu2D: Control
@export var menu3D: Node3D

func _ready():
	menu2D.game_starting.connect(on_game_starting)

func on_game_starting():
	menu2D.visible = false
	play("stf_exterior/GameStartAnim")

func on_start_anim_complete():
	menu3D.visible = false
	menu2D.begin_game()

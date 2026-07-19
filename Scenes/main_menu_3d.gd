extends Node3D


@export var menu2D: Control

func _ready():
	menu2D.game_starting.connect(on_game_starting)

func on_game_starting():
	menu2D.visible = false
	await get_tree().create_timer(9.5).timeout
	self.visible = false

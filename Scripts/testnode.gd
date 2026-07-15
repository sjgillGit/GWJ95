extends CharacterBody3D


@export var controller = "player"

const SPEED = 2.0

func _physics_process(delta: float) -> void:
	if controller ==  "player":
		if Input.is_action_pressed("ui_up"):
			position.z += -SPEED 
		if Input.is_action_pressed("ui_down"):
			position.z -= -SPEED 

			

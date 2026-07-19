extends Node3D

@export var player_controller: CharacterBody3D

var xz: Vector3

func _process(delta):
	xz = Vector3(player_controller.velocity.x, 0, player_controller.velocity.z)
	if xz.length_squared() > 0.1:
		look_at(global_position - xz)
		

extends Node3D

@export var player_controller: CharacterBody3D
@export var player_controlled: bool = true
@export var anim_walking: bool = false


var xz: Vector3

func _process(delta):
	if player_controlled && player_controller != null:
		xz = Vector3(player_controller.velocity.x, 0, player_controller.velocity.z)
		anim_walking = xz.length_squared() > 0.1
		if anim_walking:
			look_at(global_position - xz)
			

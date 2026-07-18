extends CharacterBody3D

signal reached_end

@export var speed := 8.0

var target_position: Vector3

func _physics_process(delta):
	global_position = global_position.move_toward(target_position, speed * delta)

	if global_position.distance_to(target_position) < 0.1:
		global_position = target_position
		reached_end.emit()
		set_physics_process(false)

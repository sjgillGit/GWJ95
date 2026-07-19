extends CharacterBody3D

signal reached_end

@export var speed := 8.0

var target_position: Vector3
var start_position: Vector3
var moving := true


func _ready():
	start_position = global_position


func _physics_process(delta):
	if not moving:
		return

	global_position = global_position.move_toward(target_position, speed * delta)

	if global_position.distance_to(target_position) < 0.1:
		global_position = target_position
		moving = false
		reached_end.emit()


func reset_movement():
	global_position = start_position
	moving = true
	set_physics_process(true)

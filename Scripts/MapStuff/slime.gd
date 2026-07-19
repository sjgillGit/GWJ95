extends CharacterBody3D

signal reached_end
signal escape_triggered

@export var speed := 3.0

var target_position: Vector3
var start_position: Vector3
var moving := true


func _ready():
	$Area3D.body_entered.connect(_on_escape_area_entered)


func _on_escape_area_entered(body: Node3D):
	if body.is_in_group("player"):
		print("slime touched player")
		escape_triggered.emit()


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

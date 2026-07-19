extends Area3D

@onready var camera: Camera3D = $"../../../../Camera3D"
@onready var VampireGame: Node3D = $"../../../../VampireGame"


@export var lerp_speed := 10.0

var target_position: Vector3
var moving := false


func _ready():
	target_position = camera.global_position


func _process(delta):
	if Manager.setting == "map":
		if moving:
			#print(target_position)
			camera.global_position = camera.global_position.lerp(
				target_position,
				lerp_speed * delta
			)


func _on_body_entered(body):
	if body.is_in_group("player"):
		var room = get_parent()
		target_position = room.camera_pos
		print(target_position)
		moving = true
		room.detect_special()

			 


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		moving = false

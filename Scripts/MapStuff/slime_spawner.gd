extends Node3D

@export var slime_scene: PackedScene
@export var start_marker: Vector3
@export var end_marker: Vector3
@export var next_spawner: Node3D

signal slime_finished

func spawn_slime():
	var slime = slime_scene.instantiate()

	add_child(slime)

	slime.global_position = start_marker
	slime.target_position = end_marker

	slime.reached_end.connect(_on_slime_finished)

func _on_slime_finished():
	slime_finished.emit()

	if next_spawner:
		next_spawner.spawn_slime()

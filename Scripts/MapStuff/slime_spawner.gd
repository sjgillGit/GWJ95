extends Node3D

@export var slime_scene: PackedScene
@export var start_marker: Vector3
@export var end_marker: Vector3
@export var next_spawner: Node3D

signal slime_finished

var current_slime: Node3D


func spawn_slime():
	current_slime = slime_scene.instantiate()

	add_child(current_slime)

	current_slime.global_position = start_marker
	current_slime.target_position = end_marker

	current_slime.reached_end.connect(_on_slime_finished)


func _on_slime_finished():
	slime_finished.emit()

	if next_spawner:
		next_spawner.spawn_slime()


func reset_slime():
	# If this spawner currently has a slime
	if current_slime:
		current_slime.global_position = start_marker
		
		# Reset slime movement
		if current_slime.has_method("reset_movement"):
			current_slime.reset_movement()
		else:
			# fallback if you don't have a reset function
			current_slime.target_position = end_marker

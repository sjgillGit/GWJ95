extends Node3D

@export var slime_scene: PackedScene
@export var start_marker: Vector3
@export var end_marker: Vector3
@export var next_spawner: Node3D

signal slime_finished
signal escape_reset

var current_slime: Node3D = null
var active := false


func spawn_slime():
	if active:
		return

	active = true

	current_slime = slime_scene.instantiate()
	add_child(current_slime)

	current_slime.global_position = start_marker
	current_slime.start_position = start_marker
	current_slime.target_position = end_marker

	current_slime.reached_end.connect(_on_slime_finished)
	current_slime.escape_triggered.connect(_on_escape_triggered)


func _on_escape_triggered():
	escape_reset.emit()


func _on_slime_finished():
	#clear_slime()

	if next_spawner:
		next_spawner.spawn_slime()


func clear_slime():
	if current_slime:
		current_slime.queue_free()
		current_slime = null

	active = false


func reset_chain():
	# Delete this spawner's slime
	clear_slime()

	# Tell the next spawners to delete theirs
	if next_spawner:
		next_spawner.reset_chain()

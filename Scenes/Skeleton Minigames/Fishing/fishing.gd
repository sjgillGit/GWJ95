#extends Node2D
#
#var floaters_in_water : Array[RigidBody2D] = []
#
#func _ready():
	#$Background/Underwater/Floater.apply_central_impulse(Vector2(1,-1)*300)
#
#func _physics_process(delta: float) -> void:
	#pass
#
#func _on_floating_area_body_entered(body: Node2D) -> void:
	#if body.is_in_group('Floater'):
		#floaters_in_water.append(body)
		#body.sleeping = true
		#body.get_child(0).visible = true
		#print('added floater')
#
#
#func _on_floating_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group('Floater') and floaters_in_water.has(body):
		#floaters_in_water.erase(body)
		#print('removed floater')

extends Node2D

var floaters_in_water : Array[RigidBody2D] = []

var lost := false
var target_floaters := 1
var win := false

@onready var skeleton_game: Node = $".."
@onready var camera_2d: Camera2D = $Camera2D


func _ready():
	# No starting logic here anymore
	hide()
	pass


func start_game():
	show()
	camera_2d.make_current()
	lost = false
	win = false
	floaters_in_water.clear()

	# Difficulty based on mode
	if Manager.mode == "explore":
		target_floaters = 1
	else: # escape
		target_floaters = 3

	# Example starting action
	$Background/Underwater/Floater.apply_central_impulse(Vector2(1, -1) * 300)


func _physics_process(delta: float) -> void:
	if lost or win:
		return

	check_win()


func check_win():
	if floaters_in_water.size() >= target_floaters:
		win = true
		print("Victory")

		hide()
		skeleton_game.temporary_win_function()


func _on_floating_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Floater"):
		if !floaters_in_water.has(body):
			floaters_in_water.append(body)

			body.sleeping = true
			body.get_child(0).visible = true

			print("added floater")


func _on_floating_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Floater") and floaters_in_water.has(body):
		floaters_in_water.erase(body)
		print("removed floater")

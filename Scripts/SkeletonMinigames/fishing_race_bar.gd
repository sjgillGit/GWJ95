extends Node2D

@onready var fishing_bar = $FishingBar
@onready var skeleton_game: Node = $".."
@onready var camera_2d: Camera2D = $Camera2D


var fish_caught := 0
var fish_goal := 3
var playing := false

var time_limit := 30.0
var time_left := 0.0


func _ready():
	hide()

	fishing_bar.fish_attempt.connect(_on_fish_attempt)


func start_game():
	show()
	camera_2d.make_current()

	playing = true
	fish_caught = 0

	if Manager.mode == "explore":
		fish_goal = 3
		time_limit = 30.0
		fishing_bar.set_difficulty(1000, 120)
	else:
		fish_goal = 5
		time_limit = 20.0
		fishing_bar.set_difficulty(1600, 80)

	time_left = time_limit

	fishing_bar.start()


func _process(delta):
	if !playing:
		return

	time_left -= delta

	if time_left <= 0:
		lose()


func _on_fish_attempt(success: bool):
	if !playing:
		return

	if success:
		fish_caught += 1
		print("Caught:", fish_caught, "/", fish_goal)

		if fish_caught >= fish_goal:
			victory()
			return

	else:
		print("Miss")

	await get_tree().create_timer(0.5).timeout

	if playing:
		fishing_bar.start()


func victory():
	playing = false
	fishing_bar.stop()

	print("Fishing victory")

	hide()
	if Manager.mode == "explore":
		skeleton_game.reverse_to_map_1()
	else:
		skeleton_game.reverse_to_map_2()


func lose():
	playing = false
	fishing_bar.stop()

	print("Fishing failed")

	hide()

	# Put your failure behavior here
	# skeleton_game.temporary_loss_function()
